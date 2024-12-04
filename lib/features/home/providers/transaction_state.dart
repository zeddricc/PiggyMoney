import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionState {
  String selectedType;
  String selectedCategory;
  String selectedWallet;
  String note;
  DateTime selectedDate;

  TransactionState({
    this.selectedType = 'EXPENSES',
    this.selectedCategory = 'Groceries',
    this.selectedWallet = 'Spending',
    this.note = 'Monthly grocery shopping',
    DateTime? selectedDate,
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
    );
  }

  void updateCategory(String category) {
    state = TransactionState(
      selectedType: state.selectedType,
      selectedCategory: category,
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
    );
  }

  void updateNote(String note) {
    state = TransactionState(
      selectedType: state.selectedType,
      selectedCategory: state.selectedCategory,
      selectedWallet: state.selectedWallet,
      note: note,
      selectedDate: state.selectedDate,
    );
  }

  void updateDate(DateTime date) {
    state = TransactionState(
      selectedType: state.selectedType,
      selectedCategory: state.selectedCategory,
      selectedWallet: state.selectedWallet,
      note: state.note,
      selectedDate: date,
    );
  }
}

final transactionProvider = StateNotifierProvider<TransactionNotifier, TransactionState>(
  (ref) => TransactionNotifier(),
); 