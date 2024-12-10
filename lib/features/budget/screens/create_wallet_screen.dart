import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piggymoney/core/theme/app_theme.dart';
import 'package:piggymoney/features/services/wallet_service_provider.dart'; // Import the provider
import 'package:piggymoney/models/wallet.dart';

class CreateWalletScreen extends ConsumerWidget {
  final WalletItem? wallet; // Optional wallet for updating

  const CreateWalletScreen({super.key, this.wallet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletService = ref.watch(walletServiceProvider); // Use the provider
    final TextEditingController _nameController =
        TextEditingController(text: wallet?.name ?? '');
    final TextEditingController _balanceController =
        TextEditingController(text: wallet?.initBalance.toString() ?? '');
    final TextEditingController _noteController =
        TextEditingController(text: wallet?.note ?? '');
    String _selectedType = wallet?.walletType ?? 'Cash'; // Default wallet type
    String _selectedCurrency = wallet?.currency ?? 'VND'; // Default currency

    // List of wallet types and currencies
    final List<String> walletTypes = [
      'Investment',
      'Bank',
      'Credit Card',
      'E-Wallet',
      'Cash',
      'Others'
    ];
    final List<String> currencies = ['VND', 'USD', 'EUR', 'GBP', 'JPY', 'AUD'];

    return Scaffold(
      appBar: AppBar(
        title: Text(wallet == null ? 'Create Wallet' : 'Update Wallet'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Wallet Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _balanceController,
              decoration: const InputDecoration(
                labelText: 'Initial Balance',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Wallet Type',
                border: OutlineInputBorder(),
              ),
              items: walletTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _selectedType = newValue;
                }
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              decoration: const InputDecoration(
                labelText: 'Currency',
                border: OutlineInputBorder(),
              ),
              items: currencies.map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _selectedCurrency = newValue;
                }
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Optional Note',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final walletName = _nameController.text;
                final initialBalance =
                    double.tryParse(_balanceController.text) ?? 0.0;
                if (walletName.isNotEmpty) {
                  final newWallet = WalletItem(
                      DateTime.now().toString(),
                      walletName,
                      initialBalance,
                      _selectedType, // Changed from walletType to type (or the correct name)

                      _selectedCurrency, // Ensure this matches the model
                      note: _noteController.text);
                  if (wallet == null) {
                    walletService.addWallet(newWallet); // Add new wallet
                    print(
                        'Creating new wallet: ${newWallet.name}'); // Debug statement
                  } else {
                    print('Updating wallet with ID: ${wallet?.id}'); // Log the ID being updated
                    walletService.updateWallet(newWallet); // Update existing wallet
                    print(
                        'Updating wallet: ${newWallet.name}'); // Debug statement
                  }
                  Navigator.pop(context, true); // Return to the previous screen
                } else {
                  print('Wallet name cannot be empty.');
                }
              },
              child: Text(wallet == null ? 'Create Wallet' : 'Update Wallet'),
            ),
          ],
        ),
      ),
    );
  }
}
