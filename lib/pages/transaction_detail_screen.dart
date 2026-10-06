import 'package:flutter/material.dart';

import '../utils/money_formatter.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  String formatTransactionDate(String date) {
    try {
      final dateTime = DateTime.parse(date);

      final day = dateTime.day.toString().padLeft(2, '0');
      final month = dateTime.month.toString().padLeft(2, '0');
      final year = dateTime.year.toString();

      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');

      final period = hour >= 12 ? 'PM' : 'AM';

      final displayHour = hour % 12 == 0 ? 12 : hour % 12;

      return '$day/$month/$year • $displayHour:$minute $period';
    } catch (_) {
      return 'Date unavailable';
    }
  }

  IconData _getTransactionIcon(String type) {
    switch (type.toLowerCase()) {
      case 'deposit':
        return Icons.south_west_rounded;

      case 'withdrawal':
        return Icons.north_east_rounded;

      case 'transfer':
        return Icons.swap_horiz_rounded;

      default:
        return Icons.receipt_long_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = transaction['transaction_type']?.toString() ?? 'Transaction';

    final amount = double.tryParse(transaction['amount'].toString()) ?? 0;

    final description = transaction['description']?.toString() ?? '';

    final transactionDate = transaction['transaction_date']?.toString() ?? '';

    final transactionId = transaction['transaction_id']?.toString() ?? '';

    final direction = transaction['direction']?.toString() ?? 'debit';

    final isCredit = direction == 'credit';

    final transactionColor = isCredit
        ? Colors.greenAccent
        : const Color(0xFFFF8A00);

    final transactionIcon = _getTransactionIcon(type);

    return Scaffold(
      backgroundColor: const Color(0xFF050117),
      body: Stack(
        children: [
          // ORANGE GLOW
          Positioned(
            top: -90,
            right: -80,
            child: Container(
              width: 240,
              height: 240,
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

          // PURPLE GLOW
          Positioned(
            top: 300,
            left: -110,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF8A2BE2).withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 35),
              child: Column(
                children: [
                  _buildHeader(context),

                  const SizedBox(height: 30),

                  // TRANSACTION ICON
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: transactionColor.withValues(alpha: 0.07),
                      border: Border.all(
                        color: transactionColor.withValues(alpha: 0.28),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: transactionColor.withValues(alpha: 0.10),
                          blurRadius: 28,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: transactionColor.withValues(alpha: 0.07),
                      ),
                      child: Icon(
                        transactionIcon,
                        color: transactionColor,
                        size: 40,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // TYPE
                  Text(
                    type,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 7),

                  // AMOUNT
                  Text(
                    '${isCredit ? '+' : '-'}${formatNaira(amount)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: transactionColor,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 9),

                  // CREDIT / DEBIT BADGE
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: transactionColor.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: transactionColor.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isCredit
                              ? Icons.arrow_downward_rounded
                              : Icons.arrow_upward_rounded,
                          color: transactionColor,
                          size: 14,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isCredit ? 'Money Received' : 'Money Sent',
                          style: TextStyle(
                            color: transactionColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // MAIN DETAILS CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F0A20),
                      borderRadius: BorderRadius.circular(23),
                      border: Border.all(
                        color: const Color(0xFF8A2BE2).withValues(alpha: 0.25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8A2BE2)
                              .withValues(alpha: 0.05),
                          blurRadius: 20,
                        ),
                      ],
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

                        // STATUS
                        _buildStatusRow(),

                        const SizedBox(height: 17),

                        Divider(color: Colors.white.withValues(alpha: 0.07)),

                        const SizedBox(height: 17),

                        _buildDetailRow(
                          'Description',
                          description.isEmpty
                              ? 'Bank transaction'
                              : description,
                        ),

                        const SizedBox(height: 16),

                        _buildDetailRow('Transaction Type', type),

                        const SizedBox(height: 16),

                        _buildDetailRow(
                          'Date & Time',
                          formatTransactionDate(transactionDate),
                        ),

                        const SizedBox(height: 16),

                        _buildDetailRow('Transaction ID', transactionId),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // SECURITY / VERIFICATION CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B071A).withValues(alpha: 0.90),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFF8A2BE2).withValues(alpha: 0.20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.greenAccent.withValues(alpha: 0.07),
                          ),
                          child: const Icon(
                            Icons.verified_rounded,
                            color: Colors.greenAccent,
                            size: 21,
                          ),
                        ),

                        const SizedBox(width: 11),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Transaction Verified',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'This transaction was successfully processed and recorded by Oloni Bank.',
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 11,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // FOOTER
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
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF100A24),
              border: Border.all(
                color: const Color(0xFF8A2BE2).withValues(alpha: 0.40),
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),

        const SizedBox(width: 14),

        const Expanded(
          child: Text(
            'Transaction Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF100A24),
            border: Border.all(
              color: const Color(0xFF8A2BE2).withValues(alpha: 0.40),
            ),
          ),
          child: const Icon(
            Icons.receipt_long_outlined,
            color: Color(0xFFFFA63D),
            size: 21,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow() {
    return Row(
      children: [
        const Text(
          'Status',
          style: TextStyle(color: Colors.white38, fontSize: 12),
        ),

        const Spacer(),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.greenAccent.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(10),
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
                'Successful',
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
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
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
}
