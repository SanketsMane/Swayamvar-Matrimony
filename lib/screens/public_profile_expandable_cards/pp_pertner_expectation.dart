import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

class PP_PartnerExpectation extends StatelessWidget {
  const PP_PartnerExpectation({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder:
          (_, state) =>
              state.publicProfileState!.partnerExpectation != null
                  ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.public_profile_general,
                            data:
                                state
                                    .publicProfileState!
                                    .partnerExpectation
                                    .general,
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.public_profile_residency_country,
                            data:
                                state
                                    .publicProfileState!
                                    .partnerExpectation
                                    .residenceCountryId ??
                                "",
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.public_profile_height,
                            data:
                                "${state.publicProfileState!.partnerExpectation.height.toString() ?? ''} ft",
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.public_profile_weight,
                            data:
                                state
                                    .publicProfileState!
                                    .partnerExpectation
                                    .weight
                                    .toString() ??
                                '',
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.public_profile_religion,
                            data:
                                state
                                    .publicProfileState!
                                    .partnerExpectation
                                    .religionId ??
                                "",
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.manage_profile_caste,
                            data:
                                state
                                    .publicProfileState!
                                    .partnerExpectation
                                    .casteId ??
                                "",
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.manage_profile_sub_caste,
                            data:
                                state
                                    .publicProfileState!
                                    .partnerExpectation
                                    .subCasteId ??
                                "",
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.public_profile_marital_status,
                            data:
                                "${state.publicProfileState!.partnerExpectation.maritalStatus ?? ''}",
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.manage_profile_children_acceptable,
                            data:
                                state
                                            .publicProfileState!
                                            .partnerExpectation
                                            .childrenAcceptable ==
                                        'dose_not_matter'
                                    ? 'Does not matter'
                                    : state
                                        .publicProfileState!
                                        .partnerExpectation
                                        .childrenAcceptable,
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.public_profile_Lang,
                            data:
                                "${state.publicProfileState!.partnerExpectation.language ?? ''}",
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.manage_profile_education,
                            data:
                                "${state.publicProfileState!.partnerExpectation.education ?? ""}",
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.manage_profile_profession,
                            data:
                                "${state.publicProfileState!.partnerExpectation.profession ?? ''}",
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.manage_profile_smoking_acceptable,
                            data:
                                state
                                            .publicProfileState!
                                            .partnerExpectation
                                            .smokingAcceptable ==
                                        'dose_not_matter'
                                    ? 'Does not matter'
                                    : state
                                        .publicProfileState!
                                        .partnerExpectation
                                        .smokingAcceptable,
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.manage_profile_drinking_acceptable,
                            data:
                                state
                                            .publicProfileState!
                                            .partnerExpectation
                                            .drinkingAcceptable ==
                                        'dose_not_matter'
                                    ? 'Does not matter'
                                    : state
                                        .publicProfileState!
                                        .partnerExpectation
                                        .drinkingAcceptable,
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.manage_profile_diet,
                            data:
                                "${state.publicProfileState!.partnerExpectation.diet == 'dose_not_matter' ? 'Does not matter' : state.publicProfileState!.partnerExpectation.diet}",
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.public_profile_body_type,
                            data:
                                "${state.publicProfileState!.partnerExpectation.bodyType ?? ''}",
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.manage_profile_personal_value,
                            data:
                                "${state.publicProfileState!.partnerExpectation.personalValue ?? ''}",
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.manage_profile_manglik,
                            data:
                                "${state.publicProfileState!.partnerExpectation.manglik == 'dose_not_matter' ? 'Does not matter' : state.publicProfileState!.partnerExpectation.manglik}",
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.manage_profile_preferred_country,
                            data:
                                state
                                    .publicProfileState!
                                    .partnerExpectation
                                    .preferredCountryId ??
                                "",
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.manage_profile_preferred_state,
                            data:
                                state
                                    .publicProfileState!
                                    .partnerExpectation
                                    .preferredStateId ??
                                "",
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.manage_profile_family_value,
                            data:
                                state
                                    .publicProfileState!
                                    .partnerExpectation
                                    .familyValueId ??
                                "",
                          ),
                          const SizedBox(height: 10),
                          buildRow(
                            context: context,
                            localization_text:
                                AppLocalizations.of(
                                  context,
                                )!.public_profile_complexion,
                            data:
                                "${state.publicProfileState!.partnerExpectation.complexion ?? ''}",
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  )
                  : Center(
                    child: Text(
                      AppLocalizations.of(context)!.common_no_data,
                      style: const TextStyle(height: 10),
                    ),
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
