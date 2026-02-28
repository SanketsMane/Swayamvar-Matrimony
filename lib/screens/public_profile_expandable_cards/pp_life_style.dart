import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';

class PP_LifeStyle extends StatelessWidget {
  const PP_LifeStyle({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder:
          (_, state) =>
              state.publicProfileState!.lifeStyle != null
                  ? Column(
                    children: [
                      buildRow(
                        context: context,
                        localization_text:
                            AppLocalizations.of(context)!.manage_profile_diet,
                        data:
                            "${state.publicProfileState!.lifeStyle.diet ?? ''}",
                      ),
                      SizedBox(height: 10),
                      buildRow(
                        context: context,
                        localization_text:
                            AppLocalizations.of(context)!.manage_profile_smoke,
                        data:
                            "${state.publicProfileState!.lifeStyle.smoke ?? ''}",
                      ),
                      SizedBox(height: 10),
                      buildRow(
                        context: context,
                        localization_text:
                            AppLocalizations.of(context)!.manage_profile_drink,
                        data:
                            "${state.publicProfileState!.lifeStyle.drink ?? ''}",
                      ),
                      SizedBox(height: 10),
                      buildRow(
                        context: context,
                        localization_text:
                            AppLocalizations.of(
                              context,
                            )!.manage_profile_living_with,
                        data:
                            "${state.publicProfileState!.lifeStyle.livingWith ?? ''}",
                      ),
                    ],
                  )
                  : Center(
                    child: Text(AppLocalizations.of(context)!.common_no_data),
                  ),
    );
  }

  Row buildRow({
    BuildContext? context,
    required localization_text,
    required data,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(localization_text, style: Styles.regular_gull_grey_12),
        ),
        Expanded(child: Text(data)),
      ],
    );
  }
}
