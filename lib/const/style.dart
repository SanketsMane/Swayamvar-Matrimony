import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:flutter/material.dart';

var white = MyTheme.white;
var green = MyTheme.green;
var arsenic = MyTheme.arsenic;
var light_grey = MyTheme.light_grey;
var gull_grey = MyTheme.gull_grey;
var storm_grey = MyTheme.storm_grey;
var app_accent_color = MyTheme.app_accent_color;
var solitude = MyTheme.solitude;

class Styles {
  // Sanket: Production Typography System
  // NOTE: Tiro, Mukta, NotoSans (plain) files not yet in fonts/ dir.
  // All fall back to Noto Sans Devanagari until TTF assets are added.
  static const String font_ui = 'Noto Sans Devanagari'; // Body text
  static const String font_heading =
      'Noto Sans Devanagari'; // Will switch to Tiro when file added
  static const String font_button =
      'Noto Sans Devanagari'; // Will switch to Noto Sans Medium when file added
  static const String font_profile =
      'Noto Sans Devanagari'; // Will switch to Mukta when file added
  static const String font_fallback = 'Poppins';

  // Design Tokens: Headings — bold weight differentiates from body
  static TextStyle h1 = const TextStyle(
    color: MyTheme.text_primary,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: font_ui,
  );

  static TextStyle h2 = const TextStyle(
    color: MyTheme.text_primary,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFamily: font_ui,
  );

  // Design Tokens: Body & UI (Noto Sans Devanagari)
  static TextStyle body = TextStyle(
    color: MyTheme.text_primary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: font_ui,
  );

  static TextStyle caption = TextStyle(
    color: MyTheme.text_secondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: font_ui,
  );

  // Design Tokens: Buttons — medium weight
  static const TextStyle buttonText = TextStyle(
    color: MyTheme.white,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: font_ui,
  );

  // Design Tokens: Profile Names (Mukta SemiBold)
  static TextStyle profileName = TextStyle(
    color: MyTheme.text_primary,
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    fontFamily: font_profile,
  );

  // Design Tokens: Spacing
  static const double s8 = 8.0;
  static const double s16 = 16.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;

  // Design Tokens: Colors & Shared UI
  static const Color app_accent_color = MyTheme.primary;
  static Color solitude = MyTheme.background;
  static Color zircon = MyTheme.border;
  static Color light_grey = MyTheme.text_secondary;
  static Color arsenic = MyTheme.text_primary;
  static Color storm_grey = MyTheme.text_secondary;
  static Color gull_grey = MyTheme.text_secondary;
  static Color grey_153 = MyTheme.text_secondary;
  static Color icon_premium_color = MyTheme.primary;
  static Color medium_sea_green = MyTheme.success;
  static Color very_light_grey = MyTheme.border;
  static Color luxury_gold = MyTheme.primary;
  static Color silver = const Color(0xFFC0C0C0);
  static const double br_card = 16.0;
  static const double br_btn = 12.0;
  static const double br_profile = 16.0;
  static const double br_pill = 20.0;

  // Legacy Style Mapping (Sanket: Re-mapped to use new font pairings)
  static TextStyle regular_gull_grey_10 = caption.copyWith(fontSize: 10);
  static TextStyle regular_white_10 = caption.copyWith(
    fontSize: 10,
    color: MyTheme.white,
  );
  static TextStyle italic_app_accent_10_underline = caption.copyWith(
    fontSize: 10,
    color: MyTheme.primary,
    fontStyle: FontStyle.italic,
    decoration: TextDecoration.underline,
  );
  static TextStyle bold_white_10 = caption.copyWith(
    fontSize: 10,
    color: MyTheme.white,
    fontWeight: FontWeight.bold,
  );

  static TextStyle regular_arsenic_11 = caption.copyWith(
    fontSize: 11,
    color: MyTheme.text_primary,
  );

  static TextStyle regular_white_12 = caption.copyWith(color: MyTheme.white);
  static TextStyle regular_gull_grey_12 = caption;
  static TextStyle regular_app_accent_12 = caption.copyWith(
    color: MyTheme.primary,
  );
  static TextStyle regular_arsenic_12 = caption.copyWith(
    color: MyTheme.text_primary,
  );
  static TextStyle regular_light_grey_12 = caption;
  static TextStyle regular_storm_grey_12 = caption;
  static TextStyle regular_solitude_12 = caption.copyWith(
    color: MyTheme.background,
  );
  static TextStyle bold_white_12 = buttonText.copyWith(fontSize: 12);
  static TextStyle bold_arsenic_12 = caption.copyWith(
    color: MyTheme.text_primary,
    fontWeight: FontWeight.bold,
  );
  static TextStyle bold_app_accent_12 = buttonText.copyWith(
    color: MyTheme.primary,
    fontSize: 12,
  );
  static TextStyle bold_storm_grey_12 = caption.copyWith(
    fontWeight: FontWeight.bold,
  );
  static TextStyle bold_solitude_12 = caption.copyWith(
    color: MyTheme.background,
    fontWeight: FontWeight.bold,
  );
  static TextStyle medium_white_12 = buttonText.copyWith(fontSize: 12);

