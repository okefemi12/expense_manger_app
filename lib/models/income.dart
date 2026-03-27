class Income {
  final String id;
  final double amount;
  final String source; // e.g., Salary, Freelance, Gift
  final String note;
  final DateTime date;
  final String paymentMethod; // Cash, Bank Transfer, Card

  Income({
    required this.id,
    required this.amount,
    required this.source,
    required this.note,
    required this.date,
    required this.paymentMethod,
  });

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      source: json['source'] ?? '',
      note: json['note'] ?? '',
      date: DateTime.parse(json['date']),
      paymentMethod: json['paymentMethod'] ?? 'Cash',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'source': source,
      'note': note,
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod,
    };
  }
}