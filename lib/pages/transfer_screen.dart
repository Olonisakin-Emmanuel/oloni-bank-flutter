import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'transfer_success_screen.dart';

class TransferScreen extends StatefulWidget {
  final Map<String, dynamic> account;

  const TransferScreen({super.key, required this.account});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  bool isLoading = false;
  bool showPinSection = false;
  bool showConfirmation = false;
  bool isPinVisible = false;

  String? recipientName;
  String? recipientAccountNumber;

  @override
  void dispose() {
    accountNumberController.dispose();
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

  Future<void> findRecipient() async {
    FocusScope.of(context).unfocus();

    final accountNumberText = accountNumberController.text.trim();

    if (accountNumberText.isEmpty) {
      _showMessage('Please enter a recipient account number');
      return;
    }

    if (accountNumberText.length != 10) {
      _showMessage('Account number must be 10 digits');
      return;
    }

    final accountNumber = int.tryParse(accountNumberText);

    if (accountNumber == null) {
      _showMessage('Please enter a valid account number');
      return;
    }

    setState(() {
      isLoading = true;
      recipientName = null;
      recipientAccountNumber = null;
      showPinSection = false;
      showConfirmation = false;
    });

    try {
      final recipient = await ApiService().getRecipient(accountNumber);

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (recipient != null) {
        setState(() {
          recipientName = recipient['account_name']?.toString();
          recipientAccountNumber = recipient['account_number']?.toString();
        });
      } else {
        _showMessage(
          'Recipient account not found. Please check the account number.',
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showMessage(
        'Unable to find recipient. Please check your connection and try again.',
      );
    }
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
      showPinSection = true;
    });
  }

  void continueWithPin() {
    FocusScope.of(context).unfocus();

    final pin = pinController.text.trim();

    if (pin.isEmpty) {
      _showMessage('Please enter your 4-digit PIN');
      return;
    }

    if (pin.length != 4) {
      _showMessage('PIN must be exactly 4 digits');
      return;
    }

    if (int.tryParse(pin) == null) {
      _showMessage('PIN must contain numbers only');
      return;
    }

    setState(() {
      showConfirmation = true;
    });
  }

  Future<void> sendTransfer() async {
    FocusScope.of(context).unfocus();

    final amount = double.tryParse(amountController.text.trim());
    final recipientAccount = int.tryParse(recipientAccountNumber ?? '');
    final pin = pinController.text.trim();

    if (amount == null || recipientAccount == null || pin.length != 4) {
      _showMessage('Transfer details are incomplete');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiService().transfer(
        recipientAccountNumber: recipientAccount,
        amount: amount,
        pin: pin,
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (result['success'] == true) {
        final transferData = result['data'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TransferSuccessScreen(
              transferData: transferData,
              account: widget.account,
            ),
          ),
        );
      } else {
        final message =
            result['message']?.toString() ??
            'Transfer failed. Please try again.';

        _showMessage(message);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showMessage(
        'Unable to process transfer. Please check your connection and try again.',
      );
    }
  }

  Widget _buildAmountButton({required String label, required String amount}) {
    return Expanded(
      child: GestureDetector(
        onTap: isLoading
            ? null
            : () {
                setState(() {
                  amountController.text = amount;
                  amountController.selection = TextSelection.fromPosition(
                    TextPosition(offset: amountController.text.length),
                  );
                });
              },
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
          'Transfer Money',
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
            Icons.swap_horiz_rounded,
            color: Color(0xFFFFA63D),
            size: 23,
          ),
        ),
      ],
    );
  }

