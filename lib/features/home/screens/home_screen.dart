import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piggymoney/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piggymoney/features/home/providers/balance_visibility_provider.dart';
import 'package:piggymoney/features/home/providers/transaction_service_provider.dart';
import 'package:piggymoney/features/home/widget/quick_action_button.dart';
import 'package:piggymoney/models/category.dart';
import 'package:piggymoney/data/category_data.dart';
import 'add_transaction_screen.dart'; // Import the AddTransactionScreen
import 'all_transactions_screen.dart'; // Import the AllTransactionsScreen
import 'package:piggymoney/helpers/number_helper.dart'; // Import the number_helper.dart
import 'transaction_detail_screen.dart'; // Import the TransactionDetailScreen

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBalanceVisible = ref.watch(balanceVisibilityProvider);
    final transactionService = ref.watch(transactionServiceProvider);
    final transactions = transactionService.getAllTransactions();
    final totalBalance =
        transactionService.calculateTotalBalance(); // Calculate total balance

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Text(
                        'Hello User!',
                        style: AppTheme.smallTextStyle
                            .copyWith(color: Colors.white, fontSize: 16),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          isBalanceVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          ref
                              .read(balanceVisibilityProvider.notifier)
                              .toggleVisibility();
                        },
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isBalanceVisible
                              ? '${formatNumber(totalBalance)} đ'
                              : '*********',
                          style: AppTheme.headingStyle.copyWith(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    child: Padding(
                      padding: const EdgeInsets.all(9),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          QuickActionButton(
                            icon: Icons.add,
                            label: 'Income',
                            color: Colors.green,
                            onTap: () async {
                              // Navigate to Add Transaction Screen with Income type
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddTransactionScreen(
                                          initialType:
                                              'INCOME'), // Pass 'INCOME'
                                ),
                              );
                              // Use the result to refresh transactions
                              if (result == true) {
                                ref.refresh(transactionServiceProvider);
                              }
                            },
                          ),
                          QuickActionButton(
                            icon: Icons.remove,
                            label: 'Expense',
                            color: Colors.red,
                            onTap: () async {
                              // Navigate to Add Transaction Screen with Income type
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddTransactionScreen(
                                          initialType:
                                              'INCOME'), // Pass 'INCOME'
                                ),
                              );

                              // Use the result to refresh transactions
                              if (result == true) {
                                // Refresh the transaction list and ignore the result
                              }
                            },
                          ),
                          QuickActionButton(
                            icon: Icons.swap_horiz,
                            label: 'Transfer',
                            color: AppTheme.primaryColor,
                            onTap: () async {
                              // Navigate to Add Transaction Screen
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddTransactionScreen(),
                                ),
                              );
                              // Use the result to refresh transactions
                              if (result == true) {
                                ref.refresh(transactionServiceProvider);
                              }
                            },
                          ),
                          QuickActionButton(
                            icon: Icons.savings,
                            label: 'Savings',
                            color: Colors.blue,
                            onTap: () {
                              // Add your onTap functionality here
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Transactions',
                          style: AppTheme.headingStyle.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AllTransactionsScreen(),
                              ),
                            );
                            if (result == true) {
                              ref.refresh(transactionServiceProvider);
                            }
                          },
                          child: Text(
                            'See all',
                            style: AppTheme.smallTextStyle.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: transactions.isEmpty
                        ? Center(
                            child: Text(
                              'No transactions available. Please add some transactions.',
                              style: AppTheme.bodyStyle
                                  .copyWith(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: transactions.length > 3
                                ? 3
                                : transactions.length, // Limit to max 3 items
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              // Sắp xếp danh sách giao dịch theo ngày giảm dần
                              final sortedTransactions = transactions
                                ..sort((a, b) => b.date.compareTo(a.date));

                              final transaction = sortedTransactions[index];
                              final category = sampleCategories.firstWhere(
                                (cat) => cat.name == transaction.category,
                                orElse: () => Category(
                                    name: 'Miscellaneous', // Default fallback
                                    icon: Icons.category,
                                    color: Colors.grey,
                                    subcategories: [],
                                    type: 'EXPENSES'),
                              );
                              return GestureDetector(
                                onTap: () async {
                                  // Navigate to TransactionDetailScreen
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TransactionDetailScreen(
                                              transactionId: transaction.id),
                                    ),
                                  );

                                  if (result == true) {
                                    ref.refresh(transactionServiceProvider);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryColor
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          category.icon,
                                          color: category.color,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              transaction.category,
                                              style: AppTheme.titleStyle
                                                  .copyWith(fontSize: 13),
                                            ),
                                            if (transaction.note != null &&
                                                transaction.note!
                                                    .trim()
                                                    .isNotEmpty)
                                              Text(
                                                transaction.note!,
                                                style: AppTheme.smallTextStyle
                                                    .copyWith(),
                                              ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${DateFormat('dd-MM-yyyy').format(transaction.date)}',
                                              style: AppTheme.smallTextStyle
                                                  .copyWith(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${formatNumber(transaction.amount)} đ',
                                            style: AppTheme.smallTextStyle
                                                .copyWith(
                                              color: transaction.amount < 0
                                                  ? Colors.red
                                                  : Colors.green,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.remove_circle_outline),
                                            onPressed: () async {
                                              // Confirm deletion
                                              final shouldDelete =
                                                  await showDialog<bool>(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Delete Transaction'),
                                                    content: const Text(
                                                        'Are you sure you want to delete this transaction?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(
                                                                    false), // No
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(
                                                                    true), // Yes
                                                        child: const Text(
                                                            'Delete'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );

                                              // If the user confirmed deletion, call the delete method
                                              if (shouldDelete == true) {
                                                await transactionService
                                                    .deleteTransactionItem(
                                                        transaction.id);
                                                ref.refresh(
                                                    transactionServiceProvider); // Refresh the transaction list
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
