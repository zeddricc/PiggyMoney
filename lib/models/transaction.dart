
import 'package:realm/realm.dart';

part 'transaction.realm.dart';

@RealmModel()
class _TransactionItem {
    @PrimaryKey()
  late ObjectId id;
  
  late double amount;
  late String type; // 'EXPENSES', 'INCOME', 'TRANSFER'
  late String category;
  late String wallet;
  late String? note;
  late DateTime date;
  late String repeatPattern; // 'NEVER', 'DAILY', 'WEEKLY', 'MONTHLY'
  
  
} 