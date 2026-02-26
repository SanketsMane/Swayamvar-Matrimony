import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

class LangText {
  BuildContext? context;

  LangText({this.context});

  AppLocalizations getLocal() {
    return AppLocalizations.of(context!)!;
  }
}
