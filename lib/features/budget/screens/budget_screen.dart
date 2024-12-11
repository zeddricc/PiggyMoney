import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piggymoney/core/theme/app_theme.dart';
import 'package:piggymoney/features/services/wallet_service.dart';
import 'package:piggymoney/features/services/wallet_service_provider.dart'; // Import the provider
import 'package:piggymoney/helpers/number_helper.dart';
import 'package:piggymoney/models/wallet.dart';
import 'package:piggymoney/widgets/custom_header.dart';
import 'create_wallet_screen.dart'; // Import the Create Wallet Screen
import 'wallet_transactions_screen.dart'; // Import the Wallet Transactions Screen

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  // Method to get the icon based on wallet type
  IconData _getWalletIcon(String walletType) {
    switch (walletType) {
      case 'Investment':
        return Icons.trending_up;
      case 'Bank':
        return Icons.account_balance;
      case 'Credit Card':
        return Icons.credit_card;
      case 'E-Wallet':
        return Icons.mobile_friendly;
      case 'Cash':
        return Icons.money_rounded;
      case 'Others':
      default:
        return Icons.wallet_giftcard;
    }
  }

  // Tính tổng số dư thực tế của tất cả ví
  double _calculateTotalBalance(List<WalletItem> wallets, WalletService walletService) {
    return wallets.fold(0.0, (sum, wallet) => sum + walletService.getActualBalance(wallet.id));
  }

  // Tính tổng số dư thực tế của một nhóm ví
  double _calculateGroupBalance(List<WalletItem> wallets, WalletService walletService) {
    return wallets.fold(0.0, (sum, wallet) => sum + walletService.getActualBalance(wallet.id));
  }

  // Nhóm ví theo loại
  Map<String, List<WalletItem>> _groupWalletsByType(List<WalletItem> wallets) {
    final groupedWallets = <String, List<WalletItem>>{};
    for (var wallet in wallets) {
      if (!groupedWallets.containsKey(wallet.walletType)) {
        groupedWallets[wallet.walletType] = [];
      }
      groupedWallets[wallet.walletType]!.add(wallet);
    }
    return groupedWallets;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletService = ref.watch(walletServiceProvider);
    final wallets = walletService.getAllWallets();
    final groupedWallets = _groupWalletsByType(wallets);
    final totalBalance = _calculateTotalBalance(wallets, walletService);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: 'Ví của tôi',
              onBackPressed: () {},
              isBackButtonVisible: false,
            ),
            if (wallets.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Chưa có ví nào.',
                        style: AppTheme.bodyStyle.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateWalletScreen(),
                            ),
                          );
                        },
                        child: const Text('Tạo ví mới'),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: Column(
                  children: [
                    // Hiển thị tổng số dư của tất cả ví
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Tổng số dư',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${formatNumber(totalBalance)} VND',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Danh sách ví theo nhóm
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: groupedWallets.length,
                        itemBuilder: (context, index) {
                          final type = groupedWallets.keys.elementAt(index);
                          final walletsOfType = groupedWallets[type]!;
                          final groupBalance = _calculateGroupBalance(walletsOfType, walletService);
                          
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              childrenPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  _getWalletIcon(type),
                                  color: AppTheme.primaryColor,
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                type,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    '${formatNumber(groupBalance)} VND',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: AppTheme.primaryColor.withOpacity(0.8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${walletsOfType.length} ví',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              children: walletsOfType.map((wallet) {
                                final actualBalance = walletService.getActualBalance(wallet.id);
                                return Container(
                                  margin: const EdgeInsets.only(
                                    bottom: 8,
                                    left: 8,
                                    right: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    leading: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        _getWalletIcon(wallet.walletType),
                                        color: AppTheme.primaryColor.withOpacity(0.7),
                                        size: 24,
                                      ),
                                    ),
                                    title: Text(
                                      wallet.name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(
                                          '${formatNumber(actualBalance)} ${wallet.currency}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        if (wallet.note != null && wallet.note!.isNotEmpty)
                                          Text(
                                            wallet.note!,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: AppTheme.primaryColor,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => CreateWalletScreen(wallet: wallet),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                          onPressed: () async {
                                            final shouldDelete = await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Xóa ví'),
                                                content: const Text(
                                                  'Bạn có chắc chắn muốn xóa ví này?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(false),
                                                    child: const Text('Hủy'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(true),
                                                    child: const Text('Xóa'),
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (shouldDelete == true) {
                                              walletService.deleteWallet(wallet.id);
                                              ref.refresh(walletServiceProvider);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    onTap: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WalletTransactionsScreen(wallet: wallet),
                                        ),
                                      );
                                      if (result == true) {
                                        ref.refresh(walletServiceProvider);
                                      }
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateWalletScreen(),
            ),
          );
          if (result == true) {
            ref.refresh(walletServiceProvider);
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}
