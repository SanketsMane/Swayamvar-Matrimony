import 'package:active_matrimonial_flutter_app/components/common_app_bar_manageprofile.dart';
import 'package:active_matrimonial_flutter_app/components/common_input.dart';
import 'package:active_matrimonial_flutter_app/components/common_widget.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/device_info.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import '../../redux/libs/manage_profile/manage_profile_middleware/manage_profile_update_middlewares.dart';

class AstronomicInformation extends StatefulWidget {
  const AstronomicInformation({super.key});

  @override
  State<AstronomicInformation> createState() => _AstronomicInformationState();
}

class _AstronomicInformationState extends State<AstronomicInformation> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _sunController = TextEditingController(
    text:
        store
                    .state
                    .manageProfileCombineState!
                    .astronomicState!
                    .astronomicGetResponse!
                    .result ==
                false
            ? ""
            : store
                    .state
                    .manageProfileCombineState!
                    .astronomicState!
                    .astronomicGetResponse
                    ?.data
                    ?.sunSign ??
                "",
  );
  final TextEditingController _moonController = TextEditingController(
    text:
        store
                    .state
                    .manageProfileCombineState!
                    .astronomicState!
                    .astronomicGetResponse!
                    .result ==
                false
            ? ""
            : store
                    .state
                    .manageProfileCombineState!
                    .astronomicState!
                    .astronomicGetResponse
                    ?.data
                    ?.moonSign ??
                "",
  );

  final TextEditingController _timeController = TextEditingController(
    text:
        store
                    .state
                    .manageProfileCombineState!
                    .astronomicState!
                    .astronomicGetResponse!
                    .result ==
                false
            ? ""
            : store
                    .state
                    .manageProfileCombineState!
                    .astronomicState!
                    .astronomicGetResponse
                    ?.data
                    ?.timeOfBirth ??
                "",
  );

  final TextEditingController _cityofBirthController = TextEditingController(
    text:
        store
                    .state
                    .manageProfileCombineState!
                    .astronomicState!
                    .astronomicGetResponse!
                    .result ==
                false
            ? ""
            : store
                    .state
                    .manageProfileCombineState!
                    .astronomicState!
                    .astronomicGetResponse
                    ?.data
                    ?.cityOfBirth ??
                "",
  );

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: MyTheme.primary,
            colorScheme: const ColorScheme.light(primary: MyTheme.primary),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  Map<String, String> getZodiacMap(BuildContext context) {
    return {
      "Aries": AppLocalizations.of(context)!.astro_sign_aries,
      "Taurus": AppLocalizations.of(context)!.astro_sign_taurus,
      "Gemini": AppLocalizations.of(context)!.astro_sign_gemini,
      "Cancer": AppLocalizations.of(context)!.astro_sign_cancer,
      "Leo": AppLocalizations.of(context)!.astro_sign_leo,
      "Virgo": AppLocalizations.of(context)!.astro_sign_virgo,
      "Libra": AppLocalizations.of(context)!.astro_sign_libra,
      "Scorpio": AppLocalizations.of(context)!.astro_sign_scorpio,
      "Sagittarius": AppLocalizations.of(context)!.astro_sign_sagittarius,
      "Capricorn": AppLocalizations.of(context)!.astro_sign_capricorn,
      "Aquarius": AppLocalizations.of(context)!.astro_sign_aquarius,
      "Pisces": AppLocalizations.of(context)!.astro_sign_pisces,
    };
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder:
          (_, state) => Scaffold(
            appBar: CommonAppBarManageProfile(
              text:
                  AppLocalizations.of(context)!.manage_profile_astronomic_info,
            ).build(context),
            body: SingleChildScrollView(
              child:
                  state.manageProfileCombineState!.astronomicState!.isloading ==
                          false
                      ? SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Const.kPaddingHorizontal,
                            vertical: Const.kPaddingVertical,
                          ),
                          child: Column(
                            children: [
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    buildAstronomicInformation(context, state),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : CommonWidget.circularIndicator,
            ),
          ),
    );
  }

  Widget buildAstronomicInformation(BuildContext context, AppState state) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildtitle(context, state),
          buildsun(context, state),
          buildmoon(context, state),
          buildtimeofbirth(context, state),
          build_city_birth(context, state),
          const SizedBox(height: 40),
          InkWell(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              if (!_formKey.currentState!.validate()) {
              } else {
                store.dispatch(
                  astronomicUpdateMiddleware(
                    sunsign: _sunController.text,
                    moonsign: _moonController.text,
                    time: _timeController.text,
                    city: _cityofBirthController.text,
                  ),
                );
              }
            },
            child: Container(
              height: 45,
              width: DeviceInfo(context).width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: const Alignment(0.8, 1),
                  colors: [MyTheme.gradient_color_1, MyTheme.gradient_color_2],
                ),
                borderRadius: const BorderRadius.all(Radius.circular(6.0)),
              ),
              child: Center(
                child:
                    state
                                .manageProfileCombineState!
                                .astronomicState!
                                .pageloader ==
                            false
                        ? Text(
                          AppLocalizations.of(context)!.save_change_btn_text,
                          style: Styles.bold_white_14,
                        )
                        : CommonWidget.circularIndicator,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildtitle(BuildContext context, AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.manage_profile_your_astronomic_info,
          style: Styles.bold_app_accent_14,
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget buildsun(BuildContext context, AppState state) {
    Map<String, String> signsMap = getZodiacMap(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${AppLocalizations.of(context)!.manage_profile_sun_sign} *",
          style: Styles.bold_arsenic_12,
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: signsMap.containsKey(_sunController.text) ? _sunController.text : null,
          items: signsMap.entries.map((entry) {
            return DropdownMenuItem(
              value: entry.key,
              child: Text(entry.value, style: Styles.regular_arsenic_14),
            );
          }).toList(),
          onChanged: (val) {
            setState(() {
              _sunController.text = val!;
            });
          },
          validator: (val) => (val == null || val.isEmpty) ? "Required" : null,
          decoration: InputStyle.inputDecoration_text_field(hint: "Select Sun Sign"),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildmoon(BuildContext context, AppState state) {
    Map<String, String> signsMap = getZodiacMap(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${AppLocalizations.of(context)!.manage_profile_moon_sign} *",
          style: Styles.bold_arsenic_12,
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: signsMap.containsKey(_moonController.text) ? _moonController.text : null,
          items: signsMap.entries.map((entry) {
            return DropdownMenuItem(
              value: entry.key,
              child: Text(entry.value, style: Styles.regular_arsenic_14),
            );
          }).toList(),
          onChanged: (val) {
            setState(() {
              _moonController.text = val!;
            });
          },
          validator: (val) => (val == null || val.isEmpty) ? "Required" : null,
          decoration: InputStyle.inputDecoration_text_field(hint: "Select Moon Sign"),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildtimeofbirth(BuildContext context, AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${AppLocalizations.of(context)!.manage_profile_time_of_birth} *",
          style: Styles.bold_arsenic_12,
        ),
        Const.height5,
        InkWell(
          onTap: () => _selectTime(context),
          child: IgnorePointer(
            child: TextFormField(
              controller: _timeController,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "This field is required";
                }
                return null;
              },
              decoration: InputStyle.inputDecoration_text_field(
                hint: AppLocalizations.of(context)!.astro_pick_time,
                suffixIcon: const Icon(Icons.access_time_rounded, color: MyTheme.primary),
              ),
            ),
          ),
        ),
        Const.height20,
      ],
    );
  }

  Widget build_city_birth(BuildContext context, AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${AppLocalizations.of(context)!.manage_profile_city_of_birth} *",
          style: Styles.bold_arsenic_12,
        ),
        Const.height5,
        TextFormField(
          controller: _cityofBirthController,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return "This field is required";
            }
            if (val.length > 20) {
              return "Max 20 characters";
            }
            return null;
          },
          decoration: InputStyle.inputDecoration_text_field(
            hint: "City of Birth",
          ),
        ),
      ],
    );
  }
}
