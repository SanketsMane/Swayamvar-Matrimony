import 'dart:io';
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
  SetVerifyIdFront({this.payload});
}

class SetVerifyIdBack {
  File? payload;
  SetVerifyIdBack({this.payload});
}

class SetVerifySelfie {
  File? payload;
  SetVerifySelfie({this.payload});
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

ThunkAction<AppState> pickVerifyImage(String type) {
  return (Store<AppState> store) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: type == 'selfie' ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 85,
    );
    if (image != null) {
      File file = File(image.path);
      if (type == 'front') {
        store.dispatch(SetVerifyIdFront(payload: file));
      } else if (type == 'back') {
        store.dispatch(SetVerifyIdBack(payload: file));
      } else if (type == 'selfie') {
        store.dispatch(SetVerifySelfie(payload: file));
      }
    }
  };
}

ThunkAction<AppState> submitVerifyFormAction(BuildContext context) {
  return (Store<AppState> store) async {
    final l = AppLocalizations.of(context)!;
    final state = store.state.userVerifyState!;

    if (state.idNumber.isEmpty) {
      store.dispatch(
        ShowMessageAction(
          msg: l.verify_error_id_number,
          color: MyTheme.failure,
        ),
      );
      return;
    }

    // Sanket: Images (idFront, idBack, selfie) are optional — submit whatever the user provides

    store.dispatch(SetVerifySubmitting(true));

    try {
      var res = await VerifyRepository().submitVerifyForm(
        idType: state.idType,
        idNumber: state.idNumber,
        idFront: state.idFront,
        idBack: state.idBack,
        selfie: state.selfie,
      );

      store.dispatch(
        ShowMessageAction(
          msg: res.message,
          color: res.result ? MyTheme.success : MyTheme.failure,
        ),
      );

      if (res.result) {
        store.dispatch(getUserIsApproveAction());
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
      var data = isApprovedResponseFromJson(response.body);
      store.dispatch(IsApprovedAction(payload: data));
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      store.dispatch(SetVerifyIsFetching(false));
    }
  };
}
