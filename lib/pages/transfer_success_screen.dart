import 'package:flutter/material.dart';

import '../utils/money_formatter.dart';
import 'receipt_preview_screen.dart';
import 'dashboard_screen.dart';

class TransferSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> transferData;
  final Map<String, dynamic> account;

  const TransferSuccessScreen({
    super.key,
    required this.transferData,
    required this.account,
  });

  Widget _buildDetailRow({
    required String label,
    required String value,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 15),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
      ],
    );
  }

  Widget _buildSuccessBadge() {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF8A00), Color(0xFFFF4FA3), Color(0xFF8A2BE2)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8A00).withValues(alpha: 0.22),
            blurRadius: 25,
            spreadRadius: 3,
          ),
          BoxShadow(
            color: const Color(0xFF8A2BE2).withValues(alpha: 0.16),
            blurRadius: 35,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF080318),
        ),
        child: const Center(
          child: Icon(Icons.check_rounded, color: Color(0xFFFFA63D), size: 48),
        ),
      ),
    );
  }

  Widget _buildAmountCard(double amount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 21),
      decoration: BoxDecoration(
        color: const Color(0xFF100A24),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFFF8A00).withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'AMOUNT TRANSFERRED',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            formatNaira(amount),
            style: const TextStyle(
              color: Color(0xFFFFA63D),
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8A00).withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFFF8A00).withValues(alpha: 0.12),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: Color(0xFFFFA63D),
                  size: 14,
                ),
                SizedBox(width: 5),
                Text(
                  'Transfer completed',
                  style: TextStyle(
                    color: Color(0xFFFFA63D),
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

  Widget _buildRecipientCard({
    required String recipientName,
    required String recipientAccount,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF080414),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
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
              size: 27,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SENT TO',
                  style: TextStyle(
                    color: Colors.white30,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.4,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  recipientName,
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
                  recipientAccount,
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
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionDetails({
    required String transactionDateTime,
    required String transactionId,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0A20),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: const Color(0xFF8A2BE2).withValues(alpha: 0.22),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8A2BE2).withValues(alpha: 0.07),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(label: 'Transaction Type', value: 'Transfer'),

          _buildDetailRow(label: 'Date & Time', value: transactionDateTime),

          _buildDetailRow(
            label: 'Transaction ID',
            value: transactionId,
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptButton({
    required BuildContext context,
    required double amount,
    required String recipientName,
    required String recipientAccount,
    required String transactionDateTime,
    required String transactionId,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 57,
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReceiptPreviewScreen(
                account: account,
                amountDeposited: amount,
                transactionType: 'Transfer',
                recipientName: recipientName,
                recipientAccountNumber: recipientAccount,
                transactionDateTime: transactionDateTime,
                transactionId: transactionId,
              ),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFFFF8A00).withValues(alpha: 0.03),
          side: BorderSide(
            color: const Color(0xFFFF8A00).withValues(alpha: 0.70),
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              color: Color(0xFFFFA63D),
              size: 21,
            ),
            SizedBox(width: 10),
            Text(
              'View Receipt',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton({
    required BuildContext context,
    required double newBalance,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 59,
      child: ElevatedButton(
        onPressed: () {
          final updatedAccount = Map<String, dynamic>.from(account);

          updatedAccount['balance'] = newBalance;

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(account: updatedAccount),
            ),
            (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF8A00),
          foregroundColor: Colors.white,
          elevation: 10,
          shadowColor: const Color(0xFFFF8A00).withValues(alpha: 0.30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Back to Dashboard',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 9),
            Icon(Icons.arrow_forward_rounded, size: 21),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final amount =
        double.tryParse(transferData['amount_transferred']?.toString() ?? '') ??
        0;

    final recipientName =
        transferData['recipient_name']?.toString() ?? 'Recipient';

    final recipientAccount =
        transferData['recipient_account_number']?.toString() ?? '';

    final transactionId = transferData['transaction_id']?.toString() ?? '';

    final newBalance =
        double.tryParse(transferData['new_balance']?.toString() ?? '') ?? 0;

    final now = DateTime.now();

    final transactionDateTime =
        '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year} '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF050117),
        body: Stack(
          children: [
            Positioned(
              top: -90,
              right: -80,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFF8A00).withValues(alpha: 0.13),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 250,
              left: -100,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF8A2BE2).withValues(alpha: 0.11),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
                child: Column(
                  children: [
                    const Text(
                      'Transfer Successful',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 28),

                    _buildSuccessBadge(),

                    const SizedBox(height: 22),

                    const Text(
                      'Transfer Successful!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 29,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Your money has been sent to $recipientName.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 25),

                    _buildAmountCard(amount),

                    const SizedBox(height: 16),

                    _buildRecipientCard(
                      recipientName: recipientName,
                      recipientAccount: recipientAccount,
                    ),

                    const SizedBox(height: 16),

                    _buildTransactionDetails(
                      transactionDateTime: transactionDateTime,
                      transactionId: transactionId,
                    ),

                    const SizedBox(height: 18),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D0820),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: Colors.white38,
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Your transfer has been securely recorded.',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 11,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildReceiptButton(
                      context: context,
                      amount: amount,
                      recipientName: recipientName,
                      recipientAccount: recipientAccount,
                      transactionDateTime: transactionDateTime,
                      transactionId: transactionId,
                    ),

                    const SizedBox(height: 11),

                    _buildDashboardButton(
                      context: context,
                      newBalance: newBalance,
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Your money. Your control.',
                      style: TextStyle(
                        color: Colors.white24,
                        fontSize: 11,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
