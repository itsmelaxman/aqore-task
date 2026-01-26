import 'dart:math';

class CodeGenerator {
  CodeGenerator._();

  static final _random = Random();
  static const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  /// Generate a unique item SKU code
  /// Format: ITM-YYYYMMDD-XXXX
  static String generateItemCode() {
    final dateStr = _getDateString();
    final randomStr = _generateRandomString(4);
    return 'ITM-$dateStr-$randomStr';
  }

  /// Generate a unique purchase order number
  /// Format: PO-YYYYMMDD-XXXX
  static String generatePurchaseOrderNumber() {
    final dateStr = _getDateString();
    final randomStr = _generateRandomString(4);
    return 'PO-$dateStr-$randomStr';
  }

  /// Generate a unique receipt number
  /// Format: RCP-YYYYMMDD-XXXX
  static String generateReceiptNumber() {
    final dateStr = _getDateString();
    final randomStr = _generateRandomString(4);
    return 'RCP-$dateStr-$randomStr';
  }

  /// Get current date in YYYYMMDD format
  static String _getDateString() {
    final now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
  }

  /// Generate random alphanumeric string of given length
  static String _generateRandomString(int length) {
    return List.generate(
      length,
      (_) => _chars[_random.nextInt(_chars.length)],
    ).join();
  }
}
