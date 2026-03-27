import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:expense_manager/providers/category_tag_provider.dart';

class TagManagementScreen extends StatelessWidget {
  final bool
  isCategory; // If true, it manages Categories. If false, it manages Tags.
  const TagManagementScreen({super.key, this.isCategory = true});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryTagProvider>();
    final items = isCategory ? provider.categories : provider.tags;
    final title = isCategory ? "Manage Categories" : "Manage Tags";

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white54),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Icon(
                isCategory ? Icons.category : Icons.local_offer,
                color: const Color(0xFF93A8D0),
              ),
              title: Text(item, style: GoogleFonts.inter(color: Colors.white)),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFEF4444),
                ),
                onPressed: () {
                  if (isCategory) {
                    provider.deleteCategory(item);
                  } else {
                    provider.deleteTag(item);
                  }
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, isCategory, provider),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddDialog(
    BuildContext context,
    bool isCategory,
    CategoryTagProvider provider,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            title: Text(
              'Add ${isCategory ? "Category" : "Tag"}',
              style: const TextStyle(color: Colors.white),
            ),
            content: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Name...',
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (isCategory)
                    provider.addCategory(controller.text);
                  else
                    provider.addTag(controller.text);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
    );
  }
}
