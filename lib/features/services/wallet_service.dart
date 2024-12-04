import 'package:piggymoney/models/wallet.dart';

class WalletService {
  List<Wallet> _wallets = [];

  List<Wallet> getAllWallets() {
    print('Fetching all wallets. Total wallets: ${_wallets.length}');
    for (var wallet in _wallets) {
      print('Wallet: ${wallet.name}, Balance: ${wallet.initBalance}, Type: ${wallet.walletType}, Currency: ${wallet.currency}');
    }
    return _wallets;
  }

  void addWallet(Wallet wallet) {
    _wallets.add(wallet);
    print('Added wallet: ${wallet.name}, Balance: ${wallet.initBalance}, Type: ${wallet.walletType}, Currency: ${wallet.currency}');
  }

  void deleteWallet(String id) {
    _wallets.removeWhere((wallet) {
      final exists = wallet.id == id;
      if (exists) {
        print('Deleted wallet: ${wallet.name}');
      }
      return exists;
    });
  }

  void updateWallet(Wallet updatedWallet) {
    final index = _wallets.indexWhere((wallet) => wallet.id == updatedWallet.id);
    if (index != -1) {
      _wallets[index] = updatedWallet;
      print('Updated wallet: ${updatedWallet.name}, New Balance: ${updatedWallet.initBalance}');
    } else {
      print('Wallet with id: ${updatedWallet.id} not found for update.');
    }
  }

  // Additional methods for wallet management can be added here
}