import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piggymoney/core/theme/app_theme.dart';
import 'package:piggymoney/features/services/wallet_service_provider.dart'; // Import the provider
import 'package:piggymoney/helpers/number_helper.dart';
import 'package:piggymoney/models/wallet.dart';
import 'package:piggymoney/widgets/custom_header.dart';
import 'create_wallet_screen.dart'; // Import the Create Wallet Screen

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

  // Tính tổng số tiền của tất cả ví
  double _calculateTotalBalance(List<WalletItem> wallets) {
    return wallets.fold(0, (sum, wallet) => sum + wallet.initBalance);
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

  // Tính tổng số tiền theo loại ví
  double _calculateTotalByType(List<WalletItem> wallets) {
    return wallets.fold(0, (sum, wallet) => sum + wallet.initBalance);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletService = ref.watch(walletServiceProvider);
    final wallets = walletService.getAllWallets();
    final totalBalance = _calculateTotalBalance(wallets);
    final groupedWallets = _groupWalletsByType(wallets);

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
                    // Hiển thị tổng số tiền
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Tổng số tiền',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
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
                          final totalForType = _calculateTotalByType(walletsOfType);
                          
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ExpansionTile(
                              leading: Icon(
                                _getWalletIcon(type),
                                color: AppTheme.primaryColor,
                              ),
                              title: Text(
                                type,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                '${formatNumber(totalForType)} VND',
                                style: TextStyle(
                                  color: AppTheme.primaryColor.withOpacity(0.8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              children: walletsOfType.map((wallet) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      _getWalletIcon(wallet.walletType),
                                      color: AppTheme.primaryColor.withOpacity(0.7),
                                    ),
                                    title: Text(
                                      wallet.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${formatNumber(wallet.initBalance)} ${wallet.currency}',
                                      style: const TextStyle(
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CreateWalletScreen(wallet: wallet),
                                        ),
                                      );
                                    },
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
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
                                                onPressed: () =>
                                                    Navigator.of(context).pop(false),
                                                child: const Text('Hủy'),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(true),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateWalletScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}
