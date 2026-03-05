import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';

class HeightDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;

  const HeightDropdown({
    super.key,
    required this.label,
    this.value,
    required this.onChanged,
  });

  static const List<String> heightOptions = [
    "4' 0\"", "4' 1\"", "4' 2\"", "4' 3\"", "4' 4\"", "4' 5\"", "4' 6\"", "4' 7\"", "4' 8\"", "4' 9\"", "4' 10\"", "4' 11\"",
    "5' 0\"", "5' 1\"", "5' 2\"", "5' 3\"", "5' 4\"", "5' 5\"", "5' 6\"", "5' 7\"", "5' 8\"", "5' 9\"", "5' 10\"", "5' 11\"",
    "6' 0\"", "6' 1\"", "6' 2\"", "6' 3\"", "6' 4\"", "6' 5\"", "6' 6\"", "6' 7\"", "6' 8\"", "6' 9\"", "6' 10\"", "6' 11\"",
    "7' 0\""
  ];

  @override
  Widget build(BuildContext context) {
    String? displayValue = value;
    if (value != null && value!.isNotEmpty && !heightOptions.contains(value)) {
       // Try to approximate or default to something if the backend gave us a weird float like "5.3"
       // For now, if it's not in the list, we let it be null so the user is forced to pick a clean option
       displayValue = null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Styles.bold_arsenic_12,
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: MyTheme.solitude,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: displayValue,
              hint: const Text("Select Height"),
              icon: const Icon(Icons.keyboard_arrow_down, color: MyTheme.gull_grey),
              items: heightOptions.map((String height) {
                return DropdownMenuItem<String>(
                  value: height,
                  child: Text(height, style: Styles.regular_gull_grey_12.copyWith(color: MyTheme.arsenic)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
