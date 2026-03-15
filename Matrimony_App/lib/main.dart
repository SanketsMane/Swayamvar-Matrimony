import 'dart:async';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:one_context/one_context.dart';

import 'package:active_matrimonial_flutter_app/config/app_router.dart';
import 'package:active_matrimonial_flutter_app/redux/store.dart';
import 'package:active_matrimonial_flutter_app/redux/store_init.dart';
import 'helpers/shared_pref.dart';

import 'package:active_matrimonial_flutter_app/providers/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:screen_protector/screen_protector.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      debugPrint("Sanket: Calling initStore()");
      initStore();
      debugPrint("Sanket: initStore() completed");

      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        debugPrint("Flutter Error: ${details.exception}");
      };

      // Firebase removed and replaced by Twilio backend flow
      await SharedPref().init();

      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ],
          child: const MyApp(),
        ),
      );
    },
    (error, stack) {
      debugPrint("❌ ZONED ERROR: $error");
      debugPrint("❌ STACK TRACE: $stack");
    },
  );
}

// redux store moved to lib/redux/store.dart

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initScreenProtection();
  }

  void _initScreenProtection() async {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return;
    }
    // Android: Protects against screenshots and screen recording (black screen)
    // iOS: Protects against screen recording and task switcher leaking
    try {
      await ScreenProtector.protectDataLeakageWithBlur();
      await ScreenProtector.protectDataLeakageOn();
      // iOS: Prevent screenshot (shows warning toast natively if possible)
      await ScreenProtector.preventScreenshotOn();
    } catch (e) {
      debugPrint("Sanket: ScreenProtector Init Error (Safe to ignore if non-mobile) -> $e");
    }
  }

  @override
  void dispose() {
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      ScreenProtector.protectDataLeakageOff();
      ScreenProtector.preventScreenshotOff();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            builder: OneContext().builder,
            navigatorKey: OneContext().navigator.key,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              fontFamily: "Noto Sans Devanagari",
              fontFamilyFallback: const [
                "Noto Sans",
                "Poppins",
                "Apple Color Emoji",
                "Segoe UI Emoji",
              ],
              appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
            ),
            debugShowCheckedModeBanner: false,
            title: 'Swayamvar Matrimoney',
            locale: languageProvider.appLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', ''), Locale('mr', '')],
            initialRoute: AppRouter.splash,
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
