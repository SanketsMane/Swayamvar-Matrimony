import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'main_screen.dart';
import 'onboarding_screen.dart';

// Sanket — Complete rewrite from scratch. No video player dependency.
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animation controllers for multi-stage entry
  late AnimationController _logoController;
  late AnimationController _pulseController;
  late AnimationController _textController;
  late AnimationController _exitController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _pulseScale;
  late Animation<double> _textOpacity;
  late Animation<Offset> _taglineSlide;
  late Animation<double> _exitOpacity;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSequence();
  }

  void _setupAnimations() {
    // 1. Logo: Scale + Fade in
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = CurvedAnimation(parent: _logoController, curve: Curves.elasticOut)
        .drive(Tween<double>(begin: 0.3, end: 1.0));
    _logoOpacity = CurvedAnimation(parent: _logoController, curve: Curves.easeIn)
        .drive(Tween<double>(begin: 0.0, end: 1.0));

    // 2. Pulse ring: Expanding glow ring
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _pulseScale = CurvedAnimation(parent: _pulseController, curve: Curves.easeOut)
        .drive(Tween<double>(begin: 0.8, end: 1.5));

    // 3. Text: Fade in with slide up
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textOpacity = CurvedAnimation(parent: _textController, curve: Curves.easeIn)
        .drive(Tween<double>(begin: 0.0, end: 1.0));
    _taglineSlide = CurvedAnimation(parent: _textController, curve: Curves.easeOut)
        .drive(Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero));

    // 4. Exit: Fade out the entire screen
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _exitOpacity = CurvedAnimation(parent: _exitController, curve: Curves.easeIn)
        .drive(Tween<double>(begin: 1.0, end: 0.0));
  }

  Future<void> _startSequence() async {
    // Stage 1: Logo animates in
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();

    // Stage 2: Brand text slides up
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    // Stage 3: Pause, then navigate
    await Future.delayed(const Duration(milliseconds: 1800));
    await _exitController.forward();
    if (mounted) _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('is_first_time') ?? true;

    if (!mounted) return;

    if (isFirstTime) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    } else {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Sanket: Wait for AuthProvider to finish loading from SharedPreferences
      int timeout = 0;
      while (authProvider.isLoading && timeout < 20) { // Max 2 seconds wait
        await Future.delayed(const Duration(milliseconds: 100));
        timeout++;
      }

      if (authProvider.isAuthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();
    _textController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _exitOpacity,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0F),
        body: Stack(
          children: [
            // Background image fills entire screen
            Positioned.fill(
              child: Image.asset(
                'assets/splash_bg.png',
                fit: BoxFit.cover,
              ),
            ),

            // Subtle darkening vignette for depth
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.5,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.5),
                    ],
                  ),
                ),
              ),
            ),

            // Central Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Pulsing Ring + Logo Stack
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer pulse ring
                          Transform.scale(
                            scale: _pulseScale.value,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.swayamvarRed.withValues(alpha: 0.15),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),

                          // Subtle inner ring
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.swayamvarRed.withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                          ),

                          // Logo widget
                          child!,
                        ],
                      );
                    },
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: FadeTransition(
                        opacity: _logoOpacity,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.swayamvarRed.withValues(alpha: 0.2),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Brand Name + Tagline
                  SlideTransition(
                    position: _taglineSlide,
                    child: FadeTransition(
                      opacity: _textOpacity,
                      child: Column(
                        children: [

                          const SizedBox(height: 8),
                          Text(
                            'TELECALLING',
                            style: GoogleFonts.outfit(
                              color: AppColors.swayamvarRed,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Bottom version indicator
                  FadeTransition(
                    opacity: _textOpacity,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Text(
                        'v4.0.26',
                        style: GoogleFonts.outfit(
                          color: Colors.white.withValues(alpha: 0.15),
                          fontSize: 11,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Sanket
