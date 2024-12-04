import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:piggymoney/core/theme/app_theme.dart';
import 'package:piggymoney/features/home/providers/transaction_service_provider.dart';
import 'package:piggymoney/helpers/number_helper.dart';
import 'package:piggymoney/models/category.dart';
import 'package:piggymoney/data/category_data.dart';
import 'package:piggymoney/widgets/custom_header.dart';

class AllTransactionsScreen extends ConsumerWidget {
  const AllTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionService = ref.watch(transactionServiceProvider);
    final transactions = transactionService.getAllTransactions();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: 'Add Transaction',
              onBackPressed: () {
                Navigator.pop(context); // Navigate back
              },
            ),
            Expanded(
              child: transactions.isEmpty
                  ? Center(
                      child: Text(
                        'No transactions available.',
                        style: AppTheme.bodyStyle.copyWith(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: transactions.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        // Find the category
                        final category = sampleCategories.firstWhere(
                          (cat) => cat.name == transaction.category,
                          orElse: () => Category(
                            name: 'Miscellaneous', // Default fallback
                            icon: Icons.category,
                            color: Colors.grey,
                            subcategories: [],
                          ),
                        );

                        return Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.primaryColor.withOpacity(0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  category.icon,
                                  color: category.color,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      transaction.category,
                                      style: AppTheme.titleStyle.copyWith(
                                          fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    if (transaction.note != null &&
                                        transaction.note!.trim().isNotEmpty)
                                      Text(
                                        transaction.note!,
                                        style: AppTheme.smallTextStyle.copyWith(),
                                      ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${DateFormat('dd-MM-yyyy').format(transaction.date)}',
                                      style: AppTheme.smallTextStyle.copyWith(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${formatNumber(transaction.amount)} đ',
                                style: AppTheme.smallTextStyle.copyWith(
                                  color: transaction.amount < 0
                                      ? Colors.red
                                      : Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
