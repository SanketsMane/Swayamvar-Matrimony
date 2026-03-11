import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:active_matrimonial_flutter_app/helpers/main_helpers.dart';
import 'package:active_matrimonial_flutter_app/models_response/verification_form/is_approved_response.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/repository/verify_repository.dart';
import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

class SetVerifyIdType {
  String payload;
  SetVerifyIdType({required this.payload});
}

class SetVerifyIdNumber {
  String payload;
  SetVerifyIdNumber({required this.payload});
}

class SetVerifyIdFront {
  File? payload;
  Uint8List? bytes; // Sanket: Web bytes for Image.memory rendering (Bug 3)
  SetVerifyIdFront({this.payload, this.bytes});
}

class SetVerifyIdBack {
  File? payload;
  Uint8List? bytes; // Sanket: Web bytes for Image.memory rendering (Bug 3)
  SetVerifyIdBack({this.payload, this.bytes});
}

class SetVerifySelfie {
  File? payload;
  Uint8List? bytes; // Sanket: Web bytes for Image.memory rendering (Bug 3)
  SetVerifySelfie({this.payload, this.bytes});
}

class SetVerifySubmitting {
  bool payload;
  SetVerifySubmitting(this.payload);
}

class IsApprovedAction {
  IsApprovedResponse? payload;
  IsApprovedAction({this.payload});
}

class SetVerifyIsFetching {
  bool payload;
  SetVerifyIsFetching(this.payload);
}

// Sanket: Bug 8 — Use gallery on Web (camera unsupported), and store bytes for Web rendering (Bug 3)
ThunkAction<AppState> pickVerifyImage(String type) {
  return (Store<AppState> store) async {
    final ImagePicker picker = ImagePicker();

    // Sanket: On Web, camera is not supported — always use gallery
    final ImageSource source =
        (!kIsWeb && type == 'selfie') ? ImageSource.camera : ImageSource.gallery;

    final XFile? image = await picker.pickImage(
      source: source,
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 85,
    );

    if (image != null) {
      // Sanket: On Web, read bytes for Image.memory; on mobile use File (Bug 3)
      final Uint8List? bytes = kIsWeb ? await image.readAsBytes() : null;
      final File file = File(image.path);

      if (type == 'front') {
        store.dispatch(SetVerifyIdFront(payload: file, bytes: bytes));
      } else if (type == 'back') {
        store.dispatch(SetVerifyIdBack(payload: file, bytes: bytes));
      } else if (type == 'selfie') {
        store.dispatch(SetVerifySelfie(payload: file, bytes: bytes));
      }
    }
  };
}

ThunkAction<AppState> submitVerifyFormAction(BuildContext context) {
  return (Store<AppState> store) async {
    final l = AppLocalizations.of(context)!;
    final state = store.state.userVerifyState!;

    // Sanket: Validate ID number before submitting (Bug 6 — validation at submit level)
    if (state.idNumber.trim().isEmpty) {
      store.dispatch(
        ShowMessageAction(
          msg: l.verify_error_id_number,
          color: MyTheme.failure,
        ),
      );
      return;
    }

    store.dispatch(SetVerifySubmitting(true));

    try {
      var res = await VerifyRepository().submitVerifyForm(
        idType: state.idType,
        idNumber: state.idNumber.trim(),
        idFront: kIsWeb ? null : state.idFront,
        idBack: kIsWeb ? null : state.idBack,
        selfie: kIsWeb ? null : state.selfie,
        idFrontBytes: kIsWeb ? state.idFrontBytes : null,
        idBackBytes: kIsWeb ? state.idBackBytes : null,
        selfieBytes: kIsWeb ? state.selfieBytes : null,
      );

      store.dispatch(
        ShowMessageAction(
          msg: res.message,
          color: res.result ? MyTheme.success : MyTheme.failure,
        ),
      );

      if (res.result) {
        // Sanket: Bug 9 — Guard before is-approved call
        if (getToken != null && getToken!.isNotEmpty) {
          store.dispatch(getUserIsApproveAction());
        }
        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      store.dispatch(
        ShowMessageAction(
          msg: "${l.verify_error_failed}: ${e.toString()}",
          color: MyTheme.failure,
        ),
      );
    } finally {
      store.dispatch(SetVerifySubmitting(false));
    }
  };
}

ThunkAction<AppState> getUserIsApproveAction() {
  return (Store<AppState> store) async {
    // Sanket: Bug 9 — Guard against missing token
    if (getToken == null || getToken!.isEmpty) {
      debugPrint("Sanket: getUserIsApproveAction — token is empty, skipping.");
      return;
    }
    store.dispatch(SetVerifyIsFetching(true));
    try {
      var baseUrl = "${AppConfig.BASE_URL}/member/is-approved";
      var response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $getToken",
        },
      );
      if (response.statusCode == 200) {
        var data = isApprovedResponseFromJson(response.body);
        store.dispatch(IsApprovedAction(payload: data));
      } else {
        debugPrint("Sanket: getUserIsApproveAction — HTTP ${response.statusCode}");
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      store.dispatch(SetVerifyIsFetching(false));
    }
  };
}
