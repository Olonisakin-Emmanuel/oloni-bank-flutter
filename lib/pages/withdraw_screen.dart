import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../utils/money_formatter.dart';
import 'withdrawal_success_screen.dart';

class WithdrawScreen extends StatefulWidget {
  final Map<String, dynamic> account;

  const WithdrawScreen({super.key, required this.account});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  bool showReviewSection = false;
  bool showPinSection = false;
  bool isLoading = false;
  bool isPinVisible = false;

  @override
  void dispose() {
    amountController.dispose();
    pinController.dispose();
    super.dispose();
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

  void continueWithAmount() {
    FocusScope.of(context).unfocus();

    final amountText = amountController.text.trim();

    if (amountText.isEmpty) {
      _showMessage('Please enter an amount');
      return;
    }

    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      _showMessage('Please enter a valid amount');
      return;
    }

    setState(() {
      showReviewSection = true;
      showPinSection = false;
    });
  }

  void continueWithReview() {
    setState(() {
      showPinSection = true;
    });
  }

  Future<void> sendWithdrawal() async {
    FocusScope.of(context).unfocus();

    final amount = double.tryParse(amountController.text.trim());
    final pin = pinController.text.trim();

    if (amount == null || amount <= 0) {
      _showMessage('Please enter a valid withdrawal amount');
      return;
    }

    if (pin.length != 4 || int.tryParse(pin) == null) {
      _showMessage('PIN must be exactly 4 digits');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiService().withdraw(amount: amount, pin: pin);

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (result['success'] == true) {
        final withdrawalData = result['data'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WithdrawalSuccessScreen(
              withdrawalData: withdrawalData,
              account: widget.account,
            ),
          ),
        );
      } else {
        final message =
            result['message']?.toString() ??
            'Withdrawal failed. Please try again.';

        _showMessage(message);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showMessage(
        'Unable to process withdrawal. Please check your connection and try again.',
      );
    }
  }

  void _setAmount(String amount) {
    if (isLoading) return;

    setState(() {
      amountController.text = amount;
      amountController.selection = TextSelection.fromPosition(
        TextPosition(offset: amountController.text.length),
      );
    });
  }