  Widget _buildRecipientCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0A20).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: const Color(0xFF8A2BE2).withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8A2BE2).withValues(alpha: 0.08),
            blurRadius: 22,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                color: Color(0xFFFFA63D),
                size: 21,
              ),
              SizedBox(width: 9),
              Text(
                'Recipient Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          TextField(
            controller: accountNumberController,
            enabled: !isLoading,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            maxLength: 10,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            cursorColor: const Color(0xFFFF8A00),
            decoration: InputDecoration(
              counterText: '',
              hintText: 'Enter 10-digit account number',
              hintStyle: const TextStyle(
                color: Colors.white30,
                fontSize: 14,
                letterSpacing: 0,
              ),
              filled: true,
              fillColor: const Color(0xFF080414),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 18,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(17),
                borderSide: BorderSide(
                  color: const Color(0xFF8A2BE2).withValues(alpha: 0.30),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(17),
                borderSide: const BorderSide(
                  color: Color(0xFFFF8A00),
                  width: 1.4,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: isLoading ? null : findRecipient,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8A00),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFFF8A00)
                    .withValues(alpha: 0.55),
                elevation: 8,
                shadowColor: const Color(0xFFFF8A00).withValues(alpha: 0.25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Find Recipient',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
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

  Widget _buildRecipientFoundCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111026),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withValues(alpha: 0.04),
            blurRadius: 18,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF8A00).withValues(alpha: 0.15),
                  const Color(0xFFFF4FA3).withValues(alpha: 0.08),
                ],
              ),
              border: Border.all(
                color: const Color(0xFFFF8A00).withValues(alpha: 0.28),
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Color(0xFFFFA63D),
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recipient verified',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  recipientName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  recipientAccountNumber ?? '',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.verified_rounded,
            color: Colors.greenAccent,
            size: 25,
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transfer Amount',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'How much would you like to send?',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),

          const SizedBox(height: 17),

          TextField(
            controller: amountController,
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

          const SizedBox(height: 18),

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

  Widget _buildPinSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0A20).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: const Color(0xFFFF8A00).withValues(alpha: 0.30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.lock_outline_rounded,
                color: Color(0xFFFFA63D),
                size: 22,
              ),
              SizedBox(width: 9),
              Text(
                'Secure Transfer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          const Text(
            'Enter your 4-digit transaction PIN.',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),

          const SizedBox(height: 17),

          TextField(
            controller: pinController,
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
                color: Color.fromARGB(255, 255, 255, 255),
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

          const SizedBox(height: 17),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: continueWithPin,
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
                    'Review Transfer',
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

  Widget _buildConfirmationSection() {
    final amount = double.tryParse(amountController.text.trim()) ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0A20),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFFF8A00).withValues(alpha: 0.40),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8A00).withValues(alpha: 0.07),
            blurRadius: 25,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'CONFIRM TRANSFER',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Review the details before sending.',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),

          const SizedBox(height: 21),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF080414),
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              children: [
                const Text(
                  'SEND MONEY TO',
                  style: TextStyle(
                    color: Colors.white30,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 9),

                Text(
                  recipientName ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  recipientAccountNumber ?? '',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Amount',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ),

          const SizedBox(height: 4),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '₦${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color(0xFFFFA63D),
                fontSize: 31,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(height: 17),

          Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Transfer Fee',
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),
              Text(
                '₦0.00',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 19),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.greenAccent.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  color: Colors.greenAccent,
                  size: 17,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Recipient verified. Review carefully before confirming.',
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

          const SizedBox(height: 19),

          SizedBox(
            width: double.infinity,
            height: 57,
            child: ElevatedButton(
              onPressed: isLoading ? null : sendTransfer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8A00),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFFF8A00)
                    .withValues(alpha: 0.55),
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
                          'Sending Money...',
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
                        Icon(Icons.send_rounded, size: 21),
                        SizedBox(width: 9),
                        Text(
                          'Confirm & Send',
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
              'Always verify the recipient details before confirming a transfer.',
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
          Positioned.fill(
            child: Image.asset(
              'assets/images/transfer_background.png',
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
                    Color(0x99050117),
                    Color(0xD9050117),
                    Color(0xF5050117),
                  ],
                ),
              ),
            ),
          ),

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
            top: 370,
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

                  Image.asset('assets/images/oloni_logo1.png', width: 108),

                  const SizedBox(height: 25),

                  const Text(
                    'Send Money',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 37,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                      letterSpacing: -0.8,
                    ),
                  ),

                  const SizedBox(height: 3),

                  const Text(
                    'with Confidence',
                    style: TextStyle(
                      color: Color(0xFFFF8A00),
                      fontSize: 37,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                      letterSpacing: -0.8,
                    ),
                  ),

                  const SizedBox(height: 13),

                  const Text(
                    'Verify the recipient, choose an amount, and securely send your money.',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 27),

                  _buildRecipientCard(),

                  if (recipientName != null) ...[
                    const SizedBox(height: 18),
                    _buildRecipientFoundCard(),

                    const SizedBox(height: 18),
                    _buildAmountSection(),
                  ],

                  if (showPinSection) ...[
                    const SizedBox(height: 18),
                    _buildPinSection(),
                  ],

                  if (showConfirmation) ...[
                    const SizedBox(height: 18),
                    _buildConfirmationSection(),
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
