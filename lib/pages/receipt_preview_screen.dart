import 'package:flutter/material.dart';

import '../utils/money_formatter.dart';

class ReceiptPreviewScreen extends StatelessWidget {
  final Map<String, dynamic> account;

  // Deposit data
  final double amountDeposited;

  // Common transaction data
  final String transactionDateTime;
  final dynamic transactionId;

  // Transaction type
  final String transactionType;

  // Transfer data
  final String? recipientName;
  final String? recipientAccountNumber;

  const ReceiptPreviewScreen({
    super.key,
    required this.account,
    required this.amountDeposited,
    required this.transactionDateTime,
    required this.transactionId,
    this.transactionType = 'Deposit',
    this.recipientName,
    this.recipientAccountNumber,
  });

  Widget _buildReceiptRow({
    required String label,
    required String value,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
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

  @override
  Widget build(BuildContext context) {
    final isTransfer = transactionType == 'Transfer';
    final isWithdrawal = transactionType == 'Withdrawal';

    String amountLabel;

    if (isTransfer) {
      amountLabel = 'Amount Transferred';
    } else if (isWithdrawal) {
      amountLabel = 'Amount Withdrawn';
    } else {
      amountLabel = 'Amount Deposited';
    }

    return Scaffold(
      backgroundColor: const Color(0xFF050117),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Receipt',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF0F0A20),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF8A2BE2).withValues(alpha: 0.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8A2BE2).withValues(alpha: 0.10),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Image.asset('assets/images/oloni_logo1.png', width: 135),

                  const SizedBox(height: 20),

                  const Text(
                    'TRANSACTION RECEIPT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '$transactionType Transaction',
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16351F),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.45),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.greenAccent,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'SUCCESSFUL',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    formatNaira(amountDeposited),
                    style: const TextStyle(
                      color: Color(0xFFFF8A00),
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    amountLabel,
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),

                  const SizedBox(height: 30),

                  _buildReceiptRow(
                    label: 'Customer Name',
                    value: account['name'].toString(),
                  ),

                  _buildReceiptRow(
                    label: 'Account Number',
                    value: account['account_number'].toString(),
                  ),

                  // TRANSFER-ONLY INFORMATION
                  if (isTransfer) ...[
                    _buildReceiptRow(
                      label: 'Recipient',
                      value: recipientName ?? '',
                    ),

                    _buildReceiptRow(
                      label: 'Recipient Account',
                      value: recipientAccountNumber ?? '',
                    ),
                  ],

                  _buildReceiptRow(
                    label: 'Transaction Type',
                    value: transactionType,
                  ),

                  _buildReceiptRow(
                    label: 'Date & Time',
                    value: transactionDateTime,
                  ),

                  _buildReceiptRow(
                    label: 'Transaction ID',
                    value: transactionId.toString(),
                    showDivider: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Your money. Your control.',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
