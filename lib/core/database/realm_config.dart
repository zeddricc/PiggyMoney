import 'package:realm/realm.dart';
import 'package:piggymoney/models/wallet.dart';
import 'package:piggymoney/models/transaction.dart';

class RealmConfig {
  static final RealmConfig _instance = RealmConfig._internal();
  static final Realm _realm = Realm(
    Configuration.local([
      WalletItem.schema,
      TransactionItem.schema,
    ]),
  );

  factory RealmConfig() {
    return _instance;
  }

  RealmConfig._internal();

  static Realm get instance => _realm;

  static void dispose() {
    _realm.close();
  }
} 