import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piggymoney/core/theme/app_theme.dart';
import 'package:piggymoney/features/services/wallet_service_provider.dart'; // Import the provider
import 'package:piggymoney/models/wallet.dart';
import 'package:piggymoney/widgets/custom_header.dart';

class CreateWalletScreen extends ConsumerStatefulWidget {
  final WalletItem? wallet;

  const CreateWalletScreen({Key? key, this.wallet}) : super(key: key);

  @override
  ConsumerState<CreateWalletScreen> createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends ConsumerState<CreateWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _balanceController;
  late TextEditingController _noteController;
  late String _selectedType;
  late String _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.wallet?.name ?? '');
    _balanceController = TextEditingController(
        text: widget.wallet?.initBalance.toString() ?? '0');
    _noteController = TextEditingController(text: widget.wallet?.note ?? '');
    _selectedType = widget.wallet?.walletType ?? 'CASH';
    _selectedCurrency = widget.wallet?.currency ?? 'VND';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletService = ref.watch(walletServiceProvider); // Use the provider

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

    void _handleSave() {
      if (_formKey.currentState!.validate()) {
        final walletService = ref.read(walletServiceProvider);
        final amount = double.parse(_balanceController.text.replaceAll(',', ''));

        if (widget.wallet != null) {
          // Cập nhật ví hiện có
          final updatedWallet = WalletItem(
            widget.wallet!.id, // Giữ nguyên ID cũ
            _nameController.text,
            amount,
            _selectedType,
            'VND',
            note: _noteController.text,
          );
          
          try {
            walletService.updateWallet(updatedWallet);
            Navigator.pop(context, true); // Trả về true để refresh danh sách
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi cập nhật ví: $e')),
            );
          }
        } else {
          // Tạo ví mới
          final newWallet = WalletItem(
            DateTime.now().toString(), // ID mới cho ví mới
            _nameController.text,
            amount,
            _selectedType,
            'VND',
            note: _noteController.text,
          );
          
          try {
            walletService.addWallet(newWallet);
            Navigator.pop(context, true); // Trả về true để refresh danh sách
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi thêm ví: $e')),
            );
          }
        }
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomHeader(
          title: widget.wallet == null ? 'Tạo ví mới' : 'Cập nhật ví',
          onBackPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
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
              onPressed: _handleSave,
              child: Text(widget.wallet == null ? 'Create Wallet' : 'Update Wallet'),
            ),
          ],
        ),
      ),
    );
  }
}
