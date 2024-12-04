import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:piggymoney/models/transaction.dart';

class TransactionService {
  late Realm _realm;

  TransactionService() {
    final config = Configuration.local([TransactionItem.schema]);
    _realm = Realm(config);
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
      ObjectId(), // Generate a new ObjectId
      amount,
      type,
      category,
      wallet,
      date,
      repeatPattern,
      note: note,
      
    );

    _realm.write(() {
      _realm.add(transactionItem); // Add the transaction item to Realm
      print('Transaction added: ${transactionItem.toEJson()}'); // Log the transaction details
    });
  }

  List<TransactionItem> getAllTransactions() {
    return _realm.all<TransactionItem>().toList();
  }

  Future<void> deleteTransactionItem(ObjectId id) async {
    try {
      _realm.write(() {
        final transactionItem = _realm.find<TransactionItem>(id);
        if (transactionItem != null) {
          // Log the transaction details before deletion
          print('Deleting transaction: ${transactionItem.toEJson()}');
          
          // Delete the transaction item from Realm
          _realm.delete(transactionItem); 
          
          // Do not access transactionItem after deletion
          print('Transaction deleted successfully.'); // Log the deletion without accessing the object
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
        // Update the fields of the transaction item
        transactionItem.amount = amount;
        transactionItem.type = type;
        transactionItem.category = category;
        transactionItem.wallet = wallet;
        transactionItem.note = note;
        transactionItem.date = date;
        transactionItem.repeatPattern = repeatPattern;

        print('Transaction updated: ${transactionItem.toEJson()}'); // Log the update
      } else {
        print('Transaction not found for ID: $id');
      }
    });
  }

  double calculateTotalBalance() {
    final transactions = getAllTransactions();
    return transactions.fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  void dispose() {
    _realm.close();
  }
} 