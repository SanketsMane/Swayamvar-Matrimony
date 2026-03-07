import 'package:active_matrimonial_flutter_app/screens/auth/verify/verify_action.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/verify/verify_state.dart';

UserVerifyState? userVerifyReducer(UserVerifyState state, dynamic action) {
  if (action is SetVerifyIdType) {
    return state..idType = action.payload;
  }
  if (action is SetVerifyIdNumber) {
    return state..idNumber = action.payload;
  }
  if (action is SetVerifyIdFront) {
    return state..idFront = action.payload;
  }
  if (action is SetVerifyIdBack) {
    return state..idBack = action.payload;
  }
  if (action is SetVerifySelfie) {
    return state..selfie = action.payload;
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
