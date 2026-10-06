import 'package:flutter/material.dart';

import 'profile_screen.dart';
import 'transaction_history_screen.dart';
import 'transfer_screen.dart';
import '../utils/money_formatter.dart';
import 'deposit_screen.dart';
import 'withdraw_screen.dart';
import '../services/api_service.dart';
import 'transaction_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Map<String, dynamic> account;

  const DashboardScreen({super.key, required this.account});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;
  bool isBalanceVisible = true;

  String? transactionError;

  List<Map<String, dynamic>> transactions = [];

  bool isLoadingTransactions = true;

  @override
  void initState() {
    super.initState();

    loadTransactions();
  }

  Future<void> loadTransactions() async {
    setState(() {
      isLoadingTransactions = true;
      transactionError = null;
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
          transactionError = null;
        });
      } else {
        setState(() {
          isLoadingTransactions = false;
          transactionError = 'Unable to load transactions. Please try again.';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingTransactions = false;
        transactionError = 'Unable to load transactions. Please check your connection and try again.';
      });
    }
  }

  Future<void> refreshDashboard() async {
    await loadTransactions();
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 16) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFF8A00),
                    Color(0xFFFF4FA3),
                    Color(0xFF8A2BE2),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF8A00).withValues(alpha: 0.18),
                    blurRadius: 18,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0F0A20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Icon(icon, color: const Color(0xFFFFA63D), size: 26),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final type = transaction['transaction_type']?.toString() ?? '';

    final amount = double.tryParse(transaction['amount'].toString()) ?? 0;

    final description = transaction['description']?.toString() ?? '';

    final direction = transaction['direction']?.toString() ?? 'debit';

    final isCredit = direction == 'credit';

    IconData icon;

    if (type == 'Deposit') {
      icon = Icons.add_rounded;
    } else if (type == 'Transfer') {
      icon = Icons.swap_horiz_rounded;
    } else {
      icon = Icons.arrow_downward_rounded;
    }

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
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isCredit
                ? Colors.greenAccent.withValues(alpha: 0.12)
                : const Color(0xFFFF8A00).withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCredit
                    ? Colors.greenAccent.withValues(alpha: 0.08)
                    : const Color(0xFFFF8A00).withValues(alpha: 0.08),
                border: Border.all(
                  color: isCredit
                      ? Colors.greenAccent.withValues(alpha: 0.15)
                      : const Color(0xFFFF8A00).withValues(alpha: 0.15),
                ),
              ),
              child: Icon(
                icon,
                color: isCredit ? Colors.greenAccent : const Color(0xFFFF8A00),
                size: 22,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isCredit ? '+' : '-'}${formatNaira(amount)}',
                  style: TextStyle(
                    color: isCredit
                        ? Colors.greenAccent
                        : const Color(0xFFFF8A00),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
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

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(account: widget.account),
            ),
          );
        } else {
          setState(() {
            selectedIndex = index;
          });
        }
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 42,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFF8A00).withValues(alpha: 0.10)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: isSelected ? const Color(0xFFFF8A00) : Colors.white38,
                size: 23,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFFF8A00) : Colors.white38,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOloniButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = 1;
        });
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFFFF8A00), Color(0xFFFF4FA3), Color(0xFF8A2BE2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF8A00).withValues(alpha: 0.18),
              blurRadius: 18,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: const Color(0xFFFF4FA3).withValues(alpha: 0.20),
              blurRadius: 28,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF080318),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/oloni_orbital_ring.png',
              width: 45,
              height: 45,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050117),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshDashboard,
          color: const Color(0xFFFF8A00),
          backgroundColor: const Color(0xFF0F0A20),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getGreeting(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 4),
                        Text(
                          '${widget.account['name']} 👋',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFFF8A00).withValues(alpha: 0.16),
                            const Color(0xFF8A2BE2).withValues(alpha: 0.16),
                          ],
                        ),
                        border: Border.all(
                          color: const Color(0xFFFF8A00)
                              .withValues(alpha: 0.30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF8A00)
                                .withValues(alpha: 0.08),
                            blurRadius: 16,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 23,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                const Text(
                  'Your money. Your control.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4,
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  height: 235,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFFF8A00).withValues(alpha: 0.35),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF8A00).withValues(alpha: 0.08),
                        blurRadius: 25,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/balance_city.png',
                            fit: BoxFit.cover,
                          ),
                        ),

                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xF5050117),
                                  Color(0xC8050117),
                                  Color(0x55050117),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    'assets/images/oloni_logo1.png',
                                    width: 95,
                                    height: 40,
                                    fit: BoxFit.contain,
                                  ),
                                  Text(
                                    '${widget.account['account_type']} Account',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),

                              const Spacer(),

                              const Text(
                                'Available Balance',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    isBalanceVisible
                                        ? formatNaira(widget.account['balance'])
                                        : '••••••••',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isBalanceVisible = !isBalanceVisible;
                                      });
                                    },
                                    icon: Icon(
                                      isBalanceVisible
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: Colors.white54,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              Text(
                                'Account No: ${widget.account['account_number']}',
                                style: const TextStyle(
                                  color: Color.fromARGB(251, 255, 255, 255),
                                  fontSize: 14,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickAction(
                      icon: Icons.add_rounded,
                      title: 'Deposit',
                      subtitle: 'Add money',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DepositScreen(account: widget.account),
                          ),
                        );
                      },
                    ),

                    _buildQuickAction(
                      icon: Icons.swap_horiz_rounded,
                      title: 'Transfer',
                      subtitle: 'To other banks',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TransferScreen(account: widget.account),
                          ),
                        );
                      },
                    ),

                    _buildQuickAction(
                      icon: Icons.arrow_downward_rounded,
                      title: 'Withdraw',
                      subtitle: 'Take out money',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WithdrawScreen(account: widget.account),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Transactions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const TransactionHistoryScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'View More',
                        style: TextStyle(
                          color: Color(0xFFFF8A00),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                if (isLoadingTransactions)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF8A00),
                      ),
                    ),
                  )
                else if (transactionError != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F0A20),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFF8A00).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.cloud_off_rounded,
                          color: Color(0xFFFF8A00),
                          size: 40,
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Unable to load transactions',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          transactionError!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextButton(
                          onPressed: loadTransactions,
                          child: const Text(
                            'Try Again',
                            style: TextStyle(
                              color: Color(0xFFFF8A00),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else if (transactions.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F0A20),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF8A2BE2).withValues(alpha: 0.20),
                      ),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          color: Colors.white38,
                          size: 40,
                        ),

                        SizedBox(height: 10),

                        Text(
                          'No transactions yet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          'Your recent transactions will appear here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white38, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    children: transactions
                        .take(3)
                        .map(
                          (transaction) => _buildTransactionItem(transaction),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
        decoration: BoxDecoration(
          color: const Color(0xFF0B0717),
          border: Border(
            top: BorderSide(
              color: const Color(0xFF8A2BE2).withValues(alpha: 0.12),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.30),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBottomNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                index: 0,
              ),

              _buildOloniButton(),

              _buildBottomNavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
