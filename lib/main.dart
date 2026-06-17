import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'services/supabase_service.dart';
import 'services/auth_service.dart';
import 'providers/timer_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/session_provider.dart';
import 'providers/counter_provider.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('he_IL', null);

  // Lock to portrait mode for a focused experience
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // ─── Initialize Services ───
  final storageService = StorageService();
  await storageService.init();

  final notificationService = NotificationService();
  await notificationService.init();

  final supabaseService = SupabaseService();
  await supabaseService.init(); // Supabase is now configured

  final authService = AuthService();

  // ─── Create Providers ───
  final settingsProvider = SettingsProvider(
    storage: storageService,
    notifications: notificationService,
  )..loadFromStorage();

  final sessionProvider = SessionProvider(
    storage: storageService,
    supabase: supabaseService,
  )..loadFromStorage();

  final counterProvider = CounterProvider(
    supabase: supabaseService,
  )..loadCount();

  // ─── Run App ───
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: sessionProvider),
        ChangeNotifierProvider.value(value: counterProvider),
      ],
      child: const DiburimApp(),
    ),
  );
}
