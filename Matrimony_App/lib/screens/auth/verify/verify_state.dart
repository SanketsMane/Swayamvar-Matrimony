import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

// Sanket: UserVerifyState holds all 3-step verification data
class UserVerifyState {
  bool? isFetching;
  bool? isApprove;
  bool? verificationInfo;

  // Sanket: Tracks admin decision — null | pending | approved | rejected | query
  String? verificationStatus;
  // Sanket: Admin message shown to user on rejection or query
  String? adminMessage;

  // 3-Step Verification Data
  String idType;
  String idNumber;

  // Sanket: Controller keeps TextFormField in sync with Redux state across re-navigations (Bug 2)
  TextEditingController idNumberController;

  File? idFront;
  File? idBack;
  File? selfie;

  // Sanket: Byte buffers for Web rendering — Flutter Web cannot render File via Image.file (Bug 3)
  Uint8List? idFrontBytes;
  Uint8List? idBackBytes;
  Uint8List? selfieBytes;

  bool isSubmitting;

  UserVerifyState({
    this.isFetching,
    this.isApprove,
    this.verificationInfo,
    this.verificationStatus,
    this.adminMessage,
    this.idType = 'Aadhaar',
    this.idNumber = '',
    TextEditingController? idNumberController,
    this.idFront,
    this.idBack,
    this.selfie,
    this.idFrontBytes,
    this.idBackBytes,
    this.selfieBytes,
    this.isSubmitting = false,
  }) : idNumberController = idNumberController ?? TextEditingController();

  UserVerifyState.initialState()
      : isApprove = false,
        verificationInfo = false,
        isFetching = false,
        verificationStatus = null,
        adminMessage = null,
        idType = 'Aadhaar',
        idNumber = '',
        idNumberController = TextEditingController(),
        isSubmitting = false;

  @override
  String toString() {
    return 'VerifyState{isFetching: $isFetching, isApprove: $isApprove, status: $verificationStatus}';
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
