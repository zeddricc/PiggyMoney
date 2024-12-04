import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionState {
  String selectedType;
  String selectedCategory;
  String selectedWallet;
  String note;
  DateTime selectedDate;
  String? selectedCategoryIcon;

  TransactionState({
    this.selectedType = 'EXPENSES',
    this.selectedCategory = 'Groceries',
    this.selectedWallet = 'Spending',
    this.note = 'Monthly grocery shopping',
    DateTime? selectedDate,
    this.selectedCategoryIcon,
  }) : selectedDate = selectedDate ?? DateTime.now();
}

class TransactionNotifier extends StateNotifier<TransactionState> {
  TransactionNotifier() : super(TransactionState());

  void updateType(String type) {
    state = TransactionState(
      selectedType: type,
      selectedCategory: state.selectedCategory,
      selectedWallet: state.selectedWallet,
      note: state.note,
      selectedDate: state.selectedDate,
      selectedCategoryIcon: state.selectedCategoryIcon,
    );
  }

  void updateCategory(String category, String categoryIcon) {
    state = TransactionState(
      selectedType: state.selectedType,
      selectedCategory: category,
      selectedCategoryIcon: categoryIcon,
      selectedWallet: state.selectedWallet,
      note: state.note,
      selectedDate: state.selectedDate,
    );
  }

  void updateWallet(String wallet) {
    state = TransactionState(
      selectedType: state.selectedType,
      selectedCategory: state.selectedCategory,
      selectedWallet: wallet,
      note: state.note,
      selectedDate: state.selectedDate,
      selectedCategoryIcon: state.selectedCategoryIcon,
    );
  }

  void updateNote(String note) {
    state = TransactionState(
      selectedType: state.selectedType,
      selectedCategory: state.selectedCategory,
      selectedWallet: state.selectedWallet,
      note: note,
      selectedDate: state.selectedDate,
      selectedCategoryIcon: state.selectedCategoryIcon,
    );
  }

  void updateDate(DateTime date) {
    state = TransactionState(
      selectedType: state.selectedType,
      selectedCategory: state.selectedCategory,
      selectedWallet: state.selectedWallet,
      note: state.note,
      selectedDate: date,
      selectedCategoryIcon: state.selectedCategoryIcon,
    );
  }
}

final transactionProvider = StateNotifierProvider<TransactionNotifier, TransactionState>(
  (ref) => TransactionNotifier(),
); 