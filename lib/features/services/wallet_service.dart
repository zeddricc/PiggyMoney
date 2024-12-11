import 'package:realm/realm.dart';
import 'package:piggymoney/models/wallet.dart';
import 'package:piggymoney/models/transaction.dart';
import 'package:piggymoney/core/database/realm_config.dart';

class WalletService {
  final Realm _realm = RealmConfig.instance;

  List<WalletItem> getAllWallets() {
    return _realm.all<WalletItem>().toList();
  }

  void addWallet(WalletItem wallet) {
    try {
      _realm.write(() {
        _realm.add(wallet);
      });
      print('Added wallet: ${wallet.name}');
    } catch (e) {
      print('Error adding wallet: $e');
      throw Exception('Failed to add wallet');
    }
  }

  void deleteWallet(String id) {
    try {
      print('Attempting to delete wallet with ID: $id');
      
      _realm.write(() {
        // Tìm ví cần xóa
        final walletToDelete = _realm.all<WalletItem>()
            .where((wallet) => wallet.id == id)
            .firstOrNull;
        
        if (walletToDelete != null && walletToDelete.isValid) {
          // Tìm và xóa tất cả giao dịch liên quan đến ví
          final relatedTransactions = _realm.all<TransactionItem>()
              .where((transaction) => transaction.wallet == id)
              .toList();
              
          for (var transaction in relatedTransactions) {
            _realm.delete(transaction);
          }
          
          // Xóa ví
          final walletName = walletToDelete.name;
          _realm.delete(walletToDelete);
          print('Successfully deleted wallet: $walletName and its ${relatedTransactions.length} transactions');
        } else {
          print('Wallet with id: $id not found for deletion.');
          throw Exception('Wallet not found');
        }
      });
    } catch (e) {
      print('Error deleting wallet: $e');
      rethrow;
    }
  }

  void updateWallet(WalletItem updatedWallet) {
    try {
      print('Attempting to update wallet with ID: ${updatedWallet.id}');
      
      _realm.write(() {
        // Tìm ví cần cập nhật bằng ID string
        final existingWallet = _realm.all<WalletItem>()
            .where((wallet) => wallet.id == updatedWallet.id)
            .firstOrNull;
        
        if (existingWallet != null && existingWallet.isValid) {
          // Lưu lại thông tin cũ để log
          final oldBalance = existingWallet.initBalance;
          final oldName = existingWallet.name;

          // Cập nhật thông tin ví
          existingWallet.name = updatedWallet.name;
          existingWallet.initBalance = updatedWallet.initBalance;
          existingWallet.walletType = updatedWallet.walletType;
          existingWallet.currency = updatedWallet.currency;
          existingWallet.note = updatedWallet.note;
          
          print('Successfully updated wallet: $oldName -> ${existingWallet.name}, Balance: $oldBalance -> ${existingWallet.initBalance}');
        } else {
          print('Wallet not found for update: ${updatedWallet.id}');
          throw Exception('Wallet not found');
        }
      });
    } catch (e) {
      print('Error updating wallet: $e');
      rethrow;
    }
  }

  // Tính số dư thực tế của ví dựa trên các giao dịch
  double getActualBalance(String walletId) {
    try {
      final wallet = _realm.all<WalletItem>()
          .where((wallet) => wallet.id == walletId)
          .firstOrNull;
          
      if (wallet == null) {
        print('Wallet not found for balance calculation: $walletId');
        return 0.0;
      }
      
      // Lấy số dư ban đầu
      double balance = wallet.initBalance;

      // Lấy tất cả giao dịch của ví này
      final transactions = _realm.all<TransactionItem>()
          .where((transaction) => transaction.wallet == walletId)
          .toList();

      // Cộng/trừ số tiền từ các giao dịch
      for (var transaction in transactions) {
        balance += transaction.amount; // Đã có dấu +/- trong amount
      }

      print('Calculated balance for wallet ${wallet.name}: $balance');
      return balance;
    } catch (e) {
      print('Error calculating balance for wallet $walletId: $e');
      return 0.0;
    }
  }

  // Thêm lại phương thức processTransactionAmount
  void processTransactionAmount(String walletId, double amount, String transactionType) {
    try {
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
          throw Exception('Wallet not found');
        }
      });
    } catch (e) {
      print('Error processing transaction amount: $e');
      throw Exception('Failed to process transaction');
    }
  }
}
