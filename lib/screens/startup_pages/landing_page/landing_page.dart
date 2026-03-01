import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/device_info.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/screens/app_navigation.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/startup_pages/landing_page/landing.dart';
import 'package:active_matrimonial_flutter_app/screens/startup_pages/on_boarding_pages.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

import '../../../helpers/shared_pref.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // Force refresh
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) => [store.dispatch(fetchLandingSliderAction())],
      builder:
          (_, state) => Scaffold(
            body: SizedBox(
              height: DeviceInfo(context).height,
              child: Stack(
                children: [
                  SizedBox(
                    height: DeviceInfo(context).height! * .70,
                    child: Image.asset(
                      'assets/images/landing_image.jpeg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  // upper most container
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(32),
                          topLeft: Radius.circular(32),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        child: SafeArea(
                          top: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.landing_page_title,
                                style: Styles.bold_arsenic_30,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.landing_page_sub_title,
                                style: Styles.medium_gull_grey_14,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        SharedPref().isView = true;
                                        NavigatorPush.push(
                                          context,
                                          const AppNavigation(),
                                        );
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          gradient: Styles.buildLinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: MyTheme.app_accent_color
                                                  .withOpacity(0.3),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.common_get_started,
                                          style: Styles.bold_white_14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        NavigatorPush.push(
                                          context,
                                          const OnBoardingPages(),
                                        );
                                      },
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.landing_page_how_it_works,
                                        style: Styles.bold_app_accent_14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
