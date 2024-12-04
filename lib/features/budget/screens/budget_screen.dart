import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piggymoney/core/theme/app_theme.dart';
import 'package:piggymoney/features/services/wallet_service_provider.dart'; // Import the provider
import 'create_wallet_screen.dart'; // Import the Create Wallet Screen

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  // Method to get the icon based on wallet type
  IconData _getWalletIcon(String walletType) {
    switch (walletType) {
      case 'Investment':
        return Icons.trending_up; // Example icon for Investment
      case 'Bank':
        return Icons.account_balance; // Example icon for Bank
      case 'Credit Card':
        return Icons.credit_card; // Example icon for Credit Card
      case 'E-Wallet':
        return Icons.mobile_friendly; // Example icon for E-Wallet
      case 'Cash':
        return Icons.money_rounded; // Example icon for Cash
      case 'Others':
      default:
        return Icons.wallet_giftcard; // Default icon for Others
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletService = ref.watch(walletServiceProvider); // Use the provider
    final wallets = walletService.getAllWallets();

    print(
        'Number of wallets in BudgetScreen: ${wallets.length}'); // Debug statement

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallets'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: wallets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No wallets available.',
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
                    child: const Text('Create Wallet'),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
              itemCount: wallets.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final wallet = wallets[index];
                return Card(
                  child: ListTile(
                    leading: Icon(_getWalletIcon(wallet.walletType),
                        color: AppTheme.primaryColor), // Add the wallet icon

                    subtitle: Text(
                        '${wallet.walletType} \n${wallet.initBalance} ${wallet.currency}'),
                    onTap: () {
                      // Navigate to Create Wallet Screen for updating
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CreateWalletScreen(wallet: wallet),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Delete wallet
                        walletService.deleteWallet(wallet.id);
                        // Refresh the UI
                        ref.refresh(
                            walletServiceProvider); // Refresh the provider
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
