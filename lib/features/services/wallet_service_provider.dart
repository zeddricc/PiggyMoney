import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'wallet_service.dart';

final walletServiceProvider = Provider<WalletService>((ref) {
  return WalletService(); // Create a single instance of WalletService
}); 