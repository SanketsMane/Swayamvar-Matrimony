import 'package:flutter/cupertino.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

class LangText {
  BuildContext context;
  late AppLocalizations local;

  LangText(this.context) {
    local = AppLocalizations.of(context)!;
  }
}
