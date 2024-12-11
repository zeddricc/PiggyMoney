import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piggymoney/core/theme/app_theme.dart';
import 'package:piggymoney/features/services/wallet_service_provider.dart';
import 'package:piggymoney/helpers/number_helper.dart';
import 'package:piggymoney/helpers/wallet_icon_helper.dart';
import 'package:piggymoney/models/category.dart';
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
    final walletService = ref.watch(walletServiceProvider);
    final wallets = walletService.getAllWallets();

    void handleSave() {
      if (selectedWallet == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn ví')),
        );
        return;
      }

      if (selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn danh mục')),
        );
        return;
      }

      if (_amountController.text == '0' || _amountController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng nhập số tiền')),
        );
        return;
      }

      final amount = double.parse(_amountController.text.replaceAll(',', ''));

      transactionService.addTransactionItem(
        amount: amount,
        type: transactionState.selectedType,
        category: selectedCategory!,
        wallet: selectedWallet!,
        note: _noteController.text,
        date: transactionState.selectedDate,
        repeatPattern: _repeatPattern,
      );

      walletService.processTransactionAmount(
        selectedWallet!,
        amount,
        transactionState.selectedType,
      );

      Navigator.pop(context, true);
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          child: CustomHeader(
            title: 'Thêm giao dịch',
            onBackPressed: () => Navigator.pop(context),
            trailing: IconButton(
              icon: const Icon(Icons.check, color: AppTheme.primaryColor),
              onPressed: handleSave,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Số tiền
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 16),
                        margin: const EdgeInsets.only(bottom: 24),
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
                          children: [
                            TextField(
                              controller: _amountController,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: transactionState.selectedType == 'EXPENSES'
                                    ? Colors.red
                                    : Colors.green,
                              ),
                              decoration: const InputDecoration(
                                hintText: '0',
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                TextInputFormatter.withFunction(
                                    (oldValue, newValue) {
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
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'VND',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Loại giao dịch
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => ref
                                          .read(transactionProvider.notifier)
                                          .updateType('EXPENSES'),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        decoration: BoxDecoration(
                                          color: transactionState.selectedType ==
                                                  'EXPENSES'
                                              ? AppTheme.primaryColor
                                                  .withOpacity(0.1)
                                              : null,
                                          borderRadius:
                                              const BorderRadius.horizontal(
                                            left: Radius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          'Expenses',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                transactionState.selectedType ==
                                                        'EXPENSES'
                                                    ? AppTheme.primaryColor
                                                    : Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => ref
                                          .read(transactionProvider.notifier)
                                          .updateType('INCOME'),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        decoration: BoxDecoration(
                                          color: transactionState.selectedType ==
                                                  'INCOME'
                                              ? AppTheme.primaryColor
                                                  .withOpacity(0.1)
                                              : null,
                                        ),
                                        child: Text(
                                          'Income',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                transactionState.selectedType ==
                                                        'INCOME'
                                                    ? AppTheme.primaryColor
                                                    : Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Chọn ví
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
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
                                  child: const Icon(
                                    Icons.account_balance_wallet,
                                    color: AppTheme.primaryColor,
                                    size: 20,
                                  ),
                                ),
                                title: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedWallet,
                                    hint: const Text('Select Wallet'),
                                    isExpanded: true,
                                    items: wallets.map((wallet) {
                                      return DropdownMenuItem<String>(
                                        value: wallet.id,
                                        child: Text(
                                          wallet.name,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedWallet = newValue;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Chọn danh mục
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    selectedCategoryIcon ?? Icons.category,
                                    color: AppTheme.primaryColor,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  selectedCategory ?? 'Select Category',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CategoryScreen(
                                        transactionType:
                                            transactionState.selectedType,
                                      ),
                                    ),
                                  );

                                  if (result != null) {
                                    setState(() {
                                      selectedCategory = result['category'];
                                      selectedSubcategory = result['subcategory'];
                                      selectedCategoryIcon = getSubcategoryIcon(
                                        selectedCategory,
                                        selectedSubcategory,
                                      );
                                    });
                                    ref
                                        .read(transactionProvider.notifier)
                                        .updateCategory(selectedCategory!);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Ghi chú

                      // Ngày
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.calendar_today,
                                    color: AppTheme.primaryColor,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(transactionState.selectedDate),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: transactionState.selectedDate,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                  );
                                  if (picked != null) {
                                    ref
                                        .read(transactionProvider.notifier)
                                        .updateDate(picked);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _noteController,
                                decoration: InputDecoration(
                                  hintText: 'Add Note',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
