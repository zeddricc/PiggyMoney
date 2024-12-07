import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piggymoney/core/theme/app_theme.dart';
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

  @override
  void initState() {
    super.initState();
    final transactionService = ref.read(transactionServiceProvider);
    final transaction = transactionService.getAllTransactions().firstWhere(
          (transaction) => transaction.id == widget.transactionId,
          orElse: () => throw Exception('Transaction not found'),
        );

    _amountController =
        TextEditingController(text: transaction.amount.toString());
    _noteController = TextEditingController(text: transaction.note ?? '');
    _repeatPattern = transaction.repeatPattern;
    selectedCategory = transaction.category; // Giả sử bạn có cách lấy danh mục
    selectedSubcategory =
        ''; // Nếu có subcategory, bạn có thể lấy từ transaction
  }

  @override
  void dispose() {
    _amountController.dispose(); // Dispose the controller
    _noteController.dispose(); // Dispose the note controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionService = ref.watch(transactionServiceProvider);
    final transactionState = ref.watch(transactionProvider);

    // Sample data for dropdowns
    List<String> transactionTypes = ['EXPENSES', 'INCOME', 'TRANSFER'];
    List<String> wallets = ['Spending', 'Savings', 'Investment'];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Back Button
            CustomHeader(
              title: 'Transaction Details',
              onBackPressed: () {
                Navigator.pop(context); // Navigate back
              },
            ),
            // Amount
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
                          final String formatted =
                              newValue.text.replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]},',
                          );
                          return TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(
                                offset: formatted.length),
                          );
                        }),
                      ],
                      textAlign: TextAlign.end,
                      style: AppTheme.headingStyle.copyWith(fontSize: 30),
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
            // Display Amount with Color Change
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Current Amount:',
                    style: AppTheme.bodyStyle,
                  ),
                  // Display the amount with handling for long numbers
                  Expanded(
                    child: Text(
                      '${double.parse(_amountController.text.replaceAll(',', '')).abs()} đ', 
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 24,
                        color: double.parse(_amountController.text.replaceAll(',', '')) < 0
                            ? Colors.red 
                            : Colors.black, 
                      ),
                      overflow: TextOverflow.ellipsis, 
                      maxLines: 1, 
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Transaction Type
            ToggleButtons(
              borderColor: Colors.transparent,
              isSelected: [
                transactionState.selectedType == 'EXPENSES',
                transactionState.selectedType == 'INCOME',
                transactionState.selectedType == 'TRANSFER'
              ],
              onPressed: (int index) {
                // Handle toggle logic
                ref
                    .read(transactionProvider.notifier)
                    .updateType(transactionTypes[index]);
              },
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('EXPENSES',
                      style: AppTheme.bodyStyle.copyWith(fontSize: 14)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('INCOME',
                      style: AppTheme.bodyStyle.copyWith(fontSize: 14)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('TRANSFER',
                      style: AppTheme.bodyStyle.copyWith(fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Category and Subcategory Selection
            ListTile(
              title: Text(
                  selectedCategory != null && selectedSubcategory != null
                      ? '$selectedCategory $selectedSubcategory'
                      : 'Select Category'),
              leading: Icon(Icons.category),
              onTap: () async {
                // Navigate to CategoryScreen and wait for the result
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryScreen(
                        transactionType: transactionState.selectedType),
                  ),
                );

                // If a category and subcategory were selected, update the state
                if (result != null) {
                  setState(() {
                    selectedCategory = result['category'];
                    selectedSubcategory = result['subcategory'];

                    ref.read(transactionProvider.notifier).updateCategory(
                        selectedCategory!); // Update state with icon
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            // Wallet Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButton<String>(
                value: transactionState.selectedWallet,
                isExpanded: true,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    ref
                        .read(transactionProvider.notifier)
                        .updateWallet(newValue);
                  }
                },
                items: wallets.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(Icons.wallet, size: 24.0),
                        SizedBox(
                          width: 8,
                        ),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            // Note Text Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextField(
                controller: _noteController, // Use the note controller
                decoration: InputDecoration(
                  hintText: 'Enter note',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.note, size: 24.0),
                  fillColor: Colors.white,
                ),
                // Allow multiple lines for notes
              ),
            ),
            const SizedBox(height: 20),
            // Date Picker
            ListTile(
              leading: const Icon(Icons.calendar_today,
                  color: AppTheme.secondaryColor),
              title: Text(
                  ' ${DateFormat('dd-MM-yyyy').format(transactionState.selectedDate)}',
                  style: AppTheme.bodyStyle.copyWith(color: Colors.black)),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: transactionState.selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null &&
                    pickedDate != transactionState.selectedDate) {
                  ref.read(transactionProvider.notifier).updateDate(pickedDate);
                  print(
                      'Selected Date: ${DateFormat('yyyy-MM-dd').format(transactionState.selectedDate)}'); // Debugging statement
                }
              },
            ),
            // Repeat
            ListTile(
              leading: const Icon(Icons.repeat, color: AppTheme.secondaryColor),
              title: Text('Repeat: $_repeatPattern', style: AppTheme.bodyStyle),
              onTap: () {
                // Handle repeat selection
              },
            ),
            const Spacer(),
            // Save Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: TextButton(
                style: AppTheme.primaryButtonStyle,
                // Trong phần onPressed của nút Save
                onPressed: () {
                  // Log before updating the transaction
                  print(
                      'Attempting to update transaction: Amount: ${_amountController.text}, Type: ${transactionState.selectedType}, Category: ${transactionState.selectedCategory}, Wallet: ${transactionState.selectedWallet}, Note: ${_noteController.text}, Date: ${transactionState.selectedDate}, Repeat Pattern: $_repeatPattern');

                  // Call the updateTransactionItem function
                  transactionService.updateTransactionItem(
                    widget.transactionId, // ID của giao dịch
                    id: widget
                        .transactionId, // ID của giao dịch trong cơ sở dữ liệu
                    amount: double.parse(
                        _amountController.text.replaceAll(',', '')),
                    type: transactionState.selectedType,
                    category: selectedCategory!,
                    wallet: transactionState.selectedWallet,
                    note: _noteController.text,
                    date: transactionState.selectedDate,
                    repeatPattern: _repeatPattern,
                  );

                  Navigator.pop(context,
                      true); // Pass true to indicate a transaction was updated
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
    );
  }
}
