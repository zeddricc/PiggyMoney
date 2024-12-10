import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piggymoney/core/theme/app_theme.dart';
import 'package:piggymoney/features/services/wallet_service_provider.dart';
import 'package:piggymoney/models/wallet.dart';
import 'package:piggymoney/widgets/custom_header.dart';
import 'package:realm/realm.dart';
import '../providers/transaction_service_provider.dart'; // Import the provider
import '../providers/transaction_state.dart'; // Import the transaction state provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:piggymoney/features/home/screens/category_screen.dart'; // Import the CategoryScreen

class TransactionDetailScreen extends ConsumerStatefulWidget {
  final ObjectId transactionId; // ID của giao dịch

  const TransactionDetailScreen({super.key, required this.transactionId});

  @override
  _TransactionDetailScreenState createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState
    extends ConsumerState<TransactionDetailScreen> {
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  String _repeatPattern = 'NEVER';
  String? selectedCategory;
  String? selectedSubcategory;
  String? selectedWallet;
  late String transactionType;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    final transactionService = ref.read(transactionServiceProvider);
    final transaction = transactionService.getAllTransactions().firstWhere(
          (transaction) => transaction.id == widget.transactionId,
          orElse: () => throw Exception('Transaction not found'),
        );

    _amountController = TextEditingController(text: transaction.amount.abs().toString());
    _noteController = TextEditingController(text: transaction.note ?? '');
    _repeatPattern = transaction.repeatPattern;
    selectedCategory = transaction.category;
    selectedWallet = transaction.wallet;
    transactionType = transaction.type;
    selectedDate = transaction.date;

    // Cập nhật state
    Future.microtask(() {
      ref.read(transactionProvider.notifier).updateType(transactionType);
      ref.read(transactionProvider.notifier).updateCategory(selectedCategory!);
      ref.read(transactionProvider.notifier).updateDate(selectedDate);
      ref.read(transactionProvider.notifier).updateWallet(selectedWallet!);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionService = ref.watch(transactionServiceProvider);
    final transactionState = ref.watch(transactionProvider);
    final walletService = ref.watch(walletServiceProvider);
    final wallets = walletService.getAllWallets();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: 'Chi tiết giao dịch',
              onBackPressed: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          if (newValue.text.isEmpty) return newValue;
                          final String formatted = newValue.text.replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]},',
                          );
                          return TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(offset: formatted.length),
                          );
                        }),
                      ],
                      textAlign: TextAlign.end,
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 30,
                        color: transactionType == 'EXPENSES' ? Colors.red : Colors.green,
                      ),
                      decoration: const InputDecoration(
                        hintText: '0',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      '₫',
                      style: AppTheme.headingStyle.copyWith(fontSize: 30),
                    ),
                  ),
                ],
              ),
            ),
            // Transaction Type
            ToggleButtons(
              borderColor: Colors.transparent,
              isSelected: [
                transactionType == 'EXPENSES',
                transactionType == 'INCOME',
                transactionType == 'TRANSFER'
              ],
              onPressed: (int index) {
                setState(() {
                  transactionType = ['EXPENSES', 'INCOME', 'TRANSFER'][index];
                });
                ref.read(transactionProvider.notifier).updateType(transactionType);
              },
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('EXPENSES',
                      style: AppTheme.bodyStyle.copyWith(fontSize: 14)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('INCOME',
                      style: AppTheme.bodyStyle.copyWith(fontSize: 14)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('TRANSFER',
                      style: AppTheme.bodyStyle.copyWith(fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Category Selection
            ListTile(
              title: Text(
                selectedCategory ?? 'Select Category',
                style: AppTheme.bodyStyle,
              ),
              leading: const Icon(Icons.category),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryScreen(
                      transactionType: transactionType,
                    ),
                  ),
                );

                if (result != null) {
                  setState(() {
                    selectedCategory = result['category'];
                    selectedSubcategory = result['subcategory'];
                  });
                  ref.read(transactionProvider.notifier).updateCategory(selectedCategory!);
                }
              },
            ),
            const SizedBox(height: 20),
            // Wallet Selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButton<String>(
                value: selectedWallet,
                isExpanded: true,
                hint: const Text('Select Wallet'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedWallet = newValue;
                  });
                  if (newValue != null) {
                    ref.read(transactionProvider.notifier).updateWallet(newValue);
                  }
                },
                items: wallets.map<DropdownMenuItem<String>>((WalletItem wallet) {
                  return DropdownMenuItem<String>(
                    value: wallet.id,
                    child: Text(wallet.name),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            // Note Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  hintText: 'Enter note',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Date Selection
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                DateFormat('dd-MM-yyyy').format(selectedDate),
                style: AppTheme.bodyStyle,
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                  ref.read(transactionProvider.notifier).updateDate(picked);
                }
              },
            ),
            const Spacer(),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Transaction'),
                            content: const Text('Are you sure you want to delete this transaction?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (shouldDelete == true) {
                          await transactionService.deleteTransactionItem(widget.transactionId);
                          if (mounted) {
                            Navigator.pop(context, true);
                          }
                        }
                      },
                      child: Text(
                        'Delete',
                        style: AppTheme.buttonTextStyle.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextButton(
                      style: AppTheme.primaryButtonStyle,
                      onPressed: () async {
                        final amount = double.parse(_amountController.text.replaceAll(',', ''));
                        await transactionService.updateTransactionItem(
                          widget.transactionId,
                          id: widget.transactionId,
                          amount: transactionType == 'EXPENSES' ? -amount.abs() : amount.abs(),
                          type: transactionType,
                          category: selectedCategory!,
                          wallet: selectedWallet!,
                          note: _noteController.text,
                          date: selectedDate,
                          repeatPattern: _repeatPattern,
                        );
                        if (mounted) {
                          Navigator.pop(context, true);
                        }
                      },
                      child: const Text(
                        'Save',
                        style: AppTheme.buttonTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
