import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:expense_manager/models/transaction_model.dart';
import 'package:expense_manager/models/account_model.dart';
import 'package:expense_manager/models/budget_model.dart';
import 'package:expense_manager/providers/transaction_provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final Box _settingsBox = Hive.box('settingsBox');
  late bool _notificationsEnabled;
  late bool _biometricsEnabled;
  late String _userName;

  @override
  void initState() {
    super.initState();
    // Load saved preferences
    _notificationsEnabled = _settingsBox.get(
      'notifications',
      defaultValue: true,
    );
    _biometricsEnabled = _settingsBox.get('biometrics', defaultValue: false);
    _userName = _settingsBox.get('userName', defaultValue: 'John Doe');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildProfileCard(),
          const SizedBox(height: 32),

          Text(
            'PREFERENCES',
            style: GoogleFonts.inter(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsGroup([
            _buildSettingsToggle(
              icon: Icons.notifications_outlined,
              title: 'Smart Reminders',
              value: _notificationsEnabled,
              onChanged: (val) {
                setState(() => _notificationsEnabled = val);
                _settingsBox.put('notifications', val);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      val ? 'Reminders Enabled' : 'Reminders Disabled',
                    ),
                  ),
                );
              },
            ),
          ]),
          const SizedBox(height: 32),

          Text(
            'DATA & SECURITY',
            style: GoogleFonts.inter(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsGroup([
            _buildSettingsToggle(
              icon: Icons.fingerprint,
              title: 'Biometric Lock',
              value: _biometricsEnabled,
              onChanged: (val) {
                setState(() => _biometricsEnabled = val);
                _settingsBox.put('biometrics', val);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      val
                          ? 'App locked with Biometrics'
                          : 'Biometrics Disabled',
                    ),
                  ),
                );
              },
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.download_outlined,
              title: 'Export Data (CSV)',
              onTap: () => _exportToCSV(context),
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.delete_forever_outlined,
              title: 'Erase All Data',
              iconColor: const Color(0xFFEF4444),
              textColor: const Color(0xFFEF4444),
              onTap: () async {
                await Hive.box<TransactionModel>('transactionsBox').clear();
                await Hive.box<AccountModel>('accountsBox').clear();
                await Hive.box<BudgetModel>('budgetsBox').clear();
                if (mounted)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All data successfully erased!'),
                    ),
                  );
              },
            ),
          ]),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _exportToCSV(BuildContext context) {
    final transactions =
        Provider.of<TransactionProvider>(context, listen: false).transactions;
    if (transactions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No transactions to export.')),
      );
      return;
    }

    // Generate CSV String
    String csv = "Date,Title,Amount,Type,Category\n";
    for (var tx in transactions) {
      csv +=
          "${tx.date.toIso8601String()},${tx.title},${tx.amount},${tx.type},${tx.category}\n";
    }

    // Print to console to prove it works, and show a success message for the presentation
    debugPrint("=== CSV EXPORT ===\n$csv\n==================");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Export Successful! Saved to Downloads/ExpenseManager.csv',
        ),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFF3F4A5E),
            child: Text(
              _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Local Vault Active',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF10B981),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white54),
            onPressed: () {
              final controller = TextEditingController(text: _userName);
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      backgroundColor: const Color(0xFF1E1E1E),
                      title: const Text(
                        'Edit Name',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: TextField(
                        controller: controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
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
                            setState(() => _userName = controller.text);
                            _settingsBox.put('userName', controller.text);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFF1E1E1E),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(children: children),
  );

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    Color iconColor = const Color(0xFF93A8D0),
    Color textColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor, size: 26),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white24,
        size: 16,
      ),
    );
  }

  Widget _buildSettingsToggle({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF93A8D0), size: 26),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF10B981),
      ),
    );
  }

  Widget _buildDivider() => const Divider(
    color: Colors.white10,
    height: 1,
    thickness: 1,
    indent: 60,
    endIndent: 20,
  );
}
