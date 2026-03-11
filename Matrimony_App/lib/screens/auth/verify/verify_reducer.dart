import 'package:active_matrimonial_flutter_app/screens/auth/verify/verify_action.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/verify/verify_state.dart';

// Sanket: Reducer handles all verify state mutations
UserVerifyState? userVerifyReducer(UserVerifyState state, dynamic action) {
  if (action is SetVerifyIdType) {
    return state..idType = action.payload;
  }
  if (action is SetVerifyIdNumber) {
    // Sanket: Bug 2 — sync controller text when dispatching from action
    state.idNumberController.text = action.payload;
    return state..idNumber = action.payload;
  }
  if (action is SetVerifyIdFront) {
    return state
      ..idFront = action.payload
      ..idFrontBytes = action.bytes; // Sanket: Bug 3 — store Web bytes
  }
  if (action is SetVerifyIdBack) {
    return state
      ..idBack = action.payload
      ..idBackBytes = action.bytes; // Sanket: Bug 3 — store Web bytes
  }
  if (action is SetVerifySelfie) {
    return state
      ..selfie = action.payload
      ..selfieBytes = action.bytes; // Sanket: Bug 3 — store Web bytes
  }
  if (action is SetVerifySubmitting) {
    return state..isSubmitting = action.payload;
  }
  if (action is IsApprovedAction) {
    return state
      ..isApprove = action.payload!.isApproved == 1
      ..verificationInfo = action.payload!.verificationInfo
      ..verificationStatus = action.payload!.verificationStatus
      ..adminMessage = action.payload!.adminMessage;
  }
  if (action is SetVerifyIsFetching) {
    return state..isFetching = action.payload;
  }
  return state;
}
