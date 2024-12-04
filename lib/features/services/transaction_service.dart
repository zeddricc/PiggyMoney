import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:piggymoney/models/transaction.dart';

class TransactionService {
  late Realm _realm;
  double _totalBalance = 0.0;

  TransactionService() {
    final config = Configuration.local([TransactionItem.schema]);
    _realm = Realm(config);
    _totalBalance = calculateTotalBalance();
  }

  Future<void> addTransactionItem({
    required double amount,
    required String type,
    required String category,
    required String wallet,
    String? note,
    required DateTime date,
    required String repeatPattern,
  }) async {
    final transactionItem = TransactionItem(
      ObjectId(),
      amount,
      type,
      category,
      wallet,
      date,
      repeatPattern,
      note: note,
    );

    _realm.write(() {
      _realm.add(transactionItem);
      print('Transaction added: ${transactionItem.toEJson()}');

      if (type == 'EXPENSES') {
        _totalBalance -= amount;
      } else if (type == 'INCOME') {
        _totalBalance += amount;
      }
    });

    print('Current total balance: $_totalBalance');
  }

  double calculateTotalBalance() {
    final transactions = getAllTransactions();
    return transactions.fold(
        0.0, (sum, transaction) => sum + transaction.amount);
  }

  double get totalBalance => _totalBalance;

  List<TransactionItem> getAllTransactions() {
    return _realm.all<TransactionItem>().toList();
  }

  Future<void> deleteTransactionItem(ObjectId id) async {
    try {
      _realm.write(() {
        final transactionItem = _realm.find<TransactionItem>(id);
        if (transactionItem != null) {
          print('Deleting transaction: ${transactionItem.toEJson()}');

          _realm.delete(transactionItem);

          print('Transaction deleted successfully.');
        } else {
          print('Transaction not found for ID: $id');
        }
      });
    } catch (e) {
      print('Error deleting transaction: $e');
    }
  }

  Future<void> updateTransactionItem({
    required ObjectId id,
    required double amount,
    required String type,
    required String category,
    required String wallet,
    String? note,
    required DateTime date,
    required String repeatPattern,
  }) async {
    _realm.write(() {
      final transactionItem = _realm.find<TransactionItem>(id);
      if (transactionItem != null) {
        transactionItem.amount = amount;
        transactionItem.type = type;
        transactionItem.category = category;
        transactionItem.wallet = wallet;
        transactionItem.note = note;
        transactionItem.date = date;
        transactionItem.repeatPattern = repeatPattern;

        print('Transaction updated: ${transactionItem.toEJson()}');
      } else {
        print('Transaction not found for ID: $id');
      }
    });
  }

  void dispose() {
    _realm.close();
  }
}
