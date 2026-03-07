import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'main_screen.dart';
import 'onboarding_screen.dart';
import 'dashboard_screen.dart';
import '../services/permission_service.dart';

// Sanket: 2026 premium splash screen with hero image and brand overlay
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _contentController;
  late AnimationController _exitController;

  late Animation<double> _imageScale;
  late Animation<double> _overlayOpacity;
  late Animation<double> _contentOpacity;
  late Animation<Offset> _contentSlide;
  late Animation<double> _exitOpacity;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSequence();
  }

  void _setupAnimations() {
    // Sanket: Hero image zooms in slightly (Ken Burns effect)
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    _imageScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeInOut),
    );
    _overlayOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _heroController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    // Sanket: Brand content fades + slides up from bottom
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _contentOpacity = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeIn,
    ).drive(Tween<double>(begin: 0.0, end: 1.0));
    _contentSlide = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutCubic,
    ).drive(Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero));

    // Exit fade-out
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeIn),
    );
  }

  Future<void> _startSequence() async {
    // Start hero zoom immediately
    _heroController.forward();

    // Brand text appears after image loads
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) _contentController.forward();

    // Hold, then navigate
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) await _exitController.forward();
    if (mounted) _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('is_first_time') ?? true;

    if (!mounted) return;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await PermissionService.requestAllPermissions();

    int retryCount = 0;
    while (authProvider.isLoading && retryCount < 20) {
      await Future.delayed(const Duration(milliseconds: 200));
      retryCount++;
    }

    if (!mounted) return;

    if (authProvider.isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => isFirstTime ? const OnboardingScreen() : const LoginScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _heroController.dispose();
    _contentController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _exitOpacity,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F1A),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ── Hero image with subtle Ken Burns zoom ──────────────────
            AnimatedBuilder(
              animation: _imageScale,
              builder: (context, child) => Transform.scale(
                scale: _imageScale.value,
                child: child,
              ),
              child: Image.asset(
                'assets/splash_woman.jpg',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),

            // ── Multi-layer gradient overlay ───────────────────────────
            AnimatedBuilder(
              animation: _overlayOpacity,
              builder: (context, _) => Opacity(
                opacity: _overlayOpacity.value,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.35, 0.65, 1.0],
                      colors: [
                        Color(0x440F0F1A), // Very subtle top tint
                        Color(0x220F0F1A), // Transparent in middle
                        Color(0xCC0F0F1A), // Darkening from mid
                        Color(0xFF0F0F1A), // Solid at bottom for text contrast
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Bottom brand content panel ─────────────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SlideTransition(
                position: _contentSlide,
                child: FadeTransition(
                  opacity: _contentOpacity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 56),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Sanket: Brand pill badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F46E5).withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF4F46E5).withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            '✦  SWAYAMVAR MATRIMONY',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF818CF8),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Headline
                        Text(
                          'Your Leads.\nYour Revenue.',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Subtitle
                        Text(
                          'The complete telecalling CRM for modern matrimony agencies.',
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.55),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 36),

                        // Loading bar
                        _AnimatedLoadingBar(),
                        const SizedBox(height: 16),

                        // Version
                        Text(
                          'v2.0.26 · Secure & Encrypted',
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.25),
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Sanket: Animated indeterminate thin progress bar for loading state
class _AnimatedLoadingBar extends StatefulWidget {
  @override
  State<_AnimatedLoadingBar> createState() => _AnimatedLoadingBarState();
}

class _AnimatedLoadingBarState extends State<_AnimatedLoadingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))
      ..forward();
    _progress = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut)
        .drive(Tween<double>(begin: 0.0, end: 1.0));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progress,
      builder: (_, __) => ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: SizedBox(
          height: 2,
          child: LinearProgressIndicator(
            value: _progress.value,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            color: const Color(0xFF4F46E5),
          ),
        ),
      ),
    );
  }
}
// Sanket
