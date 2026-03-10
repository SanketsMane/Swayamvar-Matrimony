import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';

// Sanket: Centralized helper to calculate profile completeness score
class ProfileCompletenessHelper {
  static int calculate(AppState state) {
    double completeness = 0.10; // Base: Signup (10%)

    final profileData = state.accountState?.profileData;
    final ps = state.manageProfileCombineState;

    if (ps != null) {
      // 1. Profile Photo (15%)
      if (profileData?.memberPhoto != null) completeness += 0.15;

      // 2. Basic Information (10%)
      if (ps.basicInfoState?.basicInfo != null) completeness += 0.10;

      // 3. Introduction (5%)
      if (ps.introductionState?.introData != null) completeness += 0.05;

      // 4. Education (10%)
      if (ps.educationState?.list.isNotEmpty ?? false) completeness += 0.10;

      // 5. Career (10%)
      if (ps.careerState?.list.isNotEmpty ?? false) completeness += 0.10;

      // 6. Partner Expectations (10%)
      if (ps.partnerExpectationState?.partnerExpectationGetResponse?.data !=
          null) {
        completeness += 0.10;
      }

      // 7. Family Details (10%)
      if (ps.familyState?.familyGetResponse?.data != null) completeness += 0.10;

      // 8. Spiritual & Social (10%)
      if (ps.spiritualSocialState?.spiritualSocialGetResponse?.data != null) {
        completeness += 0.10;
      }

      // 9. Physical Attributes (5%)
      if (ps.physicalAttrState?.physicalAttrData != null) completeness += 0.05;

      // 10. Hobbies & Interests (5%)
      if (ps.hobbiesInterestState?.hobbiesInterestData != null) {
        completeness += 0.05;
      }
    }

    // Ensure we return a value between 0 and 100
    int percent = (completeness * 100).toInt();
    return percent.clamp(0, 100);
  }
}
