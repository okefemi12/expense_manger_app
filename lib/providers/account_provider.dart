import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/account_model.dart';

class AccountProvider extends ChangeNotifier {
  final Box<AccountModel> _box = Hive.box<AccountModel>('accountsBox');

  List<AccountModel> get accounts => _box.values.toList();

  Future<void> addAccount(AccountModel account) async {
    await _box.put(account.id, account);
    notifyListeners();
  }

  Future<void> deleteAccount(String id) async {
    await _box.delete(id);
    notifyListeners();
  }
}
