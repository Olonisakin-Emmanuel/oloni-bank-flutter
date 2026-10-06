import 'package:flutter/material.dart';

import '../utils/money_formatter.dart';
import '../services/api_service.dart';
import 'deposit_success_screen.dart';

class DepositScreen extends StatefulWidget {
  final Map<String, dynamic> account;

  const DepositScreen({super.key, required this.account});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final TextEditingController amountController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _setAmount(double amount) {
    setState(() {
      amountController.text = amount.toStringAsFixed(0);
      amountController.selection = TextSelection.fromPosition(
        TextPosition(offset: amountController.text.length),
      );
    });
  }

  Widget _buildAmountButton(double amount) {
    return Expanded(
      child: GestureDetector(
        onTap: isLoading ? null : () => _setAmount(amount),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFF0D0820),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFF8A2BE2).withValues(alpha: 0.40),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8A2BE2).withValues(alpha: 0.06),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              formatNaira(amount),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _depositMoney() async {
    FocusScope.of(context).unfocus();

    final enteredAmount = amountController.text.trim();

    if (enteredAmount.isEmpty) {
      _showMessage('Please enter a deposit amount');
      return;
    }

    final amount = double.tryParse(enteredAmount);

    if (amount == null || amount <= 0) {
      _showMessage('Please enter a valid amount');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiService().deposit(amount);

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (result['success'] == true) {
        final depositData = result['data'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DepositSuccessScreen(
              account: widget.account,
              amountDeposited: (depositData['amount_deposited'] as num)
                  .toDouble(),
              newBalance: (depositData['new_balance'] as num).toDouble(),
              transactionId: depositData['transaction_id'],
            ),
          ),
        );
      } else {
        final message =
            result['message']?.toString() ??
            'Deposit failed. Please try again.';

        _showMessage(message);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showMessage(
        'Unable to process deposit. Please check your connection and try again.',
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF1C1630),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final balance = widget.account['balance'];

    return Scaffold(
      backgroundColor: const Color(0xFF050117),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: isLoading
              ? null
              : () {
                  Navigator.pop(context);
                },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: const Text(
          'Deposit Money',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            right: -100,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF8A2BE2).withValues(alpha: 0.16),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 300,
            left: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFF8A00).withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroCard(),

                const SizedBox(height: 28),

                const Text(
                  'Add Money to Your Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'Deposit instantly and keep your dreams moving.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 22),

                _buildBalanceCard(balance),

                const SizedBox(height: 30),

                const Text(
                  'Enter Amount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                _buildAmountInput(),

                const SizedBox(height: 17),

                const Text(
                  'Quick Amounts',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    _buildAmountButton(5000),
                    const SizedBox(width: 8),
                    _buildAmountButton(10000),
                    const SizedBox(width: 8),
                    _buildAmountButton(20000),
                  ],
                ),

                const SizedBox(height: 30),

                _buildDepositButton(),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 14,
                      color: Colors.white24,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Your transaction is securely processed',
                      style: TextStyle(color: Colors.white30, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return SizedBox(
      height: 205,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/balance_city1.png',
                fit: BoxFit.cover,
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x30050117),
                      Color(0x85050117),
                      Color(0xF5050117),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: -45,
              right: -35,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFF8A00).withValues(alpha: 0.22),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: -55,
              left: -40,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF8A2BE2).withValues(alpha: 0.18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/oloni_logo1.png', width: 145),

                  const SizedBox(height: 10),

                  const Text(
                    'Your money. Your control.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(dynamic balance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: const Color(0xFF100A24),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF8A2BE2).withValues(alpha: 0.30),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8A2BE2).withValues(alpha: 0.08),
            blurRadius: 22,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF8A00).withValues(alpha: 0.16),
                  const Color(0xFFFF4FA3).withValues(alpha: 0.08),
                ],
              ),
              border: Border.all(
                color: const Color(0xFFFF8A00).withValues(alpha: 0.35),
              ),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Color(0xFFFFA63D),
              size: 26,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Balance',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  formatNaira(balance),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.greenAccent.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.greenAccent.withValues(alpha: 0.12),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.greenAccent,
                  size: 14,
                ),
                SizedBox(width: 4),
                Text(
                  'Active',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8A2BE2).withValues(alpha: 0.08),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        controller: amountController,
        enabled: !isLoading,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.done,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 29,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        cursorColor: const Color(0xFFFF8A00),
        decoration: InputDecoration(
          prefixText: '₦ ',
          prefixStyle: const TextStyle(
            color: Color(0xFFFFA63D),
            fontSize: 29,
            fontWeight: FontWeight.w700,
          ),
          hintText: '0.00',
          hintStyle: const TextStyle(
            color: Colors.white24,
            fontSize: 29,
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: const Color(0xFF0D0820),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: const Color(0xFF8A2BE2).withValues(alpha: 0.32),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFFFF8A00), width: 1.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
          ),
        ),
      ),
    );
  }

  Widget _buildDepositButton() {
    return SizedBox(
      width: double.infinity,
      height: 59,
      child: ElevatedButton(
        onPressed: isLoading ? null : _depositMoney,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF8A00),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFFF8A00)
              .withValues(alpha: 0.55),
          disabledForegroundColor: Colors.white70,
          elevation: 10,
          shadowColor: const Color(0xFFFF8A00).withValues(alpha: 0.30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: isLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 21,
                    height: 21,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Processing Deposit...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Deposit Money',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_rounded, size: 21),
                ],
              ),
      ),
    );
  }
}
