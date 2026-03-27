import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyProvider extends ChangeNotifier {
  bool isFetching = true;
  Map<String, dynamic> _rates = {};

  CurrencyProvider() {
    _fetchAllRates();
  }

  Future<void> _fetchAllRates() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://latest.currency-api.pages.dev/v1/currencies/ngn.json',
        ),
      );
      if (response.statusCode == 200) {
        _rates = json.decode(response.body)['ngn'];
      }
    } catch (e) {
      debugPrint('Offline: Using fallback rates');
    }
    isFetching = false;
    notifyListeners();
  }

  double getConvertedValue(double amount, String currencySymbol) {
    if (_rates.isEmpty) return amount;

    String targetCode = 'ngn';
    if (currencySymbol == '\$')
      targetCode = 'usd';
    else if (currencySymbol == '€')
      targetCode = 'eur';
    else if (currencySymbol == '£')
      targetCode = 'gbp';
    else if (currencySymbol == '¥')
      targetCode = 'jpy';
    else if (currencySymbol == '₦')
      targetCode = 'ngn';

    if (targetCode == 'ngn') return amount;

    final rate = _rates[targetCode];
    if (rate != null && rate > 0) {
      return amount / rate;
    }
    return amount;
  }
}