  Widget _buildAmountButton({required String label, required String amount}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _setAmount(amount),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF0D0820),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF8A2BE2).withValues(alpha: 0.35),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: isLoading
              ? null
              : () {
                  Navigator.pop(context);
                },
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF100A24).withValues(alpha: 0.88),
              border: Border.all(
                color: const Color(0xFF8A2BE2).withValues(alpha: 0.45),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8A2BE2).withValues(alpha: 0.12),
                  blurRadius: 16,
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),

        const Text(
          'Withdraw Money',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF100A24).withValues(alpha: 0.88),
            border: Border.all(
              color: const Color(0xFF8A2BE2).withValues(alpha: 0.45),
            ),
          ),
          child: const Icon(
            Icons.account_balance_wallet_outlined,
            color: Color(0xFFFFA63D),
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF100A24).withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: const Color(0xFF8A2BE2).withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFF8A00).withValues(alpha: 0.08),
              border: Border.all(
                color: const Color(0xFFFF8A00).withValues(alpha: 0.25),
              ),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Color(0xFFFFA63D),
              size: 24,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available Balance',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),

                const SizedBox(height: 4),

                Text(
                  formatNaira(widget.account['balance']),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.check_circle_outline_rounded,
            color: Colors.greenAccent,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0A20).withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: const Color(0xFF8A2BE2).withValues(alpha: 0.30),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8A2BE2).withValues(alpha: 0.07),
            blurRadius: 22,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Withdrawal Amount',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Enter the amount you want to withdraw.',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),

          const SizedBox(height: 17),

          TextField(
            controller: amountController,
            enabled: !isLoading,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            style: const TextStyle(
              color: Color(0xFFFFA63D),
              fontSize: 31,
              fontWeight: FontWeight.w700,
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
                fontSize: 31,
                fontWeight: FontWeight.w600,
              ),
              filled: true,
              fillColor: const Color(0xFF080414),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 19,
                vertical: 20,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(19),
                borderSide: BorderSide(
                  color: const Color(0xFF8A2BE2).withValues(alpha: 0.28),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(19),
                borderSide: const BorderSide(
                  color: Color(0xFFFF8A00),
                  width: 1.4,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(19),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Quick Amounts',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),

          const SizedBox(height: 9),

          Row(
            children: [
              _buildAmountButton(label: '₦5,000', amount: '5000'),
              const SizedBox(width: 8),
              _buildAmountButton(label: '₦10,000', amount: '10000'),
              const SizedBox(width: 8),
              _buildAmountButton(label: '₦20,000', amount: '20000'),
            ],
          ),

          const SizedBox(height: 19),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: continueWithAmount,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8A00),
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: const Color(0xFFFF8A00).withValues(alpha: 0.25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 9),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    final amount = double.tryParse(amountController.text.trim()) ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0A20),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: const Color(0xFFFF8A00).withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8A00).withValues(alpha: 0.06),
            blurRadius: 22,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'REVIEW WITHDRAWAL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Please confirm the details before proceeding.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF080414),
              borderRadius: BorderRadius.circular(19),
            ),
            child: Column(
              children: [
                const Text(
                  'WITHDRAWAL AMOUNT',
                  style: TextStyle(
                    color: Colors.white30,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.4,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  formatNaira(amount),
                  style: const TextStyle(
                    color: Color(0xFFFFA63D),
                    fontSize: 29,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 17),

                Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),

                const SizedBox(height: 15),

                _buildReviewRow(
                  label: 'Account Number',
                  value: widget.account['account_number'].toString(),
                ),

                const SizedBox(height: 13),

                _buildReviewRow(
                  label: 'Account Name',
                  value: widget.account['name'].toString(),
                ),

                const SizedBox(height: 13),

                _buildReviewRow(
                  label: 'Account Type',
                  value: widget.account['account_type'].toString(),
                ),

                const SizedBox(height: 13),

                _buildReviewRow(
                  label: 'Current Balance',
                  value: formatNaira(widget.account['balance']),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8A00).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFFFFA63D),
                  size: 17,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your transaction PIN will be required to authorize this withdrawal.',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: continueWithReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8A00),
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: const Color(0xFFFF8A00).withValues(alpha: 0.25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue Securely',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 9),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewRow({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 12),
        ),
        const Spacer(),
        const SizedBox(width: 15),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPinSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0A20),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: const Color(0xFFFF8A00).withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFF8A00).withValues(alpha: 0.08),
              border: Border.all(
                color: const Color(0xFFFF8A00).withValues(alpha: 0.25),
              ),
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: Color(0xFFFFA63D),
              size: 27,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Authorize Withdrawal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Enter your 4-digit transaction PIN to continue.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 13, height: 1.4),
          ),

          const SizedBox(height: 18),

          TextField(
            controller: pinController,
            enabled: !isLoading,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: !isPinVisible,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFFFA63D),
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: 10,
            ),
            cursorColor: const Color(0xFFFF8A00),
            decoration: InputDecoration(
              counterText: '',
              hintText: '••••',
              hintStyle: const TextStyle(
                color: Colors.white24,
                fontSize: 27,
                letterSpacing: 9,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isPinVisible = !isPinVisible;
                  });
                },
                icon: Icon(
                  isPinVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white38,
                ),
              ),
              filled: true,
              fillColor: const Color(0xFF080414),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 20,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(19),
                borderSide: BorderSide(
                  color: const Color(0xFF8A2BE2).withValues(alpha: 0.28),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(19),
                borderSide: const BorderSide(
                  color: Color(0xFFFF8A00),
                  width: 1.4,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 57,
            child: ElevatedButton(
              onPressed: isLoading ? null : sendWithdrawal,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8A00),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFFF8A00)
                    .withValues(alpha: 0.55),
                disabledForegroundColor: Colors.white70,
                elevation: 10,
                shadowColor: const Color(0xFFFF8A00).withValues(alpha: 0.28),
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
                        SizedBox(width: 11),
                        Text(
                          'Processing Withdrawal...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_balance_wallet_outlined, size: 21),
                        SizedBox(width: 9),
                        Text(
                          'Confirm & Withdraw',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B071A).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF8A2BE2).withValues(alpha: 0.20),
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.shield_outlined, color: Color(0xFFB56CFF), size: 23),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your PIN is required to authorize withdrawals securely.',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050117),
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -70,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFF8A00).withValues(alpha: 0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 380,
            left: -100,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF8A2BE2).withValues(alpha: 0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),

                  const SizedBox(height: 27),

                  Center(
                    child: Image.asset(
                      'assets/images/oloni_logo1.png',
                      width: 115,
                    ),
                  ),

                  const SizedBox(height: 26),

                  const Text(
                    'Withdraw with',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 37,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                      letterSpacing: -0.8,
                    ),
                  ),

                  const Text(
                    'Ease',
                    style: TextStyle(
                      color: Color(0xFFFF8A00),
                      fontSize: 37,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                      letterSpacing: -0.8,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Withdraw from your account securely and keep control of your money.',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 24),

                  _buildBalanceCard(),

                  const SizedBox(height: 18),

                  _buildAmountSection(),

                  if (showReviewSection) ...[
                    const SizedBox(height: 18),
                    _buildReviewSection(),
                  ],

                  if (showPinSection) ...[
                    const SizedBox(height: 18),
                    _buildPinSection(),
                  ],

                  const SizedBox(height: 22),

                  _buildSecurityMessage(),

                  const SizedBox(height: 25),

                  const Center(
                    child: Text(
                      'Your money. Your control.',
                      style: TextStyle(
                        color: Colors.white24,
                        fontSize: 11,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
