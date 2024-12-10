import 'package:piggymoney/models/wallet.dart';
import 'package:realm/realm.dart';

class WalletService {
  late Realm _realm;

  WalletService() {
    final config = Configuration.local([WalletItem.schema]);
    _realm = Realm(config);
  }

  List<WalletItem> getAllWallets() {
    final wallets = _realm.all<WalletItem>().toList();
    print('Fetching all wallets. Total wallets: ${wallets.length}');
    for (var wallet in wallets) {
      print(
          'Wallet: ${wallet.name}, Balance: ${wallet.initBalance}, Type: ${wallet.walletType}, Currency: ${wallet.currency}');
    }
    return wallets;
  }

  void addWallet(WalletItem wallet) {
    _realm.write(() {
      _realm.add(wallet);
    });
    print(
        'Added wallet: ${wallet.name}, ID: ${wallet.id}, Balance: ${wallet.initBalance}, Type: ${wallet.walletType}, Currency: ${wallet.currency}');
  }

  void deleteWallet(String id) {
    _realm.write(() {
      final walletToDelete = _realm.all<WalletItem>().query("id == '$id'").firstOrNull;

      if (walletToDelete != null && walletToDelete.isValid) {
        final walletName = walletToDelete.name;
        _realm.delete(walletToDelete);
        print('Deleted wallet: $walletName');
      } else {
        print('Wallet with id: $id not found for deletion.');
      }
    });
  }

  void updateWallet(WalletItem updatedWallet) {
    _realm.write(() {
        // Log existing wallets for debugging
        final existingWallets = _realm.all<WalletItem>().toList();
        print('Existing wallets before update: ${existingWallets.map((w) => w.id).toList()}');

        // Find the existing wallet
        final existingWallet = _realm.all<WalletItem>().firstWhere(
            (wallet) => wallet.id == updatedWallet.id,
            orElse: () {
                throw Exception('Wallet with id: ${updatedWallet.id} not found for update.');
            },
        );

        // Proceed with the update if the wallet is found
        existingWallet.name = updatedWallet.name;
        existingWallet.initBalance = updatedWallet.initBalance;
        existingWallet.walletType = updatedWallet.walletType;
        existingWallet.currency = updatedWallet.currency;
        existingWallet.note = updatedWallet.note;

        print('Updated wallet: ${updatedWallet.name}, New Balance: ${updatedWallet.initBalance}');
    });
  }

  void updateWalletBalance(String walletId, double amount) {
    _realm.write(() {
      final wallet = _realm.all<WalletItem>().query("id == '$walletId'").firstOrNull;
      
      if (wallet != null && wallet.isValid) {
        final oldBalance = wallet.initBalance;
        wallet.initBalance -= amount;
        print('Cập nhật ví ${wallet.name}: Số dư cũ: $oldBalance -> Số dư mới: ${wallet.initBalance}');
      } else {
        print('Không tìm thấy ví với id: $walletId');
      }
    });
  }

  void processTransactionAmount(String walletId, double amount, String transactionType) {
    _realm.write(() {
      final wallet = _realm.all<WalletItem>().query("id == '$walletId'").firstOrNull;
      
      if (wallet != null && wallet.isValid) {
        final oldBalance = wallet.initBalance;
        
        // Nếu là chi tiêu thì trừ, thu nhập thì cộng
        if (transactionType == 'EXPENSES') {
          wallet.initBalance -= amount;
        } else if (transactionType == 'INCOME') {
          wallet.initBalance += amount;
        }
        
        print('Cập nhật ví ${wallet.name}: Số dư cũ: $oldBalance -> Số dư mới: ${wallet.initBalance}');
      } else {
        print('Không tìm thấy ví với id: $walletId');
      }
    });
  }
}
