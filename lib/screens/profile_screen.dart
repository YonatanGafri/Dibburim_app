import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final authService = context.read<AuthService>();
    await authService.signOut();
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('מחיקת חשבון'),
        content: const Text('האם אתה בטוח שברצונך למחוק את החשבון? פעולה זו תמחק לצמיתות את כל המידע השמור שלך ולא ניתנת לביטול.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('ביטול'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('מחק חשבון'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final authService = context.read<AuthService>();
        await authService.deleteAccount();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('החשבון נמחק בהצלחה.')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('שגיאה במחיקת החשבון: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('פרופיל אישי')),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Icon(Icons.account_circle, size: 100, color: Colors.blueGrey),
          const SizedBox(height: 16),
          Text(
            user?.email ?? 'אורח',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('התנתק'),
            onPressed: () => _logout(context),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red,
            ),
            icon: const Icon(Icons.delete_forever),
            label: const Text('מחק חשבון לצמיתות'),
            onPressed: () => _deleteAccount(context),
          ),
          const SizedBox(height: 20),
          const Text(
            'מחיקת חשבון נדרשת כחלק ממדיניות גוגל פליי להגנה על פרטיות המשתמש.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
