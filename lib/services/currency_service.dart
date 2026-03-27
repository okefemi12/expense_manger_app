import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  // Using the fallback pages.dev URL as recommended by the API creator for stability
  static const String baseUrl =
      'https://latest.currency-api.pages.dev/v1/currencies';

  // Fetch conversion rate from Naira to any target currency (e.g., 'usd', 'gbp')
  static Future<double> getRateFromNaira(String targetCurrency) async {
    try {
      // This endpoint gets the value of 1 NGN in every other currency
      final response = await http.get(Uri.parse('$baseUrl/ngn.json'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // The API returns JSON like: { "date": "...", "ngn": { "usd": 0.00063, "gbp": 0.0005 } }
        final rate = data['ngn'][targetCurrency.toLowerCase()];
        return rate.toDouble();
      }
      return 0.0;
    } catch (e) {
      print('Error fetching exchange rate: $e');
      return 0.0; // Return 0 if the user is offline
    }
  }

  // Helper method to do the actual math
  static Future<double> convertNairaTo(
    double nairaAmount,
    String targetCurrency,
  ) async {
    final rate = await getRateFromNaira(targetCurrency);
    return nairaAmount * rate;
  }
}
