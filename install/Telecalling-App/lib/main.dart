import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

import 'core/constants.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'services/notification_service.dart';
import 'services/offline_sync_service.dart';
import 'providers/theme_provider.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Offline Sync
  await offlineSyncService.initialize();
  
  // Initialize Firebase (Only if not web or if web options are provided later)
  try {
    if (!kIsWeb) {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } else {
      print("Firebase Web: Options required for initialization. Skipping for now.");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Firebase Initialization Error: $e");
    }
  }

  // Sanket: Screenshots are now restricted natively in MainActivity.kt


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const SwayamvarTelecallingApp(),
    ),
  );
}

class SwayamvarTelecallingApp extends StatefulWidget {
  const SwayamvarTelecallingApp({Key? key}) : super(key: key);

  @override
  State<SwayamvarTelecallingApp> createState() => _SwayamvarTelecallingAppState();
}

class _SwayamvarTelecallingAppState extends State<SwayamvarTelecallingApp> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _setupNotifications();
  }

  void _setupNotifications() async {
    // We delay this slightly so as not to block app boot
    Future.delayed(const Duration(seconds: 2), () {
      _notificationService.initialize();
    });

    // Handle foreground messages optionally (Only if not web or if initialized)
    if (!kIsWeb) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
         print('Got a message whilst in the foreground!');
         if (message.notification != null) {
            // Could show a local flutter toast/snackbar here
         }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background(context),
        primaryColor: AppColors.primary(context),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary(context),
          primary: AppColors.primary(context),
          secondary: AppColors.accent(context),
          surface: AppColors.surface(context),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.outfitTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black87),
          titleTextStyle: GoogleFonts.outfit(
            color: AppColors.textPrimary(context),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          color: AppColors.surface(context),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background(context),
        primaryColor: AppColors.primary(context),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary(context),
          primary: AppColors.primary(context),
          secondary: AppColors.accent(context),
          surface: AppColors.surface(context),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.outfit(
            color: AppColors.textPrimary(context),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          color: AppColors.surface(context),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
