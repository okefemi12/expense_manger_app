import 'package:hive/hive.dart';

part 'account_model.g.dart';

@HiveType(typeId: 1) // Must be 1 because Transaction is 0
class AccountModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double startingBalance;

  @HiveField(3)
  final String currencySymbol;

  @HiveField(4)
  final int colorValue; // Saves the color as an integer

  AccountModel({
    required this.id,
    required this.name,
    required this.startingBalance,
    required this.currencySymbol,
    required this.colorValue,
  });
}
