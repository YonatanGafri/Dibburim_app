import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../data/strings.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final authService = context.read<AuthService>();
    await authService.signOut();
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final isEnabled = controller.text == 'מחק';
            return AlertDialog(
              title: Text(AppStrings.neutral('profileDeleteDialogTitle')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.neutral('profileDeleteDialogContent')),
                  const SizedBox(height: 16),
                  Text(AppStrings.neutral('profileDeleteDialogInstructions')),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    onChanged: (value) => setState(() {}), // rebuilds to enable button
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: AppStrings.neutral('profileDeleteDialogHint'),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(AppStrings.neutral('profileDeleteDialogCancel')),
                ),
                TextButton(
                  onPressed: isEnabled ? () => Navigator.of(context).pop(true) : null,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    disabledForegroundColor: Colors.grey,
                  ),
                  child: Text(AppStrings.neutral('profileDeleteDialogConfirm')),
                ),
              ],
            );
          }
        );
      },
    );

    if (confirmed == true && context.mounted) {
      try {
        final authService = context.read<AuthService>();
        await authService.deleteAccount();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppStrings.neutral('profileDeleteSuccess'))),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppStrings.neutral('profileDeleteError')} $e')),
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
      appBar: AppBar(title: Text(AppStrings.neutral('profileTitle'))),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Icon(Icons.account_circle, size: 100, color: Colors.blueGrey),
          const SizedBox(height: 16),
          Text(
            user?.email ?? AppStrings.neutral('profileGuest'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: Text(AppStrings.neutral('profileLogout')),
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
            label: Text(AppStrings.neutral('profileDeleteAccount')),
            onPressed: () => _deleteAccount(context),
          ),
          const SizedBox(height: 20),
          Text(
            AppStrings.neutral('profileDeletePolicy'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 40),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final info = snapshot.data!;
                return Text(
                  'Version: ${info.version} (${info.buildNumber})',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
