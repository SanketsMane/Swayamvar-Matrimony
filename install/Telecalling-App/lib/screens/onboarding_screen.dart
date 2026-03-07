import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'WELCOME TO SWAYAMVAR',
      'description': 'Step into the future of telecalling. Your intelligent partner in lead management is here.',
      'image': 'assets/onboarding/onboard_1.jpg',
    },
    {
      'title': 'INTELLIGENT LEAD MGMT',
      'description': 'Organize, track, and close deals faster with our AI-driven CRM interface.',
      'image': 'assets/onboarding/onboard_2.jpg',
    },
    {
      'title': 'REAL-TIME ANALYTICS',
      'description': 'Stay ahead with deep insights into your performance and conversion metrics.',
      'image': 'assets/onboarding/onboard_3.jpg',
    },
    {
      'title': 'READY TO BEGIN?',
      'description': 'Join the elite force of telecallers. Your success story starts with a single tap.',
      'image': 'assets/onboarding/onboard_4.jpg',
    },
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_time', false);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _pages.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),
          
          Positioned(
            top: 60,
            right: 20,
            child: TextButton(
              onPressed: _completeOnboarding,
              child: Text(
                'SKIP',
                style: GoogleFonts.inter(
                  color: Colors.grey.withValues(alpha: 0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 60,
            left: 30,
            right: 30,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildDot(index == _currentPage),
                  ),
                ),
                const SizedBox(height: 48),
                _currentPage == _pages.length - 1
                    ? _buildGetStartedButton()
                    : _buildNextButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(Map<String, String> page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.bluePrimary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  page['image']!,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
          Text(
            page['title']!,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppColors.textPrimaryColor(context),
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            page['description']!,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppColors.textSecondaryColor(context),
              fontSize: 15,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 120), // Bottom spacing for buttons
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: isActive ? 24 : 6,
      decoration: BoxDecoration(
        color: isActive ? AppColors.bluePrimary : Colors.grey.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.bluePrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CONTINUE',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _completeOnboarding,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.bluePrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          'GET STARTED',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
// Sanket
