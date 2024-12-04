String formatNumber(double amount) {
  // Định dạng số với dấu phẩy
  return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
} 