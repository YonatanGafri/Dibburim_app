import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  bool _isLogin = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submitEmailAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final authService = context.read<AuthService>();
      if (_isLogin) {
        await authService.signInWithEmail(email, password);
      } else {
        await authService.signUpWithEmail(email, password);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('נשלח מייל לאימות, אנא בדוק את תיבת הדואר שלך.')),
          );
        }
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final authService = context.read<AuthService>();
      final response = await authService.signInWithGoogle();
      if (response != null && mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאת התחברות עם גוגל: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('אנא הזן אימייל לפני בקשת איפוס סיסמה')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final authService = context.read<AuthService>();
      await authService.resetPasswordForEmail(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('נשלח קישור לאיפוס סיסמה, בדוק את תיבת הדואר שלך')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה בשליחת איפוס: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('הרשמה / התחברות')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.account_circle, size: 80, color: Colors.blueGrey),
            const SizedBox(height: 24),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'אימייל'),
              keyboardType: TextInputType.emailAddress,
              textDirection: TextDirection.ltr,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'סיסמה'),
              obscureText: true,
              textDirection: TextDirection.ltr,
            ),
            if (_isLogin)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: _resetPassword,
                  child: const Text('שכחתי סיסמה'),
                ),
              )
            else
              const SizedBox(height: 24),
            if (_isLoading)
              const CircularProgressIndicator()
            else ...[
              ElevatedButton(
                onPressed: _submitEmailAuth,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(_isLogin ? 'התחבר' : 'הרשם'),
              ),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(_isLogin ? 'אין לך חשבון? הרשם כאן' : 'יש לך חשבון? התחבר'),
              ),
              const Divider(height: 40),
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                icon: const Icon(Icons.g_mobiledata, size: 30),
                label: const Text('התחבר עם Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'בהרשמה אתה מסכים למדיניות הפרטיות ותנאי השימוש שלנו.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
