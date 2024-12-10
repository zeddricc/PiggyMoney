import 'package:realm/realm.dart';

part 'wallet.realm.dart'; // This will be generated

@RealmModel()


class _WalletItem {
  @PrimaryKey()
  late String id; // Unique identifier
  late String name;
  late double initBalance;
  late String walletType;
  late String currency;
  String? note;
}
