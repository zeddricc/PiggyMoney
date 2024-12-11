import 'package:flutter/material.dart';

IconData getWalletIcon(String walletType) {
  switch (walletType) {
    case 'Investment':
      return Icons.trending_up;
    case 'Bank':
      return Icons.account_balance;
    case 'Credit Card':
      return Icons.credit_card;
    case 'E-Wallet':
      return Icons.mobile_friendly;
    case 'Cash':
      return Icons.money_rounded;
    case 'Others':
    default:
      return Icons.wallet_giftcard;
  }
} 