import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../utils/money_formatter.dart';
import 'transaction_detail_screen.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  List<Map<String, dynamic>> transactions = [];

  bool isLoadingTransactions = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

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

  Future<void> loadTransactions() async {
    setState(() {
      isLoadingTransactions = true;
      hasError = false;
    });

    try {
      final result = await ApiService().getTransactions();

      if (!mounted) return;

      if (result != null) {
        setState(() {
          transactions = List<Map<String, dynamic>>.from(
            result['transactions'] ?? [],
          );

          isLoadingTransactions = false;
        });
      } else {
        setState(() {
          isLoadingTransactions = false;
          hasError = true;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingTransactions = false;
        hasError = true;
      });
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

  Color _getIconColor(bool isCredit) {
    return isCredit ? Colors.greenAccent : const Color(0xFFFF8A00);
  }

  Widget _buildHeader() {
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
            'Transaction History',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
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

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0A20),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: const Color(0xFF8A2BE2).withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8A2BE2).withValues(alpha: 0.06),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFF8A00).withValues(alpha: 0.08),
              border: Border.all(
                color: const Color(0xFFFF8A00).withValues(alpha: 0.22),
              ),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Color(0xFFFFA63D),
              size: 25,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Activity',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),

                const SizedBox(height: 4),

                Text(
                  '${transactions.length} transaction${transactions.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const Icon(Icons.history_rounded, color: Color(0xFFB56CFF), size: 24),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final type = transaction['transaction_type']?.toString() ?? '';

    final amount = double.tryParse(transaction['amount'].toString()) ?? 0;

    final description = transaction['description']?.toString() ?? '';

    final transactionDate = transaction['transaction_date']?.toString() ?? '';

    final direction = transaction['direction']?.toString() ?? 'debit';

    final isCredit = direction == 'credit';

    final icon = _getTransactionIcon(type);
    final iconColor = _getIconColor(isCredit);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TransactionDetailScreen(transaction: transaction),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0A20),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: isCredit
                ? Colors.greenAccent.withValues(alpha: 0.13)
                : const Color(0xFF8A2BE2).withValues(alpha: 0.18),
          ),
        ),
        child: Row(
          children: [
            // TRANSACTION ICON
            Container(
              width: 49,
              height: 49,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withValues(alpha: 0.08),
                border: Border.all(color: iconColor.withValues(alpha: 0.18)),
              ),
              child: Icon(icon, color: iconColor, size: 23),
            ),

            const SizedBox(width: 13),

            // DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          type.isEmpty ? 'Transaction' : type,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: iconColor.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isCredit ? 'CREDIT' : 'DEBIT',
                          style: TextStyle(
                            color: iconColor,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  Text(
                    description.isEmpty ? 'Bank transaction' : description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    formatTransactionDate(transactionDate),
                    style: const TextStyle(color: Colors.white24, fontSize: 10),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // AMOUNT
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isCredit ? '+' : '-'}${formatNaira(amount)}',
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white24,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF100A24),
                border: Border.all(
                  color: const Color(0xFF8A2BE2).withValues(alpha: 0.25),
                ),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color: Color(0xFFB56CFF),
                size: 42,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'No transactions yet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Your deposits, withdrawals and transfers will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white38,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF100A24),
                border: Border.all(
                  color: const Color(0xFFFF8A00).withValues(alpha: 0.25),
                ),
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: Color(0xFFFFA63D),
                size: 37,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Unable to load transactions',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 13),
            ),

            const SizedBox(height: 20),

            OutlinedButton(
              onPressed: loadTransactions,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(
                  color: const Color(0xFF8A2BE2).withValues(alpha: 0.45),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: _buildHeader(),
                ),

                const SizedBox(height: 22),

                Expanded(
                  child: isLoadingTransactions
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Color(0xFFFF8A00),
                                ),
                              ),
                              SizedBox(height: 14),
                              Text(
                                'Loading transactions...',
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      : hasError
                      ? _buildErrorState()
                      : transactions.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          color: const Color(0xFFFF8A00),
                          backgroundColor: const Color(0xFF0F0A20),
                          onRefresh: loadTransactions,
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                            children: [
                              _buildSummaryCard(),

                              const SizedBox(height: 18),

                              const Text(
                                'Recent Activity',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 11),

                              ...transactions.map(_buildTransactionItem),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
