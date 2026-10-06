import 'package:flutter/material.dart';

import '../utils/money_formatter.dart';
import 'dashboard_screen.dart';
import 'receipt_preview_screen.dart';

class WithdrawalSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> withdrawalData;
  final Map<String, dynamic> account;

  const WithdrawalSuccessScreen({
    super.key,
    required this.withdrawalData,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    final amount =
        double.tryParse(withdrawalData['amount_withdrawn'].toString()) ?? 0;

    final newBalance =
        double.tryParse(withdrawalData['new_balance'].toString()) ?? 0;

    final accountNumber = withdrawalData['account_number']?.toString() ?? '';

    final transactionId = withdrawalData['transaction_id']?.toString() ?? '';

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
            // TOP ORANGE GLOW
            Positioned(
              top: -100,
              right: -80,
              child: Container(
                width: 280,
                height: 280,
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

            // PURPLE GLOW
            Positioned(
              top: 250,
              left: -120,
              child: Container(
                width: 260,
                height: 260,
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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 35),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // OLONI LOGO
                    Image.asset('assets/images/oloni_logo1.png', width: 105),

                    const SizedBox(height: 28),

                    // SUCCESS BADGE
                    Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF100A24),
                        border: Border.all(
                          color: const Color(0xFFFF8A00)
                              .withValues(alpha: 0.50),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF8A00)
                                .withValues(alpha: 0.20),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                          BoxShadow(
                            color: const Color(0xFF8A2BE2)
                                .withValues(alpha: 0.18),
                            blurRadius: 35,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFFF8A00).withValues(alpha: 0.18),
                              const Color(0xFF8A2BE2).withValues(alpha: 0.12),
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Color(0xFFFFA63D),
                          size: 54,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // TITLE
                    const Text(
                      'Withdrawal Successful',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Your withdrawal has been completed successfully.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),

                    const SizedBox(height: 26),

                    // AMOUNT CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 23, 20, 23),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F0A20),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: const Color(0xFFFF8A00)
                              .withValues(alpha: 0.35),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF8A00)
                                .withValues(alpha: 0.07),
                            blurRadius: 25,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'AMOUNT WITHDRAWN',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.4,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            formatNaira(amount),
                            style: const TextStyle(
                              color: Color(0xFFFFA63D),
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: Colors.greenAccent,
                                  size: 15,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Transaction completed',
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
                    ),

                    const SizedBox(height: 18),

                    // TRANSACTION DETAILS
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F0A20),
                        borderRadius: BorderRadius.circular(23),
                        border: Border.all(
                          color: const Color(0xFF8A2BE2)
                              .withValues(alpha: 0.25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                color: Color(0xFFB56CFF),
                                size: 21,
                              ),
                              SizedBox(width: 9),
                              Text(
                                'Transaction Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          Divider(color: Colors.white.withValues(alpha: 0.07)),

                          const SizedBox(height: 17),

                          _buildDetailRow('Account Number', accountNumber),

                          const SizedBox(height: 15),

                          _buildDetailRow('Transaction Type', 'Withdrawal'),

                          const SizedBox(height: 15),

                          _buildDetailRow('Date & Time', transactionDateTime),

                          const SizedBox(height: 15),

                          _buildDetailRow('Transaction ID', transactionId),

                          const SizedBox(height: 17),

                          Divider(color: Colors.white.withValues(alpha: 0.07)),

                          const SizedBox(height: 17),

                          _buildDetailRow(
                            'New Balance',
                            formatNaira(newBalance),
                            valueColor: Colors.white,
                            valueWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // SECURITY MESSAGE
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B071A).withValues(alpha: 0.90),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFF8A2BE2)
                              .withValues(alpha: 0.20),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: Color(0xFFB56CFF),
                            size: 23,
                          ),
                          SizedBox(width: 11),
                          Expanded(
                            child: Text(
                              'This transaction has been securely recorded on your account.',
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

                    const SizedBox(height: 23),

                    // VIEW RECEIPT
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReceiptPreviewScreen(
                                account: account,
                                amountDeposited: amount,
                                transactionType: 'Withdrawal',
                                transactionDateTime: transactionDateTime,
                                transactionId: transactionId,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8A00),
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: const Color(0xFFFF8A00)
                              .withValues(alpha: 0.25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long_rounded, size: 21),
                            SizedBox(width: 9),
                            Text(
                              'View Receipt',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // BACK TO DASHBOARD
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () {
                          final updatedAccount = Map<String, dynamic>.from(
                            account,
                          );

                          updatedAccount['balance'] = newBalance;

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DashboardScreen(account: updatedAccount),
                            ),
                            (route) => false,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: const Color(0xFF8A2BE2)
                                .withValues(alpha: 0.40),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.home_outlined, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Back to Dashboard',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      'Your money. Your control.',
                      style: TextStyle(
                        color: Colors.white24,
                        fontSize: 11,
                        letterSpacing: 1.4,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'OLONI BANK',
                      style: TextStyle(
                        color: Colors.white12,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
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

  Widget _buildDetailRow(
    String label,
    String value, {
    Color valueColor = Colors.white,
    FontWeight valueWeight = FontWeight.w600,
  }) {
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
            style: TextStyle(
              color: valueColor,
              fontSize: 13,
              fontWeight: valueWeight,
            ),
          ),
        ),
      ],
    );
  }
}
