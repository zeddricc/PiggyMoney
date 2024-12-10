import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piggymoney/core/theme/app_theme.dart';
import 'package:piggymoney/features/services/wallet_service_provider.dart';
import 'package:piggymoney/models/category.dart';
import 'package:piggymoney/models/wallet.dart';
import 'package:piggymoney/widgets/custom_header.dart';
import '../providers/transaction_service_provider.dart';
import '../providers/transaction_state.dart';
import 'package:intl/intl.dart';
import 'package:piggymoney/features/home/screens/category_screen.dart';
import 'package:piggymoney/data/category_data.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final String? initialType;

  const AddTransactionScreen({super.key, this.initialType});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  String _repeatPattern = 'NEVER';
  String? selectedCategory;
  String? selectedSubcategory;
  IconData? selectedCategoryIcon;
  IconData? selectedSubcategoryIcon;
  String? selectedWallet; // Variable to hold the selected wallet

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: '0');
    _noteController = TextEditingController();

    Future.microtask(() {
      if (widget.initialType != null) {
        ref.read(transactionProvider.notifier).updateType(widget.initialType!);
      }
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
    final walletService =
        ref.watch(walletServiceProvider); // Access wallet service

    // Sample data for dropdowns
    List<String> transactionTypes = ['EXPENSES', 'INCOME', 'TRANSFER'];
    List<WalletItem> wallets = walletService.getAllWallets(); // Get all wallets

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: 'Add Transaction',
              onBackPressed: () {
                Navigator.pop(context);
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
            // Wallet Dropdown
            
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButton<String>(
                value: selectedWallet,
                isExpanded: true,
                hint: Text('Select Wallet'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedWallet = newValue; // Update selected wallet
                  });
                },
                items:
                    wallets.map<DropdownMenuItem<String>>((WalletItem wallet) {
                  return DropdownMenuItem<String>(
                    value: wallet.id,
                    child: Text(wallet.name),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            // Category and Subcategory Selection
            ListTile(
              title: Text(
                selectedCategory != null && selectedSubcategory != null
                    ? '$selectedSubcategory'
                    : 'Select Category',
              ),
              leading: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedSubcategoryIcon != null
                      ? getSubcategoryColor(
                              selectedCategory, selectedSubcategory)
                          .withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                ),
                padding: EdgeInsets.all(8),
                child: Icon(
                  selectedSubcategoryIcon ?? Icons.category,
                  size: 24,
                  color: getSubcategoryColor(
                      selectedCategory, selectedSubcategory),
                ),
              ), // Use the selected subcategory icon or default
              onTap: () async {
                // Navigate to CategoryScreen and wait for the result
                print(
                    'Navigating to CategoryScreen with transaction type: ${transactionState.selectedType}');

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryScreen(
                      transactionType: transactionState.selectedType,
                    ),
                  ),
                );

                // If a category and subcategory were selected, update the state
                if (result != null) {
                  setState(() {
                    selectedCategory = result['category'];
                    selectedSubcategory = result['subcategory'];

                    // Get the icon based on the selected subcategory
                    selectedSubcategoryIcon = getSubcategoryIcon(
                        selectedCategory,
                        selectedSubcategory); // Call the method to get the subcategory icon
                    ref.read(transactionProvider.notifier).updateCategory(
                        selectedCategory!); // Update state with icon
                  });
                }
              },
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
                onPressed: () {
                  // Kiểm tra các điều kiện bắt buộc
                  if (selectedWallet == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a wallet')),
                    );
                    return;
                  }

                  if (_amountController.text == '0' || _amountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter an amount')),
                    );
                    return;
                  }

                  // Chuyển đổi số tiền từ string sang double
                  final amount = double.parse(_amountController.text.replaceAll(',', ''));

                  // Log trước khi thêm giao dịch
                  print(
                      'Thêm giao dịch mới: Số tiền: $amount, Loại: ${transactionState.selectedType}, Danh mục: ${transactionState.selectedCategory}, Ví: $selectedWallet, Ghi chú: ${_noteController.text}');

                  // Cập nhật số dư trong ví
                  walletService.processTransactionAmount(
                    selectedWallet!,
                    amount,
                    transactionState.selectedType,
                  );

                  // Thêm giao dịch vào lịch sử
                  transactionService.addTransactionItem(
                    amount: amount,
                    type: transactionState.selectedType,
                    category: transactionState.selectedCategory,
                    wallet: selectedWallet ?? '',
                    note: _noteController.text,
                    date: transactionState.selectedDate,
                    repeatPattern: _repeatPattern,
                  );

                  // Hiển thị thông báo thành công
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Transaction added successfully')),
                  );

                  // Quay lại màn hình trước
                  Navigator.pop(context, true);
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

  IconData getCategoryIcon(String? category) {
    // This method should return the icon based on the category name
    final foundCategory = sampleCategories.firstWhere(
      (cat) => cat.name == category,
      orElse: () => Category(
          name: 'Miscellaneous',
          icon: Icons.category,
          color: Colors.grey,
          subcategories: [],
          type: 'EXPENSES'),
    );
    return foundCategory.icon; // Return the icon of the found category
  }

  IconData getSubcategoryIcon(String? category, String? subcategory) {
    // This method should return the icon based on the category and subcategory names
    final foundCategory = sampleCategories.firstWhere(
      (cat) => cat.name == category,
      orElse: () => Category(
          name: 'Miscellaneous',
          icon: Icons.category,
          color: Colors.grey,
          subcategories: [],
          type: 'EXPENSES'),
    );

    final foundSubcategory = foundCategory.subcategories.firstWhere(
      (sub) => sub.name == subcategory,
      orElse: () => Subcategory(
          name: 'Miscellaneous', icon: Icons.category, color: Colors.grey),
    );

    return foundSubcategory.icon; // Return the icon of the found subcategory
  }

  Color getSubcategoryColor(String? category, String? subcategory) {
    // This method should return the color based on the category and subcategory names
    final foundCategory = sampleCategories.firstWhere(
      (cat) => cat.name == category,
      orElse: () => Category(
          name: 'Miscellaneous',
          icon: Icons.category,
          color: Colors.grey,
          subcategories: [],
          type: 'EXPENSES'),
    );

    final foundSubcategory = foundCategory.subcategories.firstWhere(
      (sub) => sub.name == subcategory,
      orElse: () => Subcategory(
          name: 'Miscellaneous', icon: Icons.category, color: Colors.grey),
    );

    return foundSubcategory.color; // Return the color of the found subcategory
  }
}
