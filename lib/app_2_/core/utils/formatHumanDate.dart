import 'dart:convert';

import 'package:intl/intl.dart';

void prettyPrintJson(dynamic data) {
  const encoder = JsonEncoder.withIndent('  ');
  print(encoder.convert(data));
}

final currencyFormatter = NumberFormat("#,###", "en_US");

final currency = NumberFormat.currency(
  locale: 'en_US',
  symbol: 'KES ',
  decimalDigits: 0,
);

String ceilCurrency(double value) {
  final ceiled = value.ceilToDouble();
  return currency.format(ceiled);
}

double ceilTo2dp(num value) {
  return (value * 100).ceil() / 100;
}

String formatMoney(num value) {
  final rounded = (value * 100).ceil() / 100;
  return rounded.toStringAsFixed(2);
}

int ceilToShilling(num value) {
  return value.ceil();
}

double normalizeMoney(num value) {
  return value.ceilToDouble(); // same logic as your UI
}

final NumberFormat currencyFormat = NumberFormat.currency(
  locale: 'en_US',
  symbol: '',
);
String formatHumanDate(String dateString) {
  if (dateString.isEmpty) return 'Not set';
  try {
    // Parse input in the exact format yyyy/MM/dd
    // DateTime date = DateFormat('yyyy/MM/dd').parse(dateString.trim());
    DateTime date = DateTime.parse(dateString);
    // Format to dd/MM/yyyy
    return DateFormat('dd/MM/yyyy').format(date);
  } catch (e) {
    // If parsing fails, return raw string
    return dateString;
  }
}

String formatHumanDate_(String dateString) {
  if (dateString.isEmpty) return '';
  try {
    DateTime date = DateTime.parse(dateString);
    return DateFormat("EEEE, d MMMM y").format(date);
  } catch (e) {
    return dateString;
  }
}

String formatHumanDate_B(String dateString) {
  if (dateString.isEmpty) return 'Not set';

  try {
    // 1. Explicitly parse the format you save in your controllers (yyyy-MM-dd)
    // This is safer than DateTime.parse()
    DateTime date = DateFormat('yyyy-MM-dd').parse(dateString.trim());

    // 2. Return the beautiful human format
    return DateFormat("EEEE, d MMMM y").format(date);
  } catch (e) {
    // If it fails, we return the raw string so we can see what went wrong
    //  Print("Formatting error for date '$dateString': $e");
    return dateString;
  }
}

String toTitleCase(String text) {
  return text
      .split(' ')
      .map(
        (word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '',
      )
      .join(' ');
}
