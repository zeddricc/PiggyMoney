import 'package:flutter_riverpod/flutter_riverpod.dart';

final balanceVisibilityProvider = StateNotifierProvider<BalanceVisibilityNotifier, bool>((ref) {
  return BalanceVisibilityNotifier();
});

class BalanceVisibilityNotifier extends StateNotifier<bool> {
  BalanceVisibilityNotifier() : super(true);

  void toggleVisibility() {
    state = !state;
  }
} 