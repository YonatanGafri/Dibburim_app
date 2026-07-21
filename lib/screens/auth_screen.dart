import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  bool _isLogin = true;
  bool _acceptedPrivacyPolicy = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submitEmailAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) return;

    if (!_isLogin && !_acceptedPrivacyPolicy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('עליך לאשר את מדיניות הפרטיות ותנאי השימוש')),
      );
      return;
    }

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
        String errorMsg = e.toString();
        if (_isLogin && (errorMsg.contains('Invalid login credentials') || errorMsg.contains('invalid_credentials'))) {
          errorMsg = 'המייל אינו רשום במערכת או שהסיסמה שגויה.';
        } else {
          errorMsg = 'שגיאה: $errorMsg';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    if (!_isLogin && !_acceptedPrivacyPolicy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('עליך לאשר את מדיניות הפרטיות ותנאי השימוש')),
      );
      return;
    }

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

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('מדיניות פרטיות', textAlign: TextAlign.right),
        content: const SingleChildScrollView(
          child: Text(
            'אפליקציית "דיבורים" מכבדת את פרטיותך.\n\n'
            '• פרטי התחברות: נשמרים כתובת המייל, השם, ותמונת הפרופיל במקרה של התחברות מגוגל.\n'
            '• נתוני שימוש: אנו שומרים את זמני ותאריכי ההתבודדות בלבד כדי לאפשר סנכרון בין מכשירים.\n\n'
            'המידע אינו מועבר לצד שלישי ואינו משמש לפרסום.\n\n'
            'ניתן למחוק את החשבון ואת כל הנתונים דרך מסך ההגדרות באפליקציה, או בפנייה ל: info@dibburim.com\n',
            textDirection: TextDirection.rtl,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('סגור'),
          ),
        ],
      ),
    );
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
                label: Text(_isLogin ? 'התחבר עם Google' : 'הרשם עם Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 24),
              if (!_isLogin)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _acceptedPrivacyPolicy,
                      onChanged: (val) {
                        setState(() {
                          _acceptedPrivacyPolicy = val ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: _showPrivacyPolicyDialog,
                        child: const Text(
                          'אני מסכים למדיניות הפרטיות ותנאי השימוש',
                          style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                GestureDetector(
                  onTap: _showPrivacyPolicyDialog,
                  child: const Text(
                    'מדיניות פרטיות ותנאי שימוש',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      color: Colors.grey,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
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
            ],
          ],
        ),
      ),
    );
  }
}
