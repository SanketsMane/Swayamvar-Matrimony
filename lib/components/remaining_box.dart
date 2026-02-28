import 'package:flutter/material.dart';

import '../const/style.dart';
import '../helpers/device_info.dart';

class RemainingBox extends StatelessWidget {
  final value;
  final localization_text;
  final context;

  const RemainingBox({
    super.key,
    this.value,
    this.localization_text,
    this.context,
  });

  @override
  Widget build(BuildContext context) {
    String displayValue =
        (value == null || value.toString().trim().isEmpty)
            ? '0'
            : value.toString();

    return SizedBox(
      width: DeviceInfo(context).width! * .25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            localization_text,
            style: Styles.regular_white_12,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            displayValue,
            style: Styles.medium_white_22,
            // textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
