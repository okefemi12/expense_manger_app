import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CategoryTagProvider extends ChangeNotifier {
  // We use a generic box so we don't have to run build_runner!
  final Box _box = Hive.box('settingsBox');

  // Default Categories
  List<String> get categories {
    return _box.get('categories', defaultValue: ['Food', 'Transport', 'Entertainment', 'Salary'])?.cast<String>() ?? [];
  }

  // Default Tags
  List<String> get tags {
    return _box.get('tags', defaultValue: ['Personal', 'Business', 'Family'])?.cast<String>() ?? [];
  }

  void addCategory(String category) {
    final list = categories;
    if (!list.contains(category) && category.trim().isNotEmpty) {
      list.add(category.trim());
      _box.put('categories', list);
      notifyListeners();
    }
  }

  void deleteCategory(String category) {
    final list = categories;
    list.remove(category);
    _box.put('categories', list);
    notifyListeners();
  }

  void addTag(String tag) {
    final list = tags;
    if (!list.contains(tag) && tag.trim().isNotEmpty) {
      list.add(tag.trim());
      _box.put('tags', list);
      notifyListeners();
    }
  }

  void deleteTag(String tag) {
    final list = tags;
    list.remove(tag);
    _box.put('tags', list);
    notifyListeners();
  }
}