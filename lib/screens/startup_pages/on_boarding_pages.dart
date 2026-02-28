import 'package:active_matrimonial_flutter_app/config/app_router.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/device_info.dart';
import 'package:active_matrimonial_flutter_app/helpers/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

class OnBoardingPages extends StatefulWidget {
  const OnBoardingPages({super.key});

  @override
  State<OnBoardingPages> createState() => _OnBoardingPagesState();
}

class _OnBoardingPagesState extends State<OnBoardingPages> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  List<Map<String, String>> _getPageList(BuildContext context) {
    return [
      {
        "image": "assets/images/onboarding_start.png",
        "title": AppLocalizations.of(context)!.onboarding_1_title,
        "subtitle": AppLocalizations.of(context)!.onboarding_1_subtitle,
        "alignment": "center",
      },
      {
        "image": "assets/images/onboarding_connect.png",
        "title": AppLocalizations.of(context)!.onboarding_2_title,
        "subtitle": AppLocalizations.of(context)!.onboarding_2_subtitle,
        "alignment": "center",
      },
      {
        "image": "assets/images/onboarding_interact.png",
        "title": AppLocalizations.of(context)!.onboarding_3_title,
        "subtitle": AppLocalizations.of(context)!.onboarding_3_subtitle,
        "alignment": "center",
      },
    ];
  }

  Alignment _getAlignment(String? align) {
    switch (align) {
      case 'topCenter':
        return Alignment.topCenter;
      case 'bottomCenter':
        return Alignment.bottomCenter;
      default:
        return Alignment.center;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageList = _getPageList(context);
    return Scaffold(
      body: Stack(
        children: [
          // 1. Full Screen Pages
          PageView.builder(
            controller: _pageController,
            itemCount: pageList.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      pageList[index]['image']!,
                      fit: BoxFit.cover,
                      alignment: _getAlignment(pageList[index]['alignment']),
                    ),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.8),
                        ],
                        stops: const [0.5, 0.7, 1.0],
                      ),
                    ),
                  ),

                  // Text Content (Bottom Aligned)
                  Positioned(
                    bottom: 120, // Leave space for buttons/indicators
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Animated Title (Horizontal Slide)
                        TweenAnimationBuilder<double>(
                          key: ValueKey(
                            'title_$index',
                          ), // Unique key for rebuild
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(-30 * (1 - value), 0),
                              child: Opacity(opacity: value, child: child),
                            );
                          },
                          child: Text(
                            pageList[index]['title']!,
                            style: Styles.h1.copyWith(
                              fontSize: 32,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Animated Subtitle (Vertical Slide)
                        TweenAnimationBuilder<double>(
                          key: ValueKey('subtitle_$index'),
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Opacity(opacity: value, child: child),
                            );
                          },
                          child: Text(
                            pageList[index]['subtitle']!,
                            style: Styles.body.copyWith(
                              fontSize: 16,
                              color: Colors.white70,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          // 2. Bottom Controls (Indicators & Button)
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Page Indicators (Dots)
                Row(
                  children: List.generate(
                    pageList.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 8),
                      height: 8,
                      width:
                          _currentIndex == index ? 24 : 8, // Expand active dot
                      decoration: BoxDecoration(
                        color:
                            _currentIndex == index
                                ? MyTheme.app_accent_color
                                : Colors.white38,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                // 'Next' or 'Get Started' Button
                GestureDetector(
                  onTap: () {
                    if (_currentIndex == pageList.length - 1) {
                      _finalizeOnboarding();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: MyTheme.app_accent_color,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: MyTheme.app_accent_color.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentIndex == pageList.length - 1
                              ? "Get Started"
                              : "Next",
                          style: Styles.buttonText.copyWith(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _currentIndex == pageList.length - 1
                              ? Icons.check
                              : Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Skip Button (Top Right)
          Positioned(
            top: 50,
            right: 24,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: pageList.length - 1 == _currentIndex ? 0.0 : 1.0,
              child: GestureDetector(
                onTap: () {
                  if (_currentIndex != pageList.length - 1) {
                    _finalizeOnboarding();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Skip",
                    style: Styles.buttonText.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _finalizeOnboarding() {
    SharedPref().isView = true;
    Navigator.pushReplacementNamed(context, AppRouter.login);
  }
}
