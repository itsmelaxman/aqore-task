import 'package:intl/intl.dart';

class Validators {
  /// Validate [required] field
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate [email] format
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  /// Validate [phone] number format
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length < 10 || value.length > 15) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  /// Validate [number] format
  static String? number(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (double.tryParse(value) == null) {
      return 'Enter a valid number';
    }
    return null;
  }

  /// Validate [positive number] format
  static String? positiveNumber(
    String? value, {
    String fieldName = 'This field',
  }) {
    final numberError = number(value, fieldName: fieldName);
    if (numberError != null) return numberError;

    if (double.parse(value!) <= 0) {
      return '$fieldName must be greater than 0';
    }
    return null;
  }
}

class Formatters {
  static final currencyFormatter = NumberFormat.currency(
    symbol: 'Rs. ',
    decimalDigits: 2,
  );
  static final dateFormatter = DateFormat('MMM dd, yyyy');
  static final dateTimeFormatter = DateFormat('MMM dd, yyyy HH:mm');

  /// Format [currency] with symbol
  static String formatCurrency(double amount) {
    return currencyFormatter.format(amount);
  }

  /// Format [date]
  static String formatDate(DateTime date) {
    return dateFormatter.format(date);
  }
}
