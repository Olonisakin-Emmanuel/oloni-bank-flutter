import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../services/receipt_service.dart';
import '../utils/money_formatter.dart';
import 'dashboard_screen.dart';
import 'receipt_preview_screen.dart';

class DepositSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> account;
  final double amountDeposited;
  final double newBalance;
  final dynamic transactionId;

  const DepositSuccessScreen({
    super.key,
    required this.account,
    required this.amountDeposited,
    required this.newBalance,
    required this.transactionId,
  });

  Future<void> generateReceipt(BuildContext context) async {
    final transactionDateTime = DateTime.now();

    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a')
        .format(transactionDateTime);

    final pdfBytes = await ReceiptService.generateReceipt(
      customerName: account['name'].toString(),
      accountNumber: account['account_number'].toString(),
      amountDeposited: amountDeposited,
      transactionDateTime: formattedDate,
      transactionId: transactionId,
    );

    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'OloniBank_Receipt_$transactionId.pdf',
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
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
      width: 88,
      height: 88,
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
          child: Icon(Icons.check_rounded, color: Color(0xFFFFA63D), size: 46),
        ),
      ),
    );
  }

  Widget _buildAmountCard() {
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
            'AMOUNT DEPOSITED',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            formatNaira(amountDeposited),
            style: const TextStyle(
              color: Color(0xFFFFA63D),
              fontSize: 31,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.greenAccent.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.greenAccent.withValues(alpha: 0.12),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.greenAccent,
                  size: 14,
                ),
                SizedBox(width: 5),
                Text(
                  'Successfully deposited',
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

  Widget _buildTransactionDetails(String formattedDate) {
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
          _buildDetailRow(label: 'Amount', value: formatNaira(amountDeposited)),

          _buildDetailRow(label: 'New Balance', value: formatNaira(newBalance)),

          _buildDetailRow(label: 'Date & Time', value: formattedDate),

          _buildDetailRow(
            label: 'Transaction ID',
            value: '$transactionId',
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 57,
      child: OutlinedButton(
        onPressed: () {
          final transactionDateTime = DateTime.now();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReceiptPreviewScreen(
                account: account,
                amountDeposited: amountDeposited,
                transactionDateTime: DateFormat('dd MMM yyyy, hh:mm a')
                    .format(transactionDateTime),
                transactionId: transactionId,
              ),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(
            color: const Color(0xFFFF8A00).withValues(alpha: 0.75),
            width: 1.2,
          ),
          backgroundColor: const Color(0xFFFF8A00).withValues(alpha: 0.03),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 21,
              color: Color(0xFFFFA63D),
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

  Widget _buildDashboardButton(BuildContext context) {
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
    final transactionDateTime = DateTime.now();

    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a')
        .format(transactionDateTime);

    final customerName = account['name']?.toString() ?? 'there';

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
              top: 230,
              left: -100,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF8A2BE2).withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Column(
                  children: [
                    const Text(
                      'Deposit Successful',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 28),

                    _buildSuccessBadge(),

                    const SizedBox(height: 22),

                    Text(
                      'Deposit Successful!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 29,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Welcome back, $customerName',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 9),

                    const Text(
                      'Your money has been added to your account successfully.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 25),

                    _buildAmountCard(),

                    const SizedBox(height: 16),

                    _buildTransactionDetails(formattedDate),

                    const SizedBox(height: 20),

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
                            Icons.lock_outline_rounded,
                            color: Color.fromARGB(255, 255, 255, 255),
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Your transaction has been securely recorded.',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 11,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildReceiptButton(context),

                    const SizedBox(height: 11),

                    _buildDashboardButton(context),

                    const SizedBox(height: 8),
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
