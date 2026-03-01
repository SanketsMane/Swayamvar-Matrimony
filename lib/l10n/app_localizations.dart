import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('mr'),
  ];

  /// No description provided for @common_enter_email.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Email'**
  String get common_enter_email;

  /// No description provided for @common_enter_password.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Password'**
  String get common_enter_password;

  /// No description provided for @common_screen_8_or_more_char.
  ///
  /// In en, this message translates to:
  /// **'Use 8 or more character'**
  String get common_screen_8_or_more_char;

  /// No description provided for @common_screen_confim_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get common_screen_confim_password;

  /// No description provided for @common_email_or_phone.
  ///
  /// In en, this message translates to:
  /// **'Email or Phone'**
  String get common_email_or_phone;

  /// No description provided for @common_password_text.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get common_password_text;

  /// No description provided for @common_active_members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get common_active_members;

  /// No description provided for @common_active_explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get common_active_explore;

  /// No description provided for @common_active_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get common_active_account;

  /// No description provided for @common_active_chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get common_active_chat;

  /// No description provided for @common_get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get common_get_started;

  /// No description provided for @common_screen_member_id.
  ///
  /// In en, this message translates to:
  /// **'Member ID: '**
  String get common_screen_member_id;

  /// No description provided for @common_success_msg.
  ///
  /// In en, this message translates to:
  /// **'Applied Successfully'**
  String get common_success_msg;

  /// No description provided for @common_screen_blogs.
  ///
  /// In en, this message translates to:
  /// **'Blogs'**
  String get common_screen_blogs;

  /// No description provided for @explore_best_matches.
  ///
  /// In en, this message translates to:
  /// **'Best Matches'**
  String get explore_best_matches;

  /// No description provided for @explore_recently_active.
  ///
  /// In en, this message translates to:
  /// **'Recently Active'**
  String get explore_recently_active;

  /// No description provided for @explore_new_members.
  ///
  /// In en, this message translates to:
  /// **'New Members'**
  String get explore_new_members;

  /// No description provided for @explore_verified_profiles.
  ///
  /// In en, this message translates to:
  /// **'Verified Profiles'**
  String get explore_verified_profiles;

  /// No description provided for @explore_see_all.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get explore_see_all;

  /// No description provided for @filter_marital_status.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get filter_marital_status;

  /// No description provided for @filter_religion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get filter_religion;

  /// No description provided for @filter_caste.
  ///
  /// In en, this message translates to:
  /// **'Caste'**
  String get filter_caste;

  /// No description provided for @filter_city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get filter_city;

  /// No description provided for @filter_education.
  ///
  /// In en, this message translates to:
  /// **'Education Level'**
  String get filter_education;

  /// No description provided for @filter_income.
  ///
  /// In en, this message translates to:
  /// **'Annual Income'**
  String get filter_income;

  /// No description provided for @filter_age_range.
  ///
  /// In en, this message translates to:
  /// **'Age Range'**
  String get filter_age_range;

  /// No description provided for @filter_height_range.
  ///
  /// In en, this message translates to:
  /// **'Height Range'**
  String get filter_height_range;

  /// No description provided for @filter_manglik.
  ///
  /// In en, this message translates to:
  /// **'Manglik Only'**
  String get filter_manglik;

  /// No description provided for @filter_intercaste.
  ///
  /// In en, this message translates to:
  /// **'Intercaste Accepted'**
  String get filter_intercaste;

  /// No description provided for @filter_disability.
  ///
  /// In en, this message translates to:
  /// **'Physical Disability'**
  String get filter_disability;

  /// No description provided for @filter_apply.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get filter_apply;

  /// No description provided for @filter_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get filter_reset;

  /// No description provided for @filter_select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get filter_select;

  /// No description provided for @common_screen_use_email.
  ///
  /// In en, this message translates to:
  /// **'Use email instead'**
  String get common_screen_use_email;

  /// No description provided for @common_screen_use_phone.
  ///
  /// In en, this message translates to:
  /// **'Use phone instead'**
  String get common_screen_use_phone;

  /// No description provided for @common_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get common_confirm;

  /// No description provided for @common_purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get common_purchase;

  /// No description provided for @common_login_first.
  ///
  /// In en, this message translates to:
  /// **'Please Login First'**
  String get common_login_first;

  /// No description provided for @common_no_data.
  ///
  /// In en, this message translates to:
  /// **'No Data Found'**
  String get common_no_data;

  /// No description provided for @common_report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get common_report;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_report_reason.
  ///
  /// In en, this message translates to:
  /// **'Report Reason *'**
  String get common_report_reason;

  /// No description provided for @common_report_member.
  ///
  /// In en, this message translates to:
  /// **'Report Member'**
  String get common_report_member;

  /// No description provided for @common_shortlist.
  ///
  /// In en, this message translates to:
  /// **'Shortlist'**
  String get common_shortlist;

  /// No description provided for @common_shortlisted.
  ///
  /// In en, this message translates to:
  /// **'Shortlisted'**
  String get common_shortlisted;

  /// No description provided for @public_profile.
  ///
  /// In en, this message translates to:
  /// **'Matched '**
  String get public_profile;

  /// No description provided for @home_screen_full_profile.
  ///
  /// In en, this message translates to:
  /// **'Full Profile'**
  String get home_screen_full_profile;

  /// No description provided for @view_more.
  ///
  /// In en, this message translates to:
  /// **'View more'**
  String get view_more;

  /// No description provided for @checkout_screen_checkout.
  ///
  /// In en, this message translates to:
  /// **'CHECKOUT'**
  String get checkout_screen_checkout;

  /// No description provided for @login_screen_email_helper_text.
  ///
  /// In en, this message translates to:
  /// **'Use country code before number'**
  String get login_screen_email_helper_text;

  /// No description provided for @login_text_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Enter your login credentials'**
  String get login_text_sub_title;

  /// No description provided for @login_screen_if_have_account.
  ///
  /// In en, this message translates to:
  /// **'Do not have an account?'**
  String get login_screen_if_have_account;

  /// No description provided for @login_text_title.
  ///
  /// In en, this message translates to:
  /// **'Login to your account'**
  String get login_text_title;

  /// No description provided for @login_screen_forget_password.
  ///
  /// In en, this message translates to:
  /// **'Forget Password ?'**
  String get login_screen_forget_password;

  /// No description provided for @login_screen_or_signup.
  ///
  /// In en, this message translates to:
  /// **'or, Login with'**
  String get login_screen_or_signup;

  /// No description provided for @login_screen_signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get login_screen_signup;

  /// No description provided for @login_button_text.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_button_text;

  /// No description provided for @forget_screen_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address or phone number\n to recover your password'**
  String get forget_screen_subtitle;

  /// No description provided for @forget_screen_use_email_instead.
  ///
  /// In en, this message translates to:
  /// **'Use Email instead'**
  String get forget_screen_use_email_instead;

  /// No description provided for @forget_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Forget Password!'**
  String get forget_screen_title;

  /// No description provided for @forget_screen_or_back_to.
  ///
  /// In en, this message translates to:
  /// **'Or, back to'**
  String get forget_screen_or_back_to;

  /// No description provided for @forget_screen_send_code.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get forget_screen_send_code;

  /// No description provided for @forget_screen_login.
  ///
  /// In en, this message translates to:
  /// **'login'**
  String get forget_screen_login;

  /// No description provided for @signup_screen_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill out the form to get started'**
  String get signup_screen_subtitle;

  /// No description provided for @signup_screen_already_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account'**
  String get signup_screen_already_account;

  /// No description provided for @signup_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get signup_screen_title;

  /// No description provided for @signup_screen_use_phone_instead.
  ///
  /// In en, this message translates to:
  /// **'Use phone instead'**
  String get signup_screen_use_phone_instead;

  /// No description provided for @signup_screen_join_with.
  ///
  /// In en, this message translates to:
  /// **'or, join with'**
  String get signup_screen_join_with;

  /// No description provided for @signup_screen_dob.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get signup_screen_dob;

  /// No description provided for @signup_screen_first_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get signup_screen_first_name;

  /// No description provided for @signup_screen_last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get signup_screen_last_name;

  /// No description provided for @signup_screen_onbehalf.
  ///
  /// In en, this message translates to:
  /// **'On behalf'**
  String get signup_screen_onbehalf;

  /// No description provided for @signup_screen_button_text_signup.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signup_screen_button_text_signup;

  /// No description provided for @signup_screen_gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get signup_screen_gender;

  /// No description provided for @signup_screen_login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get signup_screen_login;

  /// No description provided for @signup_screen_terms_part2.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions '**
  String get signup_screen_terms_part2;

  /// No description provided for @signup_screen_terms_part1.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get signup_screen_terms_part1;

  /// No description provided for @signup_screen_terms_part4.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy '**
  String get signup_screen_terms_part4;

  /// No description provided for @signup_screen_terms_part3.
  ///
  /// In en, this message translates to:
  /// **'& '**
  String get signup_screen_terms_part3;

  /// No description provided for @signup_screen_refer_code.
  ///
  /// In en, this message translates to:
  /// **'Refer Code'**
  String get signup_screen_refer_code;

  /// No description provided for @new_password_screen_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get new_password_screen_subtitle;

  /// No description provided for @new_password_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Create new password'**
  String get new_password_screen_title;

  /// No description provided for @verify_screen_btn_text.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify_screen_btn_text;

  /// No description provided for @verify_now.
  ///
  /// In en, this message translates to:
  /// **'Verify Now'**
  String get verify_now;

  /// No description provided for @not_verified.
  ///
  /// In en, this message translates to:
  /// **'Not Verified'**
  String get not_verified;

  /// No description provided for @verify_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verify_screen_title;

  /// No description provided for @verify_screen_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Enter the code we send you'**
  String get verify_screen_sub_title;

  /// No description provided for @search_screen_title.
  ///
  /// In en, this message translates to:
  /// **'SEARCH'**
  String get search_screen_title;

  /// No description provided for @show_search.
  ///
  /// In en, this message translates to:
  /// **'All ACTIVE MEMBERS'**
  String get show_search;

  /// No description provided for @search_secreen_age_from.
  ///
  /// In en, this message translates to:
  /// **'Age from'**
  String get search_secreen_age_from;

  /// No description provided for @search_screen_to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get search_screen_to;

  /// No description provided for @search_screen_religion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get search_screen_religion;

  /// No description provided for @search_screen_mother_tongue.
  ///
  /// In en, this message translates to:
  /// **'Mother Tongue'**
  String get search_screen_mother_tongue;

  /// No description provided for @advanced_search_secreen_age_from.
  ///
  /// In en, this message translates to:
  /// **'Age from'**
  String get advanced_search_secreen_age_from;

  /// No description provided for @advanced_search_screen_to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get advanced_search_screen_to;

  /// No description provided for @advanced_search_screen_marital_status.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get advanced_search_screen_marital_status;

  /// No description provided for @advanced_search_screen_caste.
  ///
  /// In en, this message translates to:
  /// **'Caste'**
  String get advanced_search_screen_caste;

  /// No description provided for @advanced_search_screen_sub_caste.
  ///
  /// In en, this message translates to:
  /// **'Sub Caste'**
  String get advanced_search_screen_sub_caste;

  /// No description provided for @advanced_search_screen_profession.
  ///
  /// In en, this message translates to:
  /// **'Profession'**
  String get advanced_search_screen_profession;

  /// No description provided for @advanced_search_screen_country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get advanced_search_screen_country;

  /// No description provided for @advanced_search_screen_state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get advanced_search_screen_state;

  /// No description provided for @advanced_search_screen_city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get advanced_search_screen_city;

  /// No description provided for @advanced_search_screen_min_height.
  ///
  /// In en, this message translates to:
  /// **'Min Height'**
  String get advanced_search_screen_min_height;

  /// No description provided for @advanced_search_screen_max_height.
  ///
  /// In en, this message translates to:
  /// **'Max Height'**
  String get advanced_search_screen_max_height;

  /// No description provided for @advanced_search_screen_member_type.
  ///
  /// In en, this message translates to:
  /// **'Member Type'**
  String get advanced_search_screen_member_type;

  /// No description provided for @advanced_search_screen_btn_text.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get advanced_search_screen_btn_text;

  /// No description provided for @advanced_search_screen_premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get advanced_search_screen_premium;

  /// No description provided for @advanced_search_screen_free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get advanced_search_screen_free;

  /// No description provided for @advanced_search_screen_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get advanced_search_screen_all;

  /// No description provided for @common_advanced_search_switch.
  ///
  /// In en, this message translates to:
  /// **'Switch to Advanced Search'**
  String get common_advanced_search_switch;

  /// No description provided for @common_basic_search_switch.
  ///
  /// In en, this message translates to:
  /// **'Switch to Basic Search'**
  String get common_basic_search_switch;

  /// No description provided for @profile_screen_public_profile.
  ///
  /// In en, this message translates to:
  /// **'Public Profile'**
  String get profile_screen_public_profile;

  /// No description provided for @profile_screen_manage_profile.
  ///
  /// In en, this message translates to:
  /// **'Manage Profile'**
  String get profile_screen_manage_profile;

  /// No description provided for @profile_screen_gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get profile_screen_gallery;

  /// No description provided for @profile_screen_r_interest.
  ///
  /// In en, this message translates to:
  /// **'Remaining Interest'**
  String get profile_screen_r_interest;

  /// No description provided for @profile_screen_r_contact_view.
  ///
  /// In en, this message translates to:
  /// **'Remaining Contact View'**
  String get profile_screen_r_contact_view;

  /// No description provided for @profile_screen_r_gallery_image_upload.
  ///
  /// In en, this message translates to:
  /// **'Remaining Gallery Image'**
  String get profile_screen_r_gallery_image_upload;

  /// No description provided for @profile_screen_r_profile_image_view.
  ///
  /// In en, this message translates to:
  /// **'Remaining Profile \nImage View'**
  String get profile_screen_r_profile_image_view;

  /// No description provided for @profile_screen_r_gallery_image_view.
  ///
  /// In en, this message translates to:
  /// **'Remaining Gallery \nImage View'**
  String get profile_screen_r_gallery_image_view;

  /// No description provided for @profile_screen_my_wallet.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get profile_screen_my_wallet;

  /// No description provided for @profile_screen_messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get profile_screen_messages;

  /// No description provided for @profile_screen_profile_match.
  ///
  /// In en, this message translates to:
  /// **'Profile Match'**
  String get profile_screen_profile_match;

  /// No description provided for @profile_screen_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profile_screen_notifications;

  /// No description provided for @profile_screen_my_interest.
  ///
  /// In en, this message translates to:
  /// **'My Interest'**
  String get profile_screen_my_interest;

  /// No description provided for @profile_screen_ignore_users.
  ///
  /// In en, this message translates to:
  /// **'Ignore users'**
  String get profile_screen_ignore_users;

  /// No description provided for @profile_screen_happy_stories.
  ///
  /// In en, this message translates to:
  /// **'Happy Story'**
  String get profile_screen_happy_stories;

  /// No description provided for @profile_screen_support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get profile_screen_support;

  /// No description provided for @profile_screen_package.
  ///
  /// In en, this message translates to:
  /// **'Package '**
  String get profile_screen_package;

  /// No description provided for @profile_screen_upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Package'**
  String get profile_screen_upgrade;

  /// No description provided for @profile_screen_expire_on.
  ///
  /// In en, this message translates to:
  /// **'Expire on: '**
  String get profile_screen_expire_on;

  /// No description provided for @profile_screen_package_details.
  ///
  /// In en, this message translates to:
  /// **'Package Details'**
  String get profile_screen_package_details;

  /// No description provided for @profile_screen_package_history.
  ///
  /// In en, this message translates to:
  /// **'Package Purchase History'**
  String get profile_screen_package_history;

  /// No description provided for @referral_user.
  ///
  /// In en, this message translates to:
  /// **'Referral User'**
  String get referral_user;

  /// No description provided for @referral_earnings.
  ///
  /// In en, this message translates to:
  /// **'Referral Ear...'**
  String get referral_earnings;

  /// No description provided for @referral_wallet.
  ///
  /// In en, this message translates to:
  /// **'Referral Wa...'**
  String get referral_wallet;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @deactivate_account.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Account'**
  String get deactivate_account;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @howitworks_screen_1.
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get howitworks_screen_1;

  /// No description provided for @howitworks_screen_1_signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get howitworks_screen_1_signup;

  /// No description provided for @howitworks_screen_1_reg_for_free.
  ///
  /// In en, this message translates to:
  /// **'Register for free & put up\n your Profile'**
  String get howitworks_screen_1_reg_for_free;

  /// No description provided for @howitworks_screen_2.
  ///
  /// In en, this message translates to:
  /// **'2'**
  String get howitworks_screen_2;

  /// No description provided for @howitworks_screen_2_connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get howitworks_screen_2_connect;

  /// No description provided for @howitworks_screen_2_select_and_connect.
  ///
  /// In en, this message translates to:
  /// **'Select & Connect with\n Matches you like'**
  String get howitworks_screen_2_select_and_connect;

  /// No description provided for @howitworks_screen_3.
  ///
  /// In en, this message translates to:
  /// **'3'**
  String get howitworks_screen_3;

  /// No description provided for @howitworks_screen_3_interact.
  ///
  /// In en, this message translates to:
  /// **'Interact'**
  String get howitworks_screen_3_interact;

  /// No description provided for @howitworks_screen_3_become_premium.
  ///
  /// In en, this message translates to:
  /// **'Become a Premium Member &\n Start a Conversation'**
  String get howitworks_screen_3_become_premium;

  /// No description provided for @howitworks_screen_3_or_continue_as_guest.
  ///
  /// In en, this message translates to:
  /// **'or, Continue as guest ?'**
  String get howitworks_screen_3_or_continue_as_guest;

  /// No description provided for @landing_page_title.
  ///
  /// In en, this message translates to:
  /// **'Find Your\nLife Partner With Us'**
  String get landing_page_title;

  /// No description provided for @landing_page_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Trusted Matrimony Services\nto happy marriages.'**
  String get landing_page_sub_title;

  /// No description provided for @landing_page_how_it_works.
  ///
  /// In en, this message translates to:
  /// **'How it works ?'**
  String get landing_page_how_it_works;

  /// No description provided for @home_9_premium_members.
  ///
  /// In en, this message translates to:
  /// **'Premium Members'**
  String get home_9_premium_members;

  /// No description provided for @home_9_trusted_by_users.
  ///
  /// In en, this message translates to:
  /// **'Trusted by millions'**
  String get home_9_trusted_by_users;

  /// No description provided for @home_9_premium_trusted_by.
  ///
  /// In en, this message translates to:
  /// **'Trusted By Users'**
  String get home_9_premium_trusted_by;

  /// No description provided for @home_9_new_members.
  ///
  /// In en, this message translates to:
  /// **'New Members'**
  String get home_9_new_members;

  /// No description provided for @home_9_happy_stories.
  ///
  /// In en, this message translates to:
  /// **'Happy Stories'**
  String get home_9_happy_stories;

  /// No description provided for @home_9_packages.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get home_9_packages;

  /// No description provided for @home_9_real_reviews.
  ///
  /// In en, this message translates to:
  /// **'Real Reviews'**
  String get home_9_real_reviews;

  /// No description provided for @home_9_blog_section.
  ///
  /// In en, this message translates to:
  /// **'Blog Section'**
  String get home_9_blog_section;

  /// No description provided for @home_9_best_matches.
  ///
  /// In en, this message translates to:
  /// **'Best Matches'**
  String get home_9_best_matches;

  /// No description provided for @home_9_verified_profile.
  ///
  /// In en, this message translates to:
  /// **'Verified Profile'**
  String get home_9_verified_profile;

  /// No description provided for @home_9_100_privacy.
  ///
  /// In en, this message translates to:
  /// **'100 Privacy'**
  String get home_9_100_privacy;

  /// No description provided for @chat_list_matched_profile.
  ///
  /// In en, this message translates to:
  /// **'Matched Profile'**
  String get chat_list_matched_profile;

  /// No description provided for @chat_list_messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get chat_list_messages;

  /// No description provided for @manage_profile.
  ///
  /// In en, this message translates to:
  /// **'Manage Profile'**
  String get manage_profile;

  /// No description provided for @manage_profile_introduction.
  ///
  /// In en, this message translates to:
  /// **'Personal Introduction'**
  String get manage_profile_introduction;

  /// No description provided for @manage_profile_contact_number.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get manage_profile_contact_number;

  /// No description provided for @manage_profile_your_contact_details.
  ///
  /// In en, this message translates to:
  /// **'Change your email'**
  String get manage_profile_your_contact_details;

  /// No description provided for @manage_profile_your_email_id.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get manage_profile_your_email_id;

  /// No description provided for @manage_profile_basic_info.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get manage_profile_basic_info;

  /// No description provided for @manage_profile_your_address.
  ///
  /// In en, this message translates to:
  /// **'Your Address'**
  String get manage_profile_your_address;

  /// No description provided for @manage_profile_education_Info.
  ///
  /// In en, this message translates to:
  /// **'Education Info'**
  String get manage_profile_education_Info;

  /// No description provided for @manage_profile_Career.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get manage_profile_Career;

  /// No description provided for @manage_profile_career_info.
  ///
  /// In en, this message translates to:
  /// **'Career Info'**
  String get manage_profile_career_info;

  /// No description provided for @manage_profile_career_title.
  ///
  /// In en, this message translates to:
  /// **'Your Career info'**
  String get manage_profile_career_title;

  /// No description provided for @manage_profile_present_address.
  ///
  /// In en, this message translates to:
  /// **'Present Address'**
  String get manage_profile_present_address;

  /// No description provided for @manage_profile_Residency_Info.
  ///
  /// In en, this message translates to:
  /// **'Residency Information'**
  String get manage_profile_Residency_Info;

  /// No description provided for @manage_profile_spiritual_n_social_back.
  ///
  /// In en, this message translates to:
  /// **'Spiritiual & Social Background'**
  String get manage_profile_spiritual_n_social_back;

  /// No description provided for @manage_profile_f_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get manage_profile_f_name;

  /// No description provided for @manage_profile_l_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get manage_profile_l_name;

  /// No description provided for @manage_profile_gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get manage_profile_gender;

  /// No description provided for @manage_profile_dob.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get manage_profile_dob;

  /// No description provided for @manage_profile_phone_num.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get manage_profile_phone_num;

  /// No description provided for @manage_profile_onbehalf.
  ///
  /// In en, this message translates to:
  /// **'On Behalf'**
  String get manage_profile_onbehalf;

  /// No description provided for @manage_profile_marital_status.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get manage_profile_marital_status;

  /// No description provided for @manage_profile_number_of_child.
  ///
  /// In en, this message translates to:
  /// **'Number of Children'**
  String get manage_profile_number_of_child;

  /// No description provided for @manage_profile_photo.
  ///
  /// In en, this message translates to:
  /// **'Photo (800x800)'**
  String get manage_profile_photo;

  /// No description provided for @change_password_screen_old_pass.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get change_password_screen_old_pass;

  /// No description provided for @change_password_screen_new_pass.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get change_password_screen_new_pass;

  /// No description provided for @change_password_screen_confirm_pass.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get change_password_screen_confirm_pass;

  /// No description provided for @manage_profile_city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get manage_profile_city;

  /// No description provided for @manage_profile_degree.
  ///
  /// In en, this message translates to:
  /// **'Degree'**
  String get manage_profile_degree;

  /// No description provided for @manage_profile_institution.
  ///
  /// In en, this message translates to:
  /// **'Institution'**
  String get manage_profile_institution;

  /// No description provided for @manage_profile_start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get manage_profile_start;

  /// No description provided for @manage_profile_end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get manage_profile_end;

  /// No description provided for @manage_profile_designation.
  ///
  /// In en, this message translates to:
  /// **'Designation'**
  String get manage_profile_designation;

  /// No description provided for @manage_profile_company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get manage_profile_company;

  /// No description provided for @manage_profile_height.
  ///
  /// In en, this message translates to:
  /// **'Height (In Feet)'**
  String get manage_profile_height;

  /// No description provided for @manage_profile_weight.
  ///
  /// In en, this message translates to:
  /// **'Weight (In Kg)'**
  String get manage_profile_weight;

  /// No description provided for @manage_profile_eye_color.
  ///
  /// In en, this message translates to:
  /// **'Eye Color'**
  String get manage_profile_eye_color;

  /// No description provided for @manage_profile_hair_color.
  ///
  /// In en, this message translates to:
  /// **'Hair Color'**
  String get manage_profile_hair_color;

  /// No description provided for @manage_profile_blood_group.
  ///
  /// In en, this message translates to:
  /// **'Blood Group'**
  String get manage_profile_blood_group;

  /// No description provided for @manage_profile_body_type.
  ///
  /// In en, this message translates to:
  /// **'Body Type'**
  String get manage_profile_body_type;

  /// No description provided for @manage_profile_body_art.
  ///
  /// In en, this message translates to:
  /// **'Body Art'**
  String get manage_profile_body_art;

  /// No description provided for @manage_profile_disability.
  ///
  /// In en, this message translates to:
  /// **'Disability'**
  String get manage_profile_disability;

  /// No description provided for @manage_profile_mother_tongue.
  ///
  /// In en, this message translates to:
  /// **'Mother Tongue'**
  String get manage_profile_mother_tongue;

  /// No description provided for @manage_profile_country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get manage_profile_country;

  /// No description provided for @manage_profile_state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get manage_profile_state;

  /// No description provided for @manage_profile_postal_code.
  ///
  /// In en, this message translates to:
  /// **'Postal code'**
  String get manage_profile_postal_code;

  /// No description provided for @manage_profile_father.
  ///
  /// In en, this message translates to:
  /// **'Father'**
  String get manage_profile_father;

  /// No description provided for @manage_profile_mother.
  ///
  /// In en, this message translates to:
  /// **'Mother'**
  String get manage_profile_mother;

  /// No description provided for @manage_profile_sibling.
  ///
  /// In en, this message translates to:
  /// **'Sibling'**
  String get manage_profile_sibling;

  /// No description provided for @happy_story.
  ///
  /// In en, this message translates to:
  /// **'Happy Stories'**
  String get happy_story;

  /// No description provided for @happy_stories_posted_by.
  ///
  /// In en, this message translates to:
  /// **'Posted By :'**
  String get happy_stories_posted_by;

  /// No description provided for @happy_stories_on.
  ///
  /// In en, this message translates to:
  /// **'On:'**
  String get happy_stories_on;

  /// No description provided for @notifications_page_title.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS'**
  String get notifications_page_title;

  /// No description provided for @my_profile_detailed_profile.
  ///
  /// In en, this message translates to:
  /// **'Detailed Profile'**
  String get my_profile_detailed_profile;

  /// No description provided for @my_profile_partner_preference.
  ///
  /// In en, this message translates to:
  /// **'Partner Preference'**
  String get my_profile_partner_preference;

  /// No description provided for @my_profile_gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get my_profile_gallery;

  /// No description provided for @my_profile_report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get my_profile_report;

  /// No description provided for @my_profile_reported.
  ///
  /// In en, this message translates to:
  /// **'Reported'**
  String get my_profile_reported;

  /// No description provided for @my_profile_ignore_user.
  ///
  /// In en, this message translates to:
  /// **'Ignore'**
  String get my_profile_ignore_user;

  /// No description provided for @public_profile_about_user.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get public_profile_about_user;

  /// No description provided for @public_profile_basic_info.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get public_profile_basic_info;

  /// No description provided for @public_profile_contact_details.
  ///
  /// In en, this message translates to:
  /// **'Change your email'**
  String get public_profile_contact_details;

  /// No description provided for @public_profile_edu_details.
  ///
  /// In en, this message translates to:
  /// **'Education Details'**
  String get public_profile_edu_details;

  /// No description provided for @public_profile_physical_attri.
  ///
  /// In en, this message translates to:
  /// **'Physical Attributes'**
  String get public_profile_physical_attri;

  /// No description provided for @public_profile_Lang.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get public_profile_Lang;

  /// No description provided for @public_profile_your_lang.
  ///
  /// In en, this message translates to:
  /// **'Your Language'**
  String get public_profile_your_lang;

  /// No description provided for @public_profile_mother_tounge.
  ///
  /// In en, this message translates to:
  /// **'Mother Tongue'**
  String get public_profile_mother_tounge;

  /// No description provided for @public_profile_hobbies_n_interest.
  ///
  /// In en, this message translates to:
  /// **'Hobbies & Interest'**
  String get public_profile_hobbies_n_interest;

  /// No description provided for @public_profile_your_hobbies_n_interest.
  ///
  /// In en, this message translates to:
  /// **'Your Hobbies & Interest'**
  String get public_profile_your_hobbies_n_interest;

  /// No description provided for @manage_profile_hobbies.
  ///
  /// In en, this message translates to:
  /// **'Hobbies'**
  String get manage_profile_hobbies;

  /// No description provided for @manage_profile_interests.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get manage_profile_interests;

  /// No description provided for @manage_profile_music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get manage_profile_music;

  /// No description provided for @manage_profile_books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get manage_profile_books;

  /// No description provided for @manage_profile_movies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get manage_profile_movies;

  /// No description provided for @manage_profile_tv_shows.
  ///
  /// In en, this message translates to:
  /// **'TV Shows'**
  String get manage_profile_tv_shows;

  /// No description provided for @manage_profile_sports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get manage_profile_sports;

  /// No description provided for @manage_profile_fitness_activities.
  ///
  /// In en, this message translates to:
  /// **'Fitness Activities'**
  String get manage_profile_fitness_activities;

  /// No description provided for @manage_profile_cuisines.
  ///
  /// In en, this message translates to:
  /// **'Cuisines'**
  String get manage_profile_cuisines;

  /// No description provided for @manage_profile_dress_styles.
  ///
  /// In en, this message translates to:
  /// **'Dress Styles'**
  String get manage_profile_dress_styles;

  /// No description provided for @public_profile_personal_attri_behavior.
  ///
  /// In en, this message translates to:
  /// **'Personal Attitude & Behaviour'**
  String get public_profile_personal_attri_behavior;

  /// No description provided for @public_profile_your_personal_attri_behavior.
  ///
  /// In en, this message translates to:
  /// **'Your Personal Attitude & Behaviour'**
  String get public_profile_your_personal_attri_behavior;

  /// No description provided for @public_profile_residency_info.
  ///
  /// In en, this message translates to:
  /// **'Residency Information'**
  String get public_profile_residency_info;

  /// No description provided for @public_profile_your_residency_info.
  ///
  /// In en, this message translates to:
  /// **'Your Residency Information'**
  String get public_profile_your_residency_info;

  /// No description provided for @public_profile_your_introduction.
  ///
  /// In en, this message translates to:
  /// **'Your Introduction'**
  String get public_profile_your_introduction;

  /// No description provided for @public_profile_birth_country.
  ///
  /// In en, this message translates to:
  /// **'Birth Country'**
  String get public_profile_birth_country;

  /// No description provided for @public_profile_residency_country.
  ///
  /// In en, this message translates to:
  /// **'Residency Country'**
  String get public_profile_residency_country;

  /// No description provided for @public_profile_growup_country.
  ///
  /// In en, this message translates to:
  /// **'Grow Up Country'**
  String get public_profile_growup_country;

  /// No description provided for @public_profile_immigration_status.
  ///
  /// In en, this message translates to:
  /// **'Immigration Status'**
  String get public_profile_immigration_status;

  /// No description provided for @public_profile_spiritual_n_social.
  ///
  /// In en, this message translates to:
  /// **'Spritual & Social Background'**
  String get public_profile_spiritual_n_social;

  /// No description provided for @public_profile_your_spiritual_n_social.
  ///
  /// In en, this message translates to:
  /// **'Your Spritual & Social Background'**
  String get public_profile_your_spiritual_n_social;

  /// No description provided for @manage_profile_religion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get manage_profile_religion;

  /// No description provided for @manage_profile_caste.
  ///
  /// In en, this message translates to:
  /// **'Caste'**
  String get manage_profile_caste;

  /// No description provided for @manage_profile_sub_caste.
  ///
  /// In en, this message translates to:
  /// **'Sub Caste'**
  String get manage_profile_sub_caste;

  /// No description provided for @manage_profile_ethnicity.
  ///
  /// In en, this message translates to:
  /// **'Ethnicity'**
  String get manage_profile_ethnicity;

  /// No description provided for @manage_profile_personal_val.
  ///
  /// In en, this message translates to:
  /// **'Personal Value'**
  String get manage_profile_personal_val;

  /// No description provided for @manage_profile_family_val.
  ///
  /// In en, this message translates to:
  /// **'Family Value'**
  String get manage_profile_family_val;

  /// No description provided for @manage_profile_community_val.
  ///
  /// In en, this message translates to:
  /// **'Community Value'**
  String get manage_profile_community_val;

  /// No description provided for @public_profile_life_style.
  ///
  /// In en, this message translates to:
  /// **'Life Style'**
  String get public_profile_life_style;

  /// No description provided for @public_profile_your_life_style.
  ///
  /// In en, this message translates to:
  /// **'Your Life Style'**
  String get public_profile_your_life_style;

  /// No description provided for @manage_profile_diet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get manage_profile_diet;

  /// No description provided for @manage_profile_drink.
  ///
  /// In en, this message translates to:
  /// **'Drink'**
  String get manage_profile_drink;

  /// No description provided for @manage_profile_smoke.
  ///
  /// In en, this message translates to:
  /// **'Smoke'**
  String get manage_profile_smoke;

  /// No description provided for @manage_profile_living_with.
  ///
  /// In en, this message translates to:
  /// **'Living with'**
  String get manage_profile_living_with;

  /// No description provided for @public_profile_Partner_expectation.
  ///
  /// In en, this message translates to:
  /// **'Partner Expectation'**
  String get public_profile_Partner_expectation;

  /// No description provided for @public_profile_your_Partner_expectation.
  ///
  /// In en, this message translates to:
  /// **'Your Partner Expectation'**
  String get public_profile_your_Partner_expectation;

  /// No description provided for @public_profile_Education_info.
  ///
  /// In en, this message translates to:
  /// **'Education Info'**
  String get public_profile_Education_info;

  /// No description provided for @public_profile_Your_Education_info.
  ///
  /// In en, this message translates to:
  /// **'Your Education Info'**
  String get public_profile_Your_Education_info;

  /// No description provided for @manage_profile_physical_attri.
  ///
  /// In en, this message translates to:
  /// **'Your Physical Attributes'**
  String get manage_profile_physical_attri;

  /// No description provided for @public_profile_known_language.
  ///
  /// In en, this message translates to:
  /// **'Known Language'**
  String get public_profile_known_language;

  /// No description provided for @public_profile_affection.
  ///
  /// In en, this message translates to:
  /// **'Affection'**
  String get public_profile_affection;

  /// No description provided for @public_profile_humor.
  ///
  /// In en, this message translates to:
  /// **'Humor'**
  String get public_profile_humor;

  /// No description provided for @public_profile_political_view.
  ///
  /// In en, this message translates to:
  /// **'Political Views'**
  String get public_profile_political_view;

  /// No description provided for @public_profile_religious_service.
  ///
  /// In en, this message translates to:
  /// **'Religious Service'**
  String get public_profile_religious_service;

  /// No description provided for @manage_profile_astronomic_info.
  ///
  /// In en, this message translates to:
  /// **'Astronomic Information'**
  String get manage_profile_astronomic_info;

  /// No description provided for @manage_profile_your_astronomic_info.
  ///
  /// In en, this message translates to:
  /// **'Your Astronomic Information'**
  String get manage_profile_your_astronomic_info;

  /// No description provided for @manage_profile_sun_sign.
  ///
  /// In en, this message translates to:
  /// **'Sun Sign'**
  String get manage_profile_sun_sign;

  /// No description provided for @manage_profile_moon_sign.
  ///
  /// In en, this message translates to:
  /// **'Moon Sign'**
  String get manage_profile_moon_sign;

  /// No description provided for @manage_profile_time_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Time of Birth'**
  String get manage_profile_time_of_birth;

  /// No description provided for @manage_profile_city_of_birth.
  ///
  /// In en, this message translates to:
  /// **'City of Birth'**
  String get manage_profile_city_of_birth;

  /// No description provided for @astro_sign_aries.
  ///
  /// In en, this message translates to:
  /// **'Aries'**
  String get astro_sign_aries;

  /// No description provided for @astro_sign_taurus.
  ///
  /// In en, this message translates to:
  /// **'Taurus'**
  String get astro_sign_taurus;

  /// No description provided for @astro_sign_gemini.
  ///
  /// In en, this message translates to:
  /// **'Gemini'**
  String get astro_sign_gemini;

  /// No description provided for @astro_sign_cancer.
  ///
  /// In en, this message translates to:
  /// **'Cancer'**
  String get astro_sign_cancer;

  /// No description provided for @astro_sign_leo.
  ///
  /// In en, this message translates to:
  /// **'Leo'**
  String get astro_sign_leo;

  /// No description provided for @astro_sign_virgo.
  ///
  /// In en, this message translates to:
  /// **'Virgo'**
  String get astro_sign_virgo;

  /// No description provided for @astro_sign_libra.
  ///
  /// In en, this message translates to:
  /// **'Libra'**
  String get astro_sign_libra;

  /// No description provided for @astro_sign_scorpio.
  ///
  /// In en, this message translates to:
  /// **'Scorpio'**
  String get astro_sign_scorpio;

  /// No description provided for @astro_sign_sagittarius.
  ///
  /// In en, this message translates to:
  /// **'Sagittarius'**
  String get astro_sign_sagittarius;

  /// No description provided for @astro_sign_capricorn.
  ///
  /// In en, this message translates to:
  /// **'Capricorn'**
  String get astro_sign_capricorn;

  /// No description provided for @astro_sign_aquarius.
  ///
  /// In en, this message translates to:
  /// **'Aquarius'**
  String get astro_sign_aquarius;

  /// No description provided for @astro_sign_pisces.
  ///
  /// In en, this message translates to:
  /// **'Pisces'**
  String get astro_sign_pisces;

  /// No description provided for @astro_pick_time.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get astro_pick_time;

  /// No description provided for @manage_profile_permanent_address.
  ///
  /// In en, this message translates to:
  /// **'Permanent Address'**
  String get manage_profile_permanent_address;

  /// No description provided for @manage_profile_your_permanent_address.
  ///
  /// In en, this message translates to:
  /// **'Your Permanent Address'**
  String get manage_profile_your_permanent_address;

  /// No description provided for @manage_profile_family_info.
  ///
  /// In en, this message translates to:
  /// **'Family Information'**
  String get manage_profile_family_info;

  /// No description provided for @manage_profile_your_family_info.
  ///
  /// In en, this message translates to:
  /// **'Your Family Information'**
  String get manage_profile_your_family_info;

  /// No description provided for @manage_profile_general_req.
  ///
  /// In en, this message translates to:
  /// **'General Requirement'**
  String get manage_profile_general_req;

  /// No description provided for @manage_profile_residence_country.
  ///
  /// In en, this message translates to:
  /// **'Residence Country'**
  String get manage_profile_residence_country;

  /// No description provided for @manage_profile_min_height.
  ///
  /// In en, this message translates to:
  /// **'Min Height (In Feet)'**
  String get manage_profile_min_height;

  /// No description provided for @manage_profile_max_weight.
  ///
  /// In en, this message translates to:
  /// **'Max Weight (In Kg)'**
  String get manage_profile_max_weight;

  /// No description provided for @manage_profile_children_acceptable.
  ///
  /// In en, this message translates to:
  /// **'Children Acceptable'**
  String get manage_profile_children_acceptable;

  /// No description provided for @manage_profile_education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get manage_profile_education;

  /// No description provided for @manage_profile_profession.
  ///
  /// In en, this message translates to:
  /// **'Profession'**
  String get manage_profile_profession;

  /// No description provided for @manage_profile_smoking_acceptable.
  ///
  /// In en, this message translates to:
  /// **'Smoking Acceptable'**
  String get manage_profile_smoking_acceptable;

  /// No description provided for @manage_profile_drinking_acceptable.
  ///
  /// In en, this message translates to:
  /// **'Drinking Acceptable'**
  String get manage_profile_drinking_acceptable;

  /// No description provided for @manage_profile_dieting_acceptable.
  ///
  /// In en, this message translates to:
  /// **'Dieting Acceptable'**
  String get manage_profile_dieting_acceptable;

  /// No description provided for @manage_profile_personal_value.
  ///
  /// In en, this message translates to:
  /// **'Personal Value'**
  String get manage_profile_personal_value;

  /// No description provided for @manage_profile_manglik.
  ///
  /// In en, this message translates to:
  /// **'Manglik'**
  String get manage_profile_manglik;

  /// No description provided for @manage_profile_preferred_country.
  ///
  /// In en, this message translates to:
  /// **'Preferred Country'**
  String get manage_profile_preferred_country;

  /// No description provided for @manage_profile_preferred_state.
  ///
  /// In en, this message translates to:
  /// **'Preferred State'**
  String get manage_profile_preferred_state;

  /// No description provided for @manage_profile_family_value.
  ///
  /// In en, this message translates to:
  /// **'Family Value'**
  String get manage_profile_family_value;

  /// No description provided for @manage_profile_complexion.
  ///
  /// In en, this message translates to:
  /// **'Complexion'**
  String get manage_profile_complexion;

  /// No description provided for @public_profile_name.
  ///
  /// In en, this message translates to:
  /// **'Name:'**
  String get public_profile_name;

  /// No description provided for @public_profile_religion.
  ///
  /// In en, this message translates to:
  /// **'Religion:'**
  String get public_profile_religion;

  /// No description provided for @public_profile_age.
  ///
  /// In en, this message translates to:
  /// **'Age:'**
  String get public_profile_age;

  /// No description provided for @public_profile_first_lang.
  ///
  /// In en, this message translates to:
  /// **'First Language:'**
  String get public_profile_first_lang;

  /// No description provided for @public_profile_children.
  ///
  /// In en, this message translates to:
  /// **'No. of Children:'**
  String get public_profile_children;

  /// No description provided for @public_profile_height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get public_profile_height;

  /// No description provided for @public_profile_dob.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth:'**
  String get public_profile_dob;

  /// No description provided for @public_profile_marital_status.
  ///
  /// In en, this message translates to:
  /// **'Marital Status:'**
  String get public_profile_marital_status;

  /// No description provided for @public_profile_country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get public_profile_country;

  /// No description provided for @public_profile_state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get public_profile_state;

  /// No description provided for @public_profile_city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get public_profile_city;

  /// No description provided for @public_profile_postal_code.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get public_profile_postal_code;

  /// No description provided for @public_profile_contact_number.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get public_profile_contact_number;

  /// No description provided for @public_profile_email.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get public_profile_email;

  /// No description provided for @public_profile_degree.
  ///
  /// In en, this message translates to:
  /// **'Degree'**
  String get public_profile_degree;

  /// No description provided for @public_profile_institution.
  ///
  /// In en, this message translates to:
  /// **'Institution'**
  String get public_profile_institution;

  /// No description provided for @public_profile_start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get public_profile_start;

  /// No description provided for @public_profile_end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get public_profile_end;

  /// No description provided for @public_profile_designation.
  ///
  /// In en, this message translates to:
  /// **'Designation'**
  String get public_profile_designation;

  /// No description provided for @public_profile_company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get public_profile_company;

  /// No description provided for @public_profile_eye_color.
  ///
  /// In en, this message translates to:
  /// **'Eye Color'**
  String get public_profile_eye_color;

  /// No description provided for @public_profile_complexion.
  ///
  /// In en, this message translates to:
  /// **'Complexion'**
  String get public_profile_complexion;

  /// No description provided for @public_profile_body_type.
  ///
  /// In en, this message translates to:
  /// **'Body Type'**
  String get public_profile_body_type;

  /// No description provided for @public_profile_disability.
  ///
  /// In en, this message translates to:
  /// **'Disability'**
  String get public_profile_disability;

  /// No description provided for @public_profile_weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get public_profile_weight;

  /// No description provided for @public_profile_hair_color.
  ///
  /// In en, this message translates to:
  /// **'Hair Color'**
  String get public_profile_hair_color;

  /// No description provided for @public_profile_blood_group.
  ///
  /// In en, this message translates to:
  /// **'Blood Group'**
  String get public_profile_blood_group;

  /// No description provided for @public_profile_body_art.
  ///
  /// In en, this message translates to:
  /// **'Body Art'**
  String get public_profile_body_art;

  /// No description provided for @public_profile_general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get public_profile_general;

  /// No description provided for @referral_screen.
  ///
  /// In en, this message translates to:
  /// **'REFERRAL'**
  String get referral_screen;

  /// No description provided for @referral_earning_screen.
  ///
  /// In en, this message translates to:
  /// **'REFERRAL EARNINGS'**
  String get referral_earning_screen;

  /// No description provided for @referral_screen_referral_code.
  ///
  /// In en, this message translates to:
  /// **'Referral Code:'**
  String get referral_screen_referral_code;

  /// No description provided for @referral_screen_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get referral_screen_name;

  /// No description provided for @referral_screen_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get referral_screen_date;

  /// No description provided for @referral_earning_screen_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get referral_earning_screen_amount;

  /// No description provided for @referral_earnings_wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet Withdraw Request'**
  String get referral_earnings_wallet;

  /// No description provided for @wallet_screen.
  ///
  /// In en, this message translates to:
  /// **'MY WALLET'**
  String get wallet_screen;

  /// No description provided for @wallet_screen_my_wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet Balance'**
  String get wallet_screen_my_wallet;

  /// No description provided for @wallet_screen_recharge_wallet.
  ///
  /// In en, this message translates to:
  /// **'Recharge Wallet'**
  String get wallet_screen_recharge_wallet;

  /// No description provided for @wallet_screen_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get wallet_screen_date;

  /// No description provided for @wallet_screen_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get wallet_screen_amount;

  /// No description provided for @wallet_screen_details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get wallet_screen_details;

  /// No description provided for @wallet_screen_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get wallet_screen_status;

  /// No description provided for @package_history.
  ///
  /// In en, this message translates to:
  /// **'Package History'**
  String get package_history;

  /// No description provided for @package_details.
  ///
  /// In en, this message translates to:
  /// **'PACKAGE DETAILS'**
  String get package_details;

  /// No description provided for @package_history_code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get package_history_code;

  /// No description provided for @package_history_package.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get package_history_package;

  /// No description provided for @package_history_payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get package_history_payment_method;

  /// No description provided for @package_history_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get package_history_amount;

  /// No description provided for @package_history_payment_status.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get package_history_payment_status;

  /// No description provided for @package_history_purchase_date.
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get package_history_purchase_date;

  /// No description provided for @support_ticket.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT TICKET'**
  String get support_ticket;

  /// No description provided for @support_ticket_create_ticket.
  ///
  /// In en, this message translates to:
  /// **'Create Ticket'**
  String get support_ticket_create_ticket;

  /// No description provided for @support_ticket_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get support_ticket_status;

  /// No description provided for @support_ticket_subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get support_ticket_subject;

  /// No description provided for @support_ticket_sub_category.
  ///
  /// In en, this message translates to:
  /// **'Subject Category'**
  String get support_ticket_sub_category;

  /// No description provided for @support_ticket_category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get support_ticket_category;

  /// No description provided for @support_ticket_new_reply.
  ///
  /// In en, this message translates to:
  /// **'New Reply'**
  String get support_ticket_new_reply;

  /// No description provided for @support_ticket_view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get support_ticket_view;

  /// No description provided for @support_ticket_send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get support_ticket_send;

  /// No description provided for @support_ticket_details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get support_ticket_details;

  /// No description provided for @ignore_screen_ignore_members.
  ///
  /// In en, this message translates to:
  /// **'IGNORE MEMBERS'**
  String get ignore_screen_ignore_members;

  /// No description provided for @ignore_screen_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get ignore_screen_remove;

  /// No description provided for @my_shortlist_screen_appbar_title.
  ///
  /// In en, this message translates to:
  /// **'MY SHORTLIST'**
  String get my_shortlist_screen_appbar_title;

  /// No description provided for @my_interest_screen_appbar_title.
  ///
  /// In en, this message translates to:
  /// **'MY INTERESTS'**
  String get my_interest_screen_appbar_title;

  /// No description provided for @my_interest_screen_request_interests.
  ///
  /// In en, this message translates to:
  /// **'Interests Request'**
  String get my_interest_screen_request_interests;

  /// No description provided for @interest_request_screen_appbar_title.
  ///
  /// In en, this message translates to:
  /// **'Interest Requests'**
  String get interest_request_screen_appbar_title;

  /// No description provided for @profile_picture_screen_appbar_title.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture View Requests'**
  String get profile_picture_screen_appbar_title;

  /// No description provided for @gallery_picture_screen_appbar_title.
  ///
  /// In en, this message translates to:
  /// **'Gallery Picture View Requests'**
  String get gallery_picture_screen_appbar_title;

  /// No description provided for @active_members_screen_appbar_title.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE MEMBERS'**
  String get active_members_screen_appbar_title;

  /// No description provided for @premium_plans_appbar_title.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM PLANS'**
  String get premium_plans_appbar_title;

  /// No description provided for @premium_plans_choose_plan.
  ///
  /// In en, this message translates to:
  /// **'Choose your plan'**
  String get premium_plans_choose_plan;

  /// No description provided for @premium_plans_choose_plan_sub.
  ///
  /// In en, this message translates to:
  /// **'Choose any of our packages as per your need.'**
  String get premium_plans_choose_plan_sub;

  /// No description provided for @premium_plans_express_interest.
  ///
  /// In en, this message translates to:
  /// **'Express Interest'**
  String get premium_plans_express_interest;

  /// No description provided for @premium_plans_gallery_photo_upload.
  ///
  /// In en, this message translates to:
  /// **'Gallery photo upload'**
  String get premium_plans_gallery_photo_upload;

  /// No description provided for @premium_plans_contact_info_view.
  ///
  /// In en, this message translates to:
  /// **'Contact info view'**
  String get premium_plans_contact_info_view;

  /// No description provided for @premium_plans_show_profile_match.
  ///
  /// In en, this message translates to:
  /// **'Show auto profile match'**
  String get premium_plans_show_profile_match;

  /// No description provided for @premium_plans_days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get premium_plans_days;

  /// No description provided for @happy_story_screen_appbar_title.
  ///
  /// In en, this message translates to:
  /// **'HAPPY STORIES'**
  String get happy_story_screen_appbar_title;

  /// No description provided for @blogs_screen_appbar_title.
  ///
  /// In en, this message translates to:
  /// **'ALL BLOGS'**
  String get blogs_screen_appbar_title;

  /// No description provided for @blogs_screen_read_full_blogs.
  ///
  /// In en, this message translates to:
  /// **'Read full blog'**
  String get blogs_screen_read_full_blogs;

  /// No description provided for @blog_details_screen_appbar_title.
  ///
  /// In en, this message translates to:
  /// **'BLOG DETAILS'**
  String get blog_details_screen_appbar_title;

  /// No description provided for @gallery_1_screen_featured_photos.
  ///
  /// In en, this message translates to:
  /// **'Gallery Photos'**
  String get gallery_1_screen_featured_photos;

  /// No description provided for @gallery_1_screen_add_new_image.
  ///
  /// In en, this message translates to:
  /// **'Add new image'**
  String get gallery_1_screen_add_new_image;

  /// No description provided for @change_email_screen_appbar_title.
  ///
  /// In en, this message translates to:
  /// **'Change your email'**
  String get change_email_screen_appbar_title;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivating your account will prevent you from performing any actions. Are you sure you want to deactivate your account?'**
  String get deactivate;

  /// No description provided for @reactivate.
  ///
  /// In en, this message translates to:
  /// **'Do You Really Want To Reactivate Your Account'**
  String get reactivate;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Do You Really Want To Delete Your Account'**
  String get delete_account;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Do you want to exit the app?'**
  String get exit;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @happy_stories_details_appbar_title.
  ///
  /// In en, this message translates to:
  /// **'HAPPY STORIES'**
  String get happy_stories_details_appbar_title;

  /// No description provided for @introduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get introduction;

  /// No description provided for @happy_stories_form_appbar_title.
  ///
  /// In en, this message translates to:
  /// **'Create Happy Stories'**
  String get happy_stories_form_appbar_title;

  /// No description provided for @happy_stories_form_sub_title.
  ///
  /// In en, this message translates to:
  /// **'Add Your Story'**
  String get happy_stories_form_sub_title;

  /// No description provided for @happy_stories_form_story_title.
  ///
  /// In en, this message translates to:
  /// **'Story Title'**
  String get happy_stories_form_story_title;

  /// No description provided for @happy_stories_form_story_details.
  ///
  /// In en, this message translates to:
  /// **'Story Details'**
  String get happy_stories_form_story_details;

  /// No description provided for @happy_stories_form_partner_name.
  ///
  /// In en, this message translates to:
  /// **'Partner Name'**
  String get happy_stories_form_partner_name;

  /// No description provided for @happy_stories_form_photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get happy_stories_form_photos;

  /// No description provided for @happy_stories_form_video_provider.
  ///
  /// In en, this message translates to:
  /// **'Video Provider'**
  String get happy_stories_form_video_provider;

  /// No description provided for @happy_stories_form_video_link.
  ///
  /// In en, this message translates to:
  /// **'Video Link'**
  String get happy_stories_form_video_link;

  /// No description provided for @happy_stories_form_warning_text.
  ///
  /// In en, this message translates to:
  /// **'Use proper link without extra parameter. Don\'t use short share link/embedded iframe code.'**
  String get happy_stories_form_warning_text;

  /// No description provided for @save_change_btn_text.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_change_btn_text;

  /// No description provided for @my_happy_stories_appbar_title.
  ///
  /// In en, this message translates to:
  /// **'My Happy Story'**
  String get my_happy_stories_appbar_title;

  /// No description provided for @paypal_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Pay with Paypal'**
  String get paypal_screen_title;

  /// No description provided for @instamojo_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Pay with Instamojo'**
  String get instamojo_screen_title;

  /// No description provided for @phonepe_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Pay with PhonePe'**
  String get phonepe_screen_title;

  /// No description provided for @stripe_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Pay with Stripe'**
  String get stripe_screen_title;

  /// No description provided for @razorpay_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Pay with Razorpay'**
  String get razorpay_screen_title;

  /// No description provided for @paytm_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Pay with Paytm'**
  String get paytm_screen_title;

  /// No description provided for @test.
  ///
  /// In en, this message translates to:
  /// **'in the last line there will be no comma in arb file'**
  String get test;

  /// No description provided for @package_purchase.
  ///
  /// In en, this message translates to:
  /// **'Package Purchase'**
  String get package_purchase;

  /// No description provided for @please_update_your_package_des.
  ///
  /// In en, this message translates to:
  /// **'Your are using free package please upgrade your package.'**
  String get please_update_your_package_des;

  /// No description provided for @please_update_your_package.
  ///
  /// In en, this message translates to:
  /// **'Please Update Your Package.'**
  String get please_update_your_package;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otp;

  /// No description provided for @re_send_otp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get re_send_otp;

  /// No description provided for @or_logout.
  ///
  /// In en, this message translates to:
  /// **'Or Logout'**
  String get or_logout;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong!'**
  String get something_went_wrong;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info!'**
  String get info;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contact_us;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @onboarding_1_title.
  ///
  /// In en, this message translates to:
  /// **'Create Your Profile'**
  String get onboarding_1_title;

  /// No description provided for @onboarding_1_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up for free and set up your profile to let the world know who you are.'**
  String get onboarding_1_subtitle;

  /// No description provided for @onboarding_2_title.
  ///
  /// In en, this message translates to:
  /// **'Find Your Match'**
  String get onboarding_2_title;

  /// No description provided for @onboarding_2_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect with thousands of verified profiles and find the one made for you.'**
  String get onboarding_2_subtitle;

  /// No description provided for @onboarding_3_title.
  ///
  /// In en, this message translates to:
  /// **'Start Conversation'**
  String get onboarding_3_title;

  /// No description provided for @onboarding_3_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Interact with your matches securely and take the first step towards your forever.'**
  String get onboarding_3_subtitle;

  /// No description provided for @home_greeting_morning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get home_greeting_morning;

  /// No description provided for @home_greeting_afternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get home_greeting_afternoon;

  /// No description provided for @home_greeting_evening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get home_greeting_evening;

  /// No description provided for @home_profile_completeness.
  ///
  /// In en, this message translates to:
  /// **'Profile {percent}% Complete'**
  String home_profile_completeness(Object percent);

  /// No description provided for @explore_page_title.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get explore_page_title;

  /// No description provided for @explore_active_now.
  ///
  /// In en, this message translates to:
  /// **'Active Now'**
  String get explore_active_now;

  /// No description provided for @explore_no_matches.
  ///
  /// In en, this message translates to:
  /// **'No matches found.'**
  String get explore_no_matches;

  /// No description provided for @explore_adjust_prefs.
  ///
  /// In en, this message translates to:
  /// **'Adjust your preferences to see more profiles.'**
  String get explore_adjust_prefs;

  /// No description provided for @explore_edit_prefs.
  ///
  /// In en, this message translates to:
  /// **'Edit Preferences'**
  String get explore_edit_prefs;

  /// No description provided for @explore_top_matches.
  ///
  /// In en, this message translates to:
  /// **'Top Matches For You'**
  String get explore_top_matches;

  /// No description provided for @explore_nearby.
  ///
  /// In en, this message translates to:
  /// **'Matches Near You'**
  String get explore_nearby;

  /// No description provided for @explore_interest.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get explore_interest;

  /// No description provided for @explore_shortlist.
  ///
  /// In en, this message translates to:
  /// **'Shortlist'**
  String get explore_shortlist;

  /// No description provided for @explore_view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get explore_view;

  /// No description provided for @explore_follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get explore_follow;

  /// No description provided for @explore_ignore.
  ///
  /// In en, this message translates to:
  /// **'Ignore'**
  String get explore_ignore;

  /// No description provided for @explore_chip_height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get explore_chip_height;

  /// No description provided for @explore_chip_caste.
  ///
  /// In en, this message translates to:
  /// **'Caste'**
  String get explore_chip_caste;

  /// No description provided for @explore_chip_edu.
  ///
  /// In en, this message translates to:
  /// **'Edu'**
  String get explore_chip_edu;

  /// No description provided for @explore_chip_job.
  ///
  /// In en, this message translates to:
  /// **'Job'**
  String get explore_chip_job;

  /// No description provided for @explore_chip_income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get explore_chip_income;

  /// No description provided for @explore_chip_na.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get explore_chip_na;

  /// No description provided for @explore_match_high.
  ///
  /// In en, this message translates to:
  /// **'High Match'**
  String get explore_match_high;

  /// No description provided for @explore_match_medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get explore_match_medium;

  /// No description provided for @explore_match_low.
  ///
  /// In en, this message translates to:
  /// **'Low Match'**
  String get explore_match_low;

  /// No description provided for @explore_ft.
  ///
  /// In en, this message translates to:
  /// **'ft'**
  String get explore_ft;

  /// No description provided for @explore_active_ago.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get explore_active_ago;

  /// No description provided for @profile_edit_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profile_edit_title;

  /// No description provided for @profile_step_basic.
  ///
  /// In en, this message translates to:
  /// **'Basic & Physical'**
  String get profile_step_basic;

  /// No description provided for @profile_step_family.
  ///
  /// In en, this message translates to:
  /// **'Family & Career'**
  String get profile_step_family;

  /// No description provided for @profile_step_contact.
  ///
  /// In en, this message translates to:
  /// **'Contact & Photos'**
  String get profile_step_contact;

  /// No description provided for @profile_step_expectations.
  ///
  /// In en, this message translates to:
  /// **'Partner Expectations'**
  String get profile_step_expectations;

  /// No description provided for @profile_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get profile_next;

  /// No description provided for @profile_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get profile_back;

  /// No description provided for @profile_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get profile_submit;

  /// No description provided for @profile_saved_ok.
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully!'**
  String get profile_saved_ok;

  /// No description provided for @profile_saved_fail.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile.'**
  String get profile_saved_fail;

  /// No description provided for @profile_save_error.
  ///
  /// In en, this message translates to:
  /// **'Error saving profile!'**
  String get profile_save_error;

  /// No description provided for @profile_section_basic.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get profile_section_basic;

  /// No description provided for @profile_section_physical.
  ///
  /// In en, this message translates to:
  /// **'Physical Information'**
  String get profile_section_physical;

  /// No description provided for @profile_section_family.
  ///
  /// In en, this message translates to:
  /// **'Family Information'**
  String get profile_section_family;

  /// No description provided for @profile_section_education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get profile_section_education;

  /// No description provided for @profile_section_career.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get profile_section_career;

  /// No description provided for @profile_section_contact.
  ///
  /// In en, this message translates to:
  /// **'Contact & Address'**
  String get profile_section_contact;

  /// No description provided for @profile_section_photos.
  ///
  /// In en, this message translates to:
  /// **'Photo Uploads'**
  String get profile_section_photos;

  /// No description provided for @profile_section_expectations.
  ///
  /// In en, this message translates to:
  /// **'Partner Expectations'**
  String get profile_section_expectations;

  /// No description provided for @profile_label_first_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get profile_label_first_name;

  /// No description provided for @profile_label_middle_name.
  ///
  /// In en, this message translates to:
  /// **'Middle Name'**
  String get profile_label_middle_name;

  /// No description provided for @profile_label_last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get profile_label_last_name;

  /// No description provided for @profile_label_dob.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get profile_label_dob;

  /// No description provided for @profile_label_age.
  ///
  /// In en, this message translates to:
  /// **'Age: {age} Years'**
  String profile_label_age(Object age);

  /// No description provided for @profile_label_religion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get profile_label_religion;

  /// No description provided for @profile_label_caste.
  ///
  /// In en, this message translates to:
  /// **'Caste'**
  String get profile_label_caste;

  /// No description provided for @profile_label_marital_status.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get profile_label_marital_status;

  /// No description provided for @profile_label_height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get profile_label_height;

  /// No description provided for @profile_label_weight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get profile_label_weight;

  /// No description provided for @profile_label_blood_group.
  ///
  /// In en, this message translates to:
  /// **'Blood Group'**
  String get profile_label_blood_group;

  /// No description provided for @profile_label_complexion.
  ///
  /// In en, this message translates to:
  /// **'Complexion'**
  String get profile_label_complexion;

  /// No description provided for @profile_label_disability.
  ///
  /// In en, this message translates to:
  /// **'Physical Disability'**
  String get profile_label_disability;

  /// No description provided for @profile_label_disability_details.
  ///
  /// In en, this message translates to:
  /// **'Disability Details'**
  String get profile_label_disability_details;

  /// No description provided for @profile_label_diet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get profile_label_diet;

  /// No description provided for @profile_label_manglik.
  ///
  /// In en, this message translates to:
  /// **'Manglik'**
  String get profile_label_manglik;

  /// No description provided for @profile_label_intercaste.
  ///
  /// In en, this message translates to:
  /// **'Intercaste Marriage Accepted'**
  String get profile_label_intercaste;

  /// No description provided for @profile_label_father_alive.
  ///
  /// In en, this message translates to:
  /// **'Is Father Alive?'**
  String get profile_label_father_alive;

  /// No description provided for @profile_label_mother_alive.
  ///
  /// In en, this message translates to:
  /// **'Is Mother Alive?'**
  String get profile_label_mother_alive;

  /// No description provided for @profile_label_brothers.
  ///
  /// In en, this message translates to:
  /// **'Number of Brothers'**
  String get profile_label_brothers;

  /// No description provided for @profile_label_married_brothers.
  ///
  /// In en, this message translates to:
  /// **'Married Brothers'**
  String get profile_label_married_brothers;

  /// No description provided for @profile_label_sisters.
  ///
  /// In en, this message translates to:
  /// **'Number of Sisters'**
  String get profile_label_sisters;

  /// No description provided for @profile_label_married_sisters.
  ///
  /// In en, this message translates to:
  /// **'Married Sisters'**
  String get profile_label_married_sisters;

  /// No description provided for @profile_label_parents_occ.
  ///
  /// In en, this message translates to:
  /// **'Parents Occupation'**
  String get profile_label_parents_occ;

  /// No description provided for @profile_label_property.
  ///
  /// In en, this message translates to:
  /// **'Property Details'**
  String get profile_label_property;

  /// No description provided for @profile_label_education_level.
  ///
  /// In en, this message translates to:
  /// **'Education Level'**
  String get profile_label_education_level;

  /// No description provided for @profile_label_occ_type.
  ///
  /// In en, this message translates to:
  /// **'Occupation Type'**
  String get profile_label_occ_type;

  /// No description provided for @profile_label_occ_details.
  ///
  /// In en, this message translates to:
  /// **'Occupation Details'**
  String get profile_label_occ_details;

  /// No description provided for @profile_label_income.
  ///
  /// In en, this message translates to:
  /// **'Annual Income'**
  String get profile_label_income;

  /// No description provided for @profile_label_gov_id_type.
  ///
  /// In en, this message translates to:
  /// **'Government ID Type'**
  String get profile_label_gov_id_type;

  /// No description provided for @profile_label_gov_id_number.
  ///
  /// In en, this message translates to:
  /// **'Government ID Number'**
  String get profile_label_gov_id_number;

  /// No description provided for @profile_label_address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get profile_label_address;

  /// No description provided for @profile_label_city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get profile_label_city;

  /// No description provided for @profile_label_mobile1.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number 1'**
  String get profile_label_mobile1;

  /// No description provided for @profile_label_mobile2.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number 2 (Optional)'**
  String get profile_label_mobile2;

  /// No description provided for @profile_label_profile_photo.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profile_label_profile_photo;

  /// No description provided for @profile_label_id_proof.
  ///
  /// In en, this message translates to:
  /// **'ID Proof Upload'**
  String get profile_label_id_proof;

  /// No description provided for @profile_label_other_photos.
  ///
  /// In en, this message translates to:
  /// **'Other Photos'**
  String get profile_label_other_photos;

  /// No description provided for @profile_label_upload_tap.
  ///
  /// In en, this message translates to:
  /// **'Tap to Upload'**
  String get profile_label_upload_tap;

  /// No description provided for @profile_label_upload_multi_tap.
  ///
  /// In en, this message translates to:
  /// **'Tap to Upload Multiple Photos'**
  String get profile_label_upload_multi_tap;

  /// No description provided for @profile_label_date_pick.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get profile_label_date_pick;

  /// No description provided for @profile_label_select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get profile_label_select;

  /// No description provided for @profile_label_preferred_cities.
  ///
  /// In en, this message translates to:
  /// **'Preferred Cities'**
  String get profile_label_preferred_cities;

  /// No description provided for @profile_label_partner_manglik.
  ///
  /// In en, this message translates to:
  /// **'Manglik Preference'**
  String get profile_label_partner_manglik;

  /// No description provided for @profile_label_expected_edu.
  ///
  /// In en, this message translates to:
  /// **'Expected Education'**
  String get profile_label_expected_edu;

  /// No description provided for @profile_label_expected_income.
  ///
  /// In en, this message translates to:
  /// **'Expected Income'**
  String get profile_label_expected_income;

  /// No description provided for @profile_label_divorce_accepted.
  ///
  /// In en, this message translates to:
  /// **'Divorce Accepted'**
  String get profile_label_divorce_accepted;

  /// No description provided for @profile_label_partner_intercaste.
  ///
  /// In en, this message translates to:
  /// **'Intercaste Marriage Accepted'**
  String get profile_label_partner_intercaste;

  /// No description provided for @profile_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get profile_yes;

  /// No description provided for @profile_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get profile_no;

  /// No description provided for @pub_profile_basic_info.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get pub_profile_basic_info;

  /// No description provided for @pub_profile_about.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get pub_profile_about;

  /// No description provided for @pub_profile_personal.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get pub_profile_personal;

  /// No description provided for @pub_profile_professional.
  ///
  /// In en, this message translates to:
  /// **'Professional Details'**
  String get pub_profile_professional;

  /// No description provided for @pub_profile_family.
  ///
  /// In en, this message translates to:
  /// **'Family Details'**
  String get pub_profile_family;

  /// No description provided for @pub_profile_physical.
  ///
  /// In en, this message translates to:
  /// **'Physical Attributes'**
  String get pub_profile_physical;

  /// No description provided for @pub_profile_spiritual.
  ///
  /// In en, this message translates to:
  /// **'Spiritual & Social'**
  String get pub_profile_spiritual;

  /// No description provided for @pub_profile_lifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get pub_profile_lifestyle;

  /// No description provided for @pub_profile_partner_exp.
  ///
  /// In en, this message translates to:
  /// **'Partner Expectations'**
  String get pub_profile_partner_exp;

  /// No description provided for @pub_profile_gallery.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get pub_profile_gallery;

  /// No description provided for @pub_profile_verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get pub_profile_verified;

  /// No description provided for @pub_profile_match.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get pub_profile_match;

  /// No description provided for @pub_profile_age_years.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get pub_profile_age_years;

  /// No description provided for @pub_profile_religion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get pub_profile_religion;

  /// No description provided for @pub_profile_height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get pub_profile_height;

  /// No description provided for @pub_profile_marital_status.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get pub_profile_marital_status;

  /// No description provided for @pub_profile_mother_tongue.
  ///
  /// In en, this message translates to:
  /// **'Mother Tongue'**
  String get pub_profile_mother_tongue;

  /// No description provided for @pub_profile_age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get pub_profile_age;

  /// No description provided for @pub_profile_caste.
  ///
  /// In en, this message translates to:
  /// **'Caste'**
  String get pub_profile_caste;

  /// No description provided for @pub_profile_education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get pub_profile_education;

  /// No description provided for @pub_profile_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get pub_profile_location;

  /// No description provided for @pub_profile_designation.
  ///
  /// In en, this message translates to:
  /// **'Designation'**
  String get pub_profile_designation;

  /// No description provided for @pub_profile_company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get pub_profile_company;

  /// No description provided for @pub_profile_income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get pub_profile_income;

  /// No description provided for @pub_profile_occ_type.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get pub_profile_occ_type;

  /// No description provided for @pub_profile_father.
  ///
  /// In en, this message translates to:
  /// **'Father'**
  String get pub_profile_father;

  /// No description provided for @pub_profile_mother.
  ///
  /// In en, this message translates to:
  /// **'Mother'**
  String get pub_profile_mother;

  /// No description provided for @pub_profile_brothers.
  ///
  /// In en, this message translates to:
  /// **'Brothers'**
  String get pub_profile_brothers;

  /// No description provided for @pub_profile_sisters.
  ///
  /// In en, this message translates to:
  /// **'Sisters'**
  String get pub_profile_sisters;

  /// No description provided for @pub_profile_weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get pub_profile_weight;

  /// No description provided for @pub_profile_blood_group.
  ///
  /// In en, this message translates to:
  /// **'Blood Group'**
  String get pub_profile_blood_group;

  /// No description provided for @pub_profile_complexion.
  ///
  /// In en, this message translates to:
  /// **'Complexion'**
  String get pub_profile_complexion;

  /// No description provided for @pub_profile_disability.
  ///
  /// In en, this message translates to:
  /// **'Disability'**
  String get pub_profile_disability;

  /// No description provided for @pub_profile_manglik.
  ///
  /// In en, this message translates to:
  /// **'Manglik'**
  String get pub_profile_manglik;

  /// No description provided for @pub_profile_intercaste.
  ///
  /// In en, this message translates to:
  /// **'Intercaste Accepted'**
  String get pub_profile_intercaste;

  /// No description provided for @pub_profile_diet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get pub_profile_diet;

  /// No description provided for @pub_profile_drink.
  ///
  /// In en, this message translates to:
  /// **'Drink'**
  String get pub_profile_drink;

  /// No description provided for @pub_profile_smoke.
  ///
  /// In en, this message translates to:
  /// **'Smoke'**
  String get pub_profile_smoke;

  /// No description provided for @pub_profile_pref_edu.
  ///
  /// In en, this message translates to:
  /// **'Expected Education'**
  String get pub_profile_pref_edu;

  /// No description provided for @pub_profile_pref_income.
  ///
  /// In en, this message translates to:
  /// **'Expected Income'**
  String get pub_profile_pref_income;

  /// No description provided for @pub_profile_pref_cities.
  ///
  /// In en, this message translates to:
  /// **'Preferred Cities'**
  String get pub_profile_pref_cities;

  /// No description provided for @pub_profile_pref_divorce.
  ///
  /// In en, this message translates to:
  /// **'Divorce Accepted'**
  String get pub_profile_pref_divorce;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @settings_section_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settings_section_account;

  /// No description provided for @settings_item_edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get settings_item_edit_profile;

  /// No description provided for @settings_item_plans.
  ///
  /// In en, this message translates to:
  /// **'Membership Plans'**
  String get settings_item_plans;

  /// No description provided for @settings_item_verify.
  ///
  /// In en, this message translates to:
  /// **'Verification Status'**
  String get settings_item_verify;

  /// No description provided for @settings_section_preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences & Personalization'**
  String get settings_section_preferences;

  /// No description provided for @settings_item_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_item_language;

  /// No description provided for @settings_item_partner_pref.
  ///
  /// In en, this message translates to:
  /// **'Partner Expectations'**
  String get settings_item_partner_pref;

  /// No description provided for @settings_item_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settings_item_notifications;

  /// No description provided for @settings_item_app_theme.
  ///
  /// In en, this message translates to:
  /// **'App Theme'**
  String get settings_item_app_theme;

  /// No description provided for @settings_section_security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settings_section_security;

  /// No description provided for @settings_item_change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get settings_item_change_password;

  /// No description provided for @settings_item_privacy_settings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get settings_item_privacy_settings;

  /// No description provided for @settings_item_deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Account'**
  String get settings_item_deactivate;

  /// No description provided for @settings_section_help.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get settings_section_help;

  /// No description provided for @settings_item_help_center.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get settings_item_help_center;

  /// No description provided for @settings_item_faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get settings_item_faq;

  /// No description provided for @settings_item_contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get settings_item_contact_us;

  /// No description provided for @settings_section_legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get settings_section_legal;

  /// No description provided for @settings_item_terms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get settings_item_terms;

  /// No description provided for @settings_item_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settings_item_privacy_policy;

  /// No description provided for @settings_item_refund_policy.
  ///
  /// In en, this message translates to:
  /// **'Refund Policy'**
  String get settings_item_refund_policy;

  /// No description provided for @settings_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get settings_logout;

  /// No description provided for @settings_language_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get settings_language_dialog_title;

  /// No description provided for @settings_deactivate_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to deactivate your account?'**
  String get settings_deactivate_confirm;

  /// No description provided for @settings_personalization_desc.
  ///
  /// In en, this message translates to:
  /// **'Customize your app experience'**
  String get settings_personalization_desc;

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_title;

  /// No description provided for @profile_completion.
  ///
  /// In en, this message translates to:
  /// **'Profile Completion'**
  String get profile_completion;

  /// No description provided for @profile_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profile_edit;

  /// No description provided for @profile_membership_status.
  ///
  /// In en, this message translates to:
  /// **'Membership Status'**
  String get profile_membership_status;

  /// No description provided for @profile_interests.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get profile_interests;

  /// No description provided for @profile_contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get profile_contacts;

  /// No description provided for @profile_gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get profile_gallery;

  /// No description provided for @profile_upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Plan'**
  String get profile_upgrade;

  /// No description provided for @profile_shortlist.
  ///
  /// In en, this message translates to:
  /// **'Shortlist'**
  String get profile_shortlist;

  /// No description provided for @profile_interests_sent.
  ///
  /// In en, this message translates to:
  /// **'Interests Sent'**
  String get profile_interests_sent;

  /// No description provided for @profile_packages.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get profile_packages;

  /// No description provided for @profile_referral.
  ///
  /// In en, this message translates to:
  /// **'Referral'**
  String get profile_referral;

  /// No description provided for @common_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get common_yes;

  /// No description provided for @common_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get common_no;

  /// No description provided for @drawer_my_profile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get drawer_my_profile;

  /// No description provided for @drawer_edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get drawer_edit_profile;

  /// No description provided for @drawer_sent_interests.
  ///
  /// In en, this message translates to:
  /// **'Sent Interests'**
  String get drawer_sent_interests;

  /// No description provided for @drawer_shortlist.
  ///
  /// In en, this message translates to:
  /// **'Shortlist'**
  String get drawer_shortlist;

  /// No description provided for @drawer_verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get drawer_verification;

  /// No description provided for @drawer_membership_plans.
  ///
  /// In en, this message translates to:
  /// **'Membership Plans'**
  String get drawer_membership_plans;

  /// No description provided for @drawer_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawer_settings;

  /// No description provided for @drawer_help_center.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get drawer_help_center;

  /// No description provided for @drawer_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get drawer_logout;

  /// No description provided for @home_why_recommended.
  ///
  /// In en, this message translates to:
  /// **'Why is this profile recommended?'**
  String get home_why_recommended;

  /// No description provided for @home_same_religion.
  ///
  /// In en, this message translates to:
  /// **'Same Religion'**
  String get home_same_religion;

  /// No description provided for @home_same_city.
  ///
  /// In en, this message translates to:
  /// **'Same City'**
  String get home_same_city;

  /// No description provided for @home_same_education.
  ///
  /// In en, this message translates to:
  /// **'Same Education'**
  String get home_same_education;

  /// No description provided for @home_matches_preferences.
  ///
  /// In en, this message translates to:
  /// **'This profile matches your partner preferences.'**
  String get home_matches_preferences;

  /// No description provided for @home_quick_actions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get home_quick_actions;

  /// No description provided for @home_action_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get home_action_search;

  /// No description provided for @home_action_liked.
  ///
  /// In en, this message translates to:
  /// **'Liked'**
  String get home_action_liked;

  /// No description provided for @home_action_viewed.
  ///
  /// In en, this message translates to:
  /// **'Viewed'**
  String get home_action_viewed;

  /// No description provided for @home_action_shortlist.
  ///
  /// In en, this message translates to:
  /// **'Shortlist'**
  String get home_action_shortlist;

  /// No description provided for @home_new_partner.
  ///
  /// In en, this message translates to:
  /// **'New Partner'**
  String get home_new_partner;

  /// No description provided for @home_received_likes.
  ///
  /// In en, this message translates to:
  /// **'Received Likes'**
  String get home_received_likes;

  /// No description provided for @home_profiles_viewed.
  ///
  /// In en, this message translates to:
  /// **'Profiles Viewed'**
  String get home_profiles_viewed;

  /// No description provided for @home_selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get home_selected;

  /// No description provided for @home_recommended_for_you.
  ///
  /// In en, this message translates to:
  /// **'Recommended For You'**
  String get home_recommended_for_you;

  /// No description provided for @home_see_all.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get home_see_all;

  /// No description provided for @home_recent_activity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get home_recent_activity;

  /// No description provided for @home_people.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get home_people;

  /// No description provided for @home_viewed_your_profile.
  ///
  /// In en, this message translates to:
  /// **'viewed your profile'**
  String get home_viewed_your_profile;

  /// No description provided for @home_new_like_received.
  ///
  /// In en, this message translates to:
  /// **'new like received'**
  String get home_new_like_received;

  /// No description provided for @home_new_profiles_available.
  ///
  /// In en, this message translates to:
  /// **'new profiles available'**
  String get home_new_profiles_available;

  /// No description provided for @home_upgrade_to_platinum.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Platinum'**
  String get home_upgrade_to_platinum;

  /// No description provided for @home_prioritize_profile.
  ///
  /// In en, this message translates to:
  /// **'Prioritize your profile and get more matches.'**
  String get home_prioritize_profile;

  /// No description provided for @home_complete_profile_now.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile'**
  String get home_complete_profile_now;

  /// No description provided for @home_increase_matches_3x.
  ///
  /// In en, this message translates to:
  /// **'Get 3x more matches by adding your details.'**
  String get home_increase_matches_3x;

  /// No description provided for @home_add_education.
  ///
  /// In en, this message translates to:
  /// **'Add Education Details'**
  String get home_add_education;

  /// No description provided for @home_add_photos.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get home_add_photos;

  /// No description provided for @home_add_partner_prefs.
  ///
  /// In en, this message translates to:
  /// **'Add Partner Preferences'**
  String get home_add_partner_prefs;

  /// No description provided for @chat_no_conversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get chat_no_conversations;

  /// No description provided for @chat_start_connecting.
  ///
  /// In en, this message translates to:
  /// **'Start connecting with matches.'**
  String get chat_start_connecting;

  /// No description provided for @chat_search_button.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get chat_search_button;

  /// No description provided for @home_premium_label.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get home_premium_label;

  /// No description provided for @home_verified_profile.
  ///
  /// In en, this message translates to:
  /// **'Verified Profile'**
  String get home_verified_profile;

  /// No description provided for @home_action_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get home_action_no;

  /// No description provided for @home_action_view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get home_action_view;

  /// No description provided for @home_matches_for_you.
  ///
  /// In en, this message translates to:
  /// **'Matches For You'**
  String get home_matches_for_you;

  /// No description provided for @home_handpicked_interests.
  ///
  /// In en, this message translates to:
  /// **'Handpicked based on your interests'**
  String get home_handpicked_interests;

  /// No description provided for @home_filter_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get home_filter_all;

  /// No description provided for @home_filter_new.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get home_filter_new;

  /// No description provided for @home_filter_near_me.
  ///
  /// In en, this message translates to:
  /// **'Near Me'**
  String get home_filter_near_me;

  /// No description provided for @home_filter_verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get home_filter_verified;

  /// No description provided for @home_filter_online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get home_filter_online;

  /// No description provided for @gallery_delete_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Are You Sure That You Want To Delete This Image?'**
  String get gallery_delete_confirm_title;

  /// No description provided for @gallery_delete_confirm_nb.
  ///
  /// In en, this message translates to:
  /// **'**N.B. Deleting An Image Will Not Refund Your Remaining Gallery Capacity**'**
  String get gallery_delete_confirm_nb;

  /// No description provided for @gallery_add_new_image.
  ///
  /// In en, this message translates to:
  /// **'Add new image'**
  String get gallery_add_new_image;

  /// No description provided for @gallery_choose_file.
  ///
  /// In en, this message translates to:
  /// **'Choose file...'**
  String get gallery_choose_file;

  /// No description provided for @gallery_browse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get gallery_browse;

  /// No description provided for @gallery_verify_account_msg.
  ///
  /// In en, this message translates to:
  /// **'Please verify your account'**
  String get gallery_verify_account_msg;

  /// No description provided for @gallery_update_package_msg.
  ///
  /// In en, this message translates to:
  /// **'Please Update Your Package.'**
  String get gallery_update_package_msg;

  /// No description provided for @common_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get common_close;

  /// No description provided for @common_please_wait.
  ///
  /// In en, this message translates to:
  /// **'Please Wait'**
  String get common_please_wait;

  /// No description provided for @gallery_image_view_title.
  ///
  /// In en, this message translates to:
  /// **'Gallery Image View'**
  String get gallery_image_view_title;

  /// No description provided for @gallery_remaining_view_prefix.
  ///
  /// In en, this message translates to:
  /// **'Remaining Gallery Picture View: '**
  String get gallery_remaining_view_prefix;

  /// No description provided for @gallery_remaining_view_suffix.
  ///
  /// In en, this message translates to:
  /// **' times'**
  String get gallery_remaining_view_suffix;

  /// No description provided for @gallery_request_note.
  ///
  /// In en, this message translates to:
  /// **'N.B. Requesting to See This Member Gallery Picture Will Cost 1 From Remaining Gallery Picture View.'**
  String get gallery_request_note;

  /// No description provided for @gallery_send_request_btn.
  ///
  /// In en, this message translates to:
  /// **'Send Gallery Photo View Request'**
  String get gallery_send_request_btn;

  /// No description provided for @referral_screen_rewards_msg.
  ///
  /// In en, this message translates to:
  /// **'Share this code with your friends and earn rewards!'**
  String get referral_screen_rewards_msg;

  /// No description provided for @referral_stat_wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet Balance'**
  String get referral_stat_wallet;

  /// No description provided for @referral_stat_invited.
  ///
  /// In en, this message translates to:
  /// **'Invited Users'**
  String get referral_stat_invited;

  /// No description provided for @referral_stat_successful.
  ///
  /// In en, this message translates to:
  /// **'Successful'**
  String get referral_stat_successful;

  /// No description provided for @referral_stat_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get referral_stat_pending;

  /// No description provided for @referral_btn_withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get referral_btn_withdraw;

  /// No description provided for @referral_btn_share.
  ///
  /// In en, this message translates to:
  /// **'Share Code'**
  String get referral_btn_share;

  /// No description provided for @referral_header_invited.
  ///
  /// In en, this message translates to:
  /// **'People You Invited'**
  String get referral_header_invited;

  /// No description provided for @referral_msg_no_invited.
  ///
  /// In en, this message translates to:
  /// **'No invited users yet'**
  String get referral_msg_no_invited;

  /// No description provided for @referral_joined_on.
  ///
  /// In en, this message translates to:
  /// **'Joined on {date}'**
  String referral_joined_on(Object date);

  /// No description provided for @referral_status_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get referral_status_active;

  /// No description provided for @referral_copied_msg.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get referral_copied_msg;

  /// No description provided for @verify_title.
  ///
  /// In en, this message translates to:
  /// **'Profile Verification'**
  String get verify_title;

  /// No description provided for @verify_trust_header.
  ///
  /// In en, this message translates to:
  /// **'Get Verified ✔'**
  String get verify_trust_header;

  /// No description provided for @verify_trust_desc.
  ///
  /// In en, this message translates to:
  /// **'Verified profiles receive more matches and build higher trust with potential partners.'**
  String get verify_trust_desc;

  /// No description provided for @verify_benefit_visibility.
  ///
  /// In en, this message translates to:
  /// **'Higher search visibility'**
  String get verify_benefit_visibility;

  /// No description provided for @verify_benefit_responses.
  ///
  /// In en, this message translates to:
  /// **'More responses from serious members'**
  String get verify_benefit_responses;

  /// No description provided for @verify_benefit_badge.
  ///
  /// In en, this message translates to:
  /// **'Exclusive \"Trusted\" profile badge'**
  String get verify_benefit_badge;

  /// No description provided for @verify_steps_header.
  ///
  /// In en, this message translates to:
  /// **'Verification Steps'**
  String get verify_steps_header;

  /// No description provided for @verify_step_id.
  ///
  /// In en, this message translates to:
  /// **'Upload ID'**
  String get verify_step_id;

  /// No description provided for @verify_step_selfie.
  ///
  /// In en, this message translates to:
  /// **'Selfie'**
  String get verify_step_selfie;

  /// No description provided for @verify_step_review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get verify_step_review;

  /// No description provided for @verify_upload_desc.
  ///
  /// In en, this message translates to:
  /// **'Upload a clear document for faster approval.'**
  String get verify_upload_desc;

  /// No description provided for @verify_tap_to_upload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload photo'**
  String get verify_tap_to_upload;

  /// No description provided for @verify_status_header.
  ///
  /// In en, this message translates to:
  /// **'Verification Status'**
  String get verify_status_header;

  /// No description provided for @verify_status_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending Submission'**
  String get verify_status_pending;

  /// No description provided for @verify_status_desc.
  ///
  /// In en, this message translates to:
  /// **'Verification usually takes 24-48 hours.'**
  String get verify_status_desc;

  /// No description provided for @verify_submit_btn.
  ///
  /// In en, this message translates to:
  /// **'Submit Verification'**
  String get verify_submit_btn;

  /// No description provided for @verify_already_sent.
  ///
  /// In en, this message translates to:
  /// **'Verification request already sent.'**
  String get verify_already_sent;

  /// No description provided for @verify_submitting_msg.
  ///
  /// In en, this message translates to:
  /// **'Submitting verification...'**
  String get verify_submitting_msg;

  /// No description provided for @verify_enter_details.
  ///
  /// In en, this message translates to:
  /// **'Enter details'**
  String get verify_enter_details;

  /// No description provided for @verify_select_option.
  ///
  /// In en, this message translates to:
  /// **'Select option'**
  String get verify_select_option;

  /// No description provided for @verify_uploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get verify_uploaded;

  /// No description provided for @verify_step_1_title.
  ///
  /// In en, this message translates to:
  /// **'Proof of Identity'**
  String get verify_step_1_title;

  /// No description provided for @verify_select_id_type.
  ///
  /// In en, this message translates to:
  /// **'Select ID Type'**
  String get verify_select_id_type;

  /// No description provided for @verify_enter_id_number.
  ///
  /// In en, this message translates to:
  /// **'Enter ID Number'**
  String get verify_enter_id_number;

  /// No description provided for @verify_id_hint.
  ///
  /// In en, this message translates to:
  /// **'Ex: 1234 5678 9012'**
  String get verify_id_hint;

  /// No description provided for @verify_upload_id.
  ///
  /// In en, this message translates to:
  /// **'Upload ID Documents'**
  String get verify_upload_id;

  /// No description provided for @verify_front_side.
  ///
  /// In en, this message translates to:
  /// **'Front Side'**
  String get verify_front_side;

  /// No description provided for @verify_back_side.
  ///
  /// In en, this message translates to:
  /// **'Back Side'**
  String get verify_back_side;

  /// No description provided for @verify_step_2_title.
  ///
  /// In en, this message translates to:
  /// **'Live Selfie'**
  String get verify_step_2_title;

  /// No description provided for @verify_selfie_desc.
  ///
  /// In en, this message translates to:
  /// **'Take a clear selfie to verify your identity'**
  String get verify_selfie_desc;

  /// No description provided for @verify_selfie_instruction.
  ///
  /// In en, this message translates to:
  /// **'Ensure your face is well-lit and clearly visible'**
  String get verify_selfie_instruction;

  /// No description provided for @verify_step_3_title.
  ///
  /// In en, this message translates to:
  /// **'Review Details'**
  String get verify_step_3_title;

  /// No description provided for @verify_review_desc.
  ///
  /// In en, this message translates to:
  /// **'By submitting, you agree that the provided information is accurate and belongs to you.'**
  String get verify_review_desc;

  /// No description provided for @verify_submit_for_review.
  ///
  /// In en, this message translates to:
  /// **'Submit for Verification'**
  String get verify_submit_for_review;

  /// No description provided for @verify_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get verify_next;

  /// No description provided for @verify_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get verify_back;

  /// No description provided for @verify_upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get verify_upload;

  /// No description provided for @verify_id_type_label.
  ///
  /// In en, this message translates to:
  /// **'ID Type'**
  String get verify_id_type_label;

  /// No description provided for @verify_id_number_label.
  ///
  /// In en, this message translates to:
  /// **'ID Number'**
  String get verify_id_number_label;

  /// No description provided for @verify_documents_label.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get verify_documents_label;

  /// No description provided for @verify_attached.
  ///
  /// In en, this message translates to:
  /// **'Attached'**
  String get verify_attached;

  /// No description provided for @verify_missing.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get verify_missing;

  /// No description provided for @verify_error_id_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter your ID number'**
  String get verify_error_id_number;

  /// No description provided for @verify_error_id_front.
  ///
  /// In en, this message translates to:
  /// **'Please upload ID front side'**
  String get verify_error_id_front;

  /// No description provided for @verify_error_selfie.
  ///
  /// In en, this message translates to:
  /// **'Please upload a selfie'**
  String get verify_error_selfie;

  /// No description provided for @verify_error_failed.
  ///
  /// In en, this message translates to:
  /// **'Submission failed'**
  String get verify_error_failed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
