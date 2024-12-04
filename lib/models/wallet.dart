class Wallet {
  final String id;
  final String name;
  final double initBalance;
  final String walletType;
  final String currency;
  final String? note;

  Wallet({
    required this.id,
    required this.name,
    this.initBalance = 0.0,
    required this.walletType,
    required this.currency,
    this.note,
  });
} 