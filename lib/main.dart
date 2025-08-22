import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

import 'utils/app_theme.dart';
import 'utils/localization.dart';
import 'providers/locale_provider.dart';
import 'widgets/app_wrapper.dart';
import 'services/firebase_initializer.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with proper options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Auto-setup Firebase data (collections, sample data)
  await FirebaseInitializer.initializeFirebaseData();
  
  // Initialize Notification Service (commented out for now)
  // await NotificationService.initialize();
  
  runApp(
    const ProviderScope(
      child: LocalExpressApp(),
    ),
  );
}

class LocalExpressApp extends ConsumerWidget {
  const LocalExpressApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    
    return MaterialApp(
      title: 'Local Express - Delivery App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('ur', 'PK'), // Urdu
      ],
      home: const AppWrapper(),
    );
  }
}
