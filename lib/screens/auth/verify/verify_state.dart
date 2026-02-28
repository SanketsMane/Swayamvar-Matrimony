import 'dart:io';

class UserVerifyState {
  bool? isFetching;
  bool? isApprove;
  bool? verificationInfo;

  // 3-Step Verification Data
  String idType = 'Aadhaar';
  String idNumber = '';
  File? idFront;
  File? idBack;
  File? selfie;

  bool isSubmitting = false;

  UserVerifyState({
    this.isFetching,
    this.isApprove,
    this.verificationInfo,
    this.idType = 'Aadhaar',
    this.idNumber = '',
    this.idFront,
    this.idBack,
    this.selfie,
    this.isSubmitting = false,
  });

  UserVerifyState.initialState()
    : isApprove = false,
      verificationInfo = false,
      isFetching = false,
      isSubmitting = false;

  @override
  String toString() {
    return 'VerifyState{isFetching: $isFetching, isApprove: $isApprove, isSubmitting: $isSubmitting}';
  }
}

// model verify
class VerificationModel<T> {
  String? key, type, title;
  T data;
  List<dynamic>? options;

  VerificationModel({
    required this.key,
    required this.type,
    required this.title,
    required this.data,
    this.options,
  });
}
