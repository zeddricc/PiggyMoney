import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:piggymoney/core/theme/app_theme.dart';
import 'package:piggymoney/features/home/providers/transaction_service_provider.dart';
import 'package:piggymoney/features/home/screens/category_screen.dart';
import 'package:piggymoney/features/services/transaction_service.dart';
import 'package:piggymoney/features/services/wallet_service.dart';
import 'package:piggymoney/features/services/wallet_service_provider.dart';
import 'package:piggymoney/models/transaction.dart';
import 'package:piggymoney/widgets/custom_header.dart';

class TransactionDetailScreen extends ConsumerStatefulWidget {
  final TransactionItem transaction;

  const TransactionDetailScreen({Key? key, required this.transaction}) : super(key: key);

  @override
  ConsumerState<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends ConsumerState<TransactionDetailScreen> {
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  late DateTime _selectedDate;
  late String _selectedType;
  late String? _selectedWallet;
  late String? _selectedCategory;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.transaction.amount.abs().toString());
    _noteController = TextEditingController(text: widget.transaction.note ?? '');
    _selectedDate = widget.transaction.date;
    _selectedType = widget.transaction.type;
    _selectedWallet = widget.transaction.wallet;
    _selectedCategory = widget.transaction.category;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _handleSave() {
    final transactionService = ref.read(transactionServiceProvider);
    final walletService = ref.read(walletServiceProvider);

    // Reverse the old transaction amount
    walletService.processTransactionAmount(
      widget.transaction.wallet,
      -widget.transaction.amount,
      widget.transaction.type,
    );

    // Calculate new amount
    final amount = double.parse(_amountController.text.replaceAll(',', ''));
    final adjustedAmount = _selectedType == 'EXPENSES' ? -amount.abs() : amount.abs();

    // Update transaction
    transactionService.updateTransactionItem(
      widget.transaction.id,
      id: widget.transaction.id,
      amount: adjustedAmount,
      type: _selectedType,
      category: _selectedCategory!,
      wallet: _selectedWallet!,
      note: _noteController.text,
      date: _selectedDate,
      repeatPattern: widget.transaction.repeatPattern,
    );

    // Process new amount
    walletService.processTransactionAmount(
      _selectedWallet!,
      adjustedAmount,
      _selectedType,
    );

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Giao dịch đã được cập nhật')),
    );

    // Return to previous screen with refresh flag
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final walletService = ref.watch(walletServiceProvider);
    final wallets = walletService.getAllWallets();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          child: CustomHeader(
            title: 'Chi tiết giao dịch',
            onBackPressed: () => Navigator.pop(context),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isEditing)
                  IconButton(
                    icon: const Icon(Icons.check, color: AppTheme.primaryColor),
                    onPressed: _handleSave,
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppTheme.primaryColor),
                    onPressed: _toggleEdit,
                  ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _handleDelete(context),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Số tiền
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
                      if (_isEditing)
                        TextField(
                          controller: _amountController,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: _selectedType == 'EXPENSES' ? Colors.red : Colors.green,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
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
                        )
                      else
                        Text(
                          NumberFormat('#,###').format(widget.transaction.amount.abs()),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: widget.transaction.type == 'EXPENSES' ? Colors.red : Colors.green,
                          ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          'Loại giao dịch',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
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
                        child: _isEditing
                            ? Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => setState(() => _selectedType = 'EXPENSES'),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          color: _selectedType == 'EXPENSES'
                                              ? AppTheme.primaryColor.withOpacity(0.1)
                                              : null,
                                          borderRadius: const BorderRadius.horizontal(
                                            left: Radius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          'Chi tiêu',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: _selectedType == 'EXPENSES'
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
                                      onTap: () => setState(() => _selectedType = 'INCOME'),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          color: _selectedType == 'INCOME'
                                              ? AppTheme.primaryColor.withOpacity(0.1)
                                              : null,
                                          borderRadius: const BorderRadius.horizontal(
                                            right: Radius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          'Thu nhập',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: _selectedType == 'INCOME'
                                                ? AppTheme.primaryColor
                                                : Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      widget.transaction.type == 'EXPENSES'
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward,
                                      color: AppTheme.primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    widget.transaction.type == 'EXPENSES' ? 'Chi tiêu' : 'Thu nhập',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),

                // Ví
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          'Ví',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
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
                        child: _isEditing
                            ? DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedWallet,
                                  isExpanded: true,
                                  hint: const Text('Chọn ví'),
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
                                      _selectedWallet = newValue;
                                    });
                                  },
                                ),
                              )
                            : Row(
                                children: [
                                  Container(
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
                                  const SizedBox(width: 12),
                                  Text(
                                    widget.transaction.wallet,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),

                // Danh mục
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          'Danh mục',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
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
                        child: _isEditing
                            ? InkWell(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CategoryScreen(
                                        transactionType: _selectedType,
                                      ),
                                    ),
                                  );

                                  if (result != null) {
                                    setState(() {
                                      _selectedCategory = result['category'];
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.category,
                                        color: AppTheme.primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _selectedCategory ?? 'Chọn danh mục',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.chevron_right),
                                  ],
                                ),
                              )
                            : Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.category,
                                      color: AppTheme.primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    widget.transaction.category,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),

                // Ghi chú
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          'Ghi chú',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
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
                        child: _isEditing
                            ? TextField(
                                controller: _noteController,
                                decoration: const InputDecoration(
                                  hintText: 'Thêm ghi chú',
                                  border: InputBorder.none,
                                ),
                                maxLines: 3,
                              )
                            : Text(
                                widget.transaction.note ?? '',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),

                // Ngày
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          'Ngày giao dịch',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
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
                        child: InkWell(
                          onTap: _isEditing
                              ? () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: _selectedDate,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _selectedDate = picked;
                                    });
                                  }
                                }
                              : null,
                          child: Row(
                            children: [
                              Container(
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
                              const SizedBox(width: 12),
                              Text(
                                DateFormat('dd/MM/yyyy').format(_selectedDate),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
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
    );
  }

  void _handleDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc chắn muốn xóa giao dịch này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              final transactionService = ref.read(transactionServiceProvider);
              final walletService = ref.read(walletServiceProvider);
              
              transactionService.deleteTransactionItem(widget.transaction.id);
              walletService.processTransactionAmount(
                widget.transaction.wallet,
                -widget.transaction.amount,
                widget.transaction.type,
              );
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, true); // Return to previous screen with refresh flag
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
