import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:flutter/material.dart';

class AiBioService {
  /// Generates a professional matrimony bio based on user profile data.
  /// Currently uses a sophisticated template system to provide an "AI-like" experience
  /// without requiring an external API key immediately. 
  /// Sanket: This can be extended to call Gemini/OpenAI in the future.
  static String generateBio(AppState state) {
    final basicInfo = state.manageProfileCombineState?.basicInfoState?.basicInfo;
    final name = basicInfo?.firsName ?? "Someone";
    final gender = basicInfo?.gender?.toLowerCase() == "male" ? "Man" : "Woman";
    
    // Get career info if available
    String profession = "Professional";
    final careerList = state.manageProfileCombineState?.careerState?.list;
    if (careerList != null && careerList.isNotEmpty) {
      profession = careerList.first.designation_controller.text;
    }

    // Determine age
    int age = 25; // Default fallback
    if (basicInfo?.dateOfBirth != null) {
      try {
        final dob = DateTime.parse(basicInfo!.dateOfBirth.toString());
        age = DateTime.now().year - dob.year;
      } catch (e) {
        debugPrint("Error calculating age: $e");
      }
    }

    // Templates for a premium feel
    final templates = [
      "I am a $age-year-old $profession $gender who values family traditions and modern outlook. I'm looking for a partner who is understanding, career-oriented, and shares similar values. Let's start a beautiful journey together.",
      "Hello! I'm $name, a dedicated $profession. I believe in mutual respect and growth in a relationship. I'm seeking someone with whom I can share life's joys and challenges. Family is my priority, and I hope to find a like-minded companion.",
      "As a $profession, I enjoy my work but also cherish quality time with loved ones. I am a $gender of simple tastes and high values. I'm looking for a life partner who is caring, honest, and ready to build a happy home.",
    ];

    // Pick a template based on name length for some variability
    return templates[name.length % templates.length];
  }
}