  static TextStyle regular_white_14 = body.copyWith(color: MyTheme.white);
  static TextStyle regular_arsenic_14 = body;
  static TextStyle regular_app_accent_14 = body.copyWith(
    color: MyTheme.primary,
  );
  static TextStyle bold_white_14 = buttonText;
  static TextStyle bold_arsenic_14 = body.copyWith(fontWeight: FontWeight.bold);
  static TextStyle bold_app_accent_14 = buttonText.copyWith(
    color: MyTheme.primary,
  );
  static TextStyle medium_arsenic_14 = body.copyWith(
    fontWeight: FontWeight.w600,
  );
  static TextStyle italic_white_14 = body.copyWith(
    color: MyTheme.white,
    fontStyle: FontStyle.italic,
  );

  static TextStyle regular_gull_grey_16 = body.copyWith(fontSize: 16);
  static TextStyle regular_gull_grey_14 = body.copyWith(
    color: MyTheme.text_secondary,
  );
  static TextStyle bold_white_16 = buttonText.copyWith(fontSize: 16);
  static TextStyle bold_arsenic_16 = h2.copyWith(fontSize: 16);
  static TextStyle bold_app_accent_16 = buttonText.copyWith(
    color: MyTheme.primary,
    fontSize: 16,
  );

  static TextStyle bold_app_accent_20 = h1.copyWith(
    color: MyTheme.primary,
    fontSize: 20,
  );

  static TextStyle medium_white_22 = h1.copyWith(
    color: MyTheme.white,
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );
  static TextStyle bold_white_22 = h1.copyWith(
    color: MyTheme.white,
    fontSize: 22,
  );
  static TextStyle bold_app_accent_22 = h1.copyWith(
    color: MyTheme.primary,
    fontSize: 22,
  );

  static TextStyle bold_white_30 = h1.copyWith(
    color: MyTheme.white,
    fontSize: 30,
  );
  static TextStyle bold_arsenic_30 = h1.copyWith(fontSize: 30);
  static TextStyle bold_app_accent_30 = h1.copyWith(
    color: MyTheme.primary,
    fontSize: 30,
  );

  static TextStyle bold_white_36 = h1.copyWith(
    color: MyTheme.white,
    fontSize: 36,
  );

  static TextStyle luxury_heading_24 = h1;
  static TextStyle premium_welcome_24 = h1.copyWith(
    fontWeight: FontWeight.w800,
  );
  static TextStyle premium_sub_14 = body.copyWith(
    color: MyTheme.text_secondary,
  );

  static TextStyle italic_white_12 = caption.copyWith(
    color: MyTheme.white,
    fontStyle: FontStyle.italic,
  );
  static TextStyle regular_arsenic_14_line_through = body.copyWith(
    decoration: TextDecoration.lineThrough,
  );
  static TextStyle bold_white_14_line_through = body.copyWith(
    color: MyTheme.white,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.lineThrough,
  );
  static TextStyle medium_white_16 = h2.copyWith(
    color: MyTheme.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static TextStyle bold_green_12 = caption.copyWith(
    color: MyTheme.success,
    fontWeight: FontWeight.bold,
  );
  static TextStyle medium_gull_grey_14 = body.copyWith(
    color: MyTheme.text_secondary,
    fontWeight: FontWeight.w500,
  );
  static TextStyle medium_zircon_14 = body.copyWith(
    color: MyTheme.border,
    fontWeight: FontWeight.w500,
  );
  static TextStyle bold_gull_grey_12 = caption.copyWith(
    fontWeight: FontWeight.bold,
  );
  static TextStyle bold_storm_grey_20 = h1.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static TextStyle regular_solitude_12_line_through = caption.copyWith(
    color: MyTheme.background,
    decoration: TextDecoration.lineThrough,
  );
  static TextStyle regular_white_12_line_through = caption.copyWith(
    color: MyTheme.white,
    decoration: TextDecoration.lineThrough,
  );
  static TextStyle medium_arsenic_12_line_through = caption.copyWith(
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.lineThrough,
  );
  static TextStyle italic_light_grey_12 = caption.copyWith(
    fontStyle: FontStyle.italic,
  );

  static LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [MyTheme.gradient_color_1, MyTheme.gradient_color_2],
  );

  static LinearGradient buildLinearGradient({required begin, required end}) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [MyTheme.gradient_color_1, MyTheme.gradient_color_2],
    );
  }

  static BoxDecoration cardDecoration = BoxDecoration(
    color: MyTheme.white,
    borderRadius: BorderRadius.circular(br_card),
    border: Border.all(color: MyTheme.border),
    boxShadow: [
      BoxShadow(
        color: MyTheme.black.withOpacity(0.04),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration glassmorphism = BoxDecoration(
    color: MyTheme.white.withOpacity(0.1),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: MyTheme.white.withOpacity(0.2)),
  );
}
