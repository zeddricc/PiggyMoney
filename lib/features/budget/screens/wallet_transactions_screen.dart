import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:piggymoney/core/theme/app_theme.dart';
import 'package:piggymoney/features/home/providers/transaction_service_provider.dart';
import 'package:piggymoney/features/home/screens/transaction_detail_screen.dart';
import 'package:piggymoney/features/services/wallet_service_provider.dart';
import 'package:piggymoney/helpers/number_helper.dart';
import 'package:piggymoney/models/category.dart';
import 'package:piggymoney/models/wallet.dart';
import 'package:piggymoney/data/category_data.dart';
import 'package:piggymoney/widgets/custom_header.dart';


class WalletTransactionsScreen extends ConsumerWidget {
  final WalletItem wallet;

  const WalletTransactionsScreen({
    super.key,
    required this.wallet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionService = ref.watch(transactionServiceProvider);
    final walletService = ref.watch(walletServiceProvider);
    final allTransactions = transactionService.getAllTransactions();
    
    // Lọc giao dịch của ví hiện tại
    final walletTransactions = allTransactions
        .where((transaction) => transaction.wallet == wallet.id)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    // Tính số dư thực tế
    final actualBalance = walletService.getActualBalance(wallet.id);

    // Tính tổng thu và chi
    final totalIncome = walletTransactions
        .where((t) => t.amount > 0)
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalExpense = walletTransactions
        .where((t) => t.amount < 0)
        .fold(0.0, (sum, t) => sum + t.amount.abs());

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: wallet.name,
              onBackPressed: () => Navigator.pop(context),
            ),
            // Hiển thị số dư và thống kê
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
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
              child: Column(
                children: [
                  Text(
                    'Số dư hiện tại',
                    style: AppTheme.bodyStyle.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${formatNumber(actualBalance)} ${wallet.currency}',
                    style: AppTheme.headingStyle.copyWith(
                      fontSize: 24,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Thu nhập',
                            style: AppTheme.bodyStyle.copyWith(color: Colors.grey),
                          ),
                          Text(
                            '${formatNumber(totalIncome)} ${wallet.currency}',
                            style: AppTheme.bodyStyle.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Chi tiêu',
                            style: AppTheme.bodyStyle.copyWith(color: Colors.grey),
                          ),
                          Text(
                            '${formatNumber(totalExpense)} ${wallet.currency}',
                            style: AppTheme.bodyStyle.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Danh sách giao dịch
            Expanded(
              child: walletTransactions.isEmpty
                  ? Center(
                      child: Text(
                          'No transactions yet',
                        style: AppTheme.bodyStyle.copyWith(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: walletTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = walletTransactions[index];
                        final category = sampleCategories.firstWhere(
                          (cat) => cat.name == transaction.category,
                          orElse: () => Category(
                            name: 'Khác',
                            icon: Icons.category,
                            color: Colors.grey,
                            subcategories: [],
                            type: 'EXPENSES',
                          ),
                        );

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransactionDetailScreen(
                                    transaction: transaction,
                                  ),
                                ),
                              );
                              if (result == true) {
                                ref.refresh(transactionServiceProvider);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: category.color.withOpacity(0.1),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          category.name,
                                          style: AppTheme.titleStyle.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (transaction.note != null &&
                                            transaction.note!.trim().isNotEmpty)
                                          Text(
                                            transaction.note!,
                                            style: AppTheme.smallTextStyle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        Text(
                                          DateFormat('dd-MM-yyyy')
                                              .format(transaction.date),
                                          style: AppTheme.smallTextStyle.copyWith(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${formatNumber(transaction.amount)} ${wallet.currency}',
                                    style: AppTheme.titleStyle.copyWith(
                                      color: transaction.amount < 0
                                          ? Colors.red
                                          : Colors.green,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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