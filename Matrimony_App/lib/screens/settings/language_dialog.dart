import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

class LanguageSelectionDialog extends StatelessWidget {
  const LanguageSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final l = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.settings_language_dialog_title,
              style: Styles.h2.copyWith(
                fontSize: 18,
                color: MyTheme.text_primary,
              ),
            ),
            const SizedBox(height: 20),
            _languageOption(
              context,
              "English",
              "en",
              languageProvider.appLocale.languageCode == 'en',
              languageProvider,
            ),
            const Divider(height: 24, color: MyTheme.border),
            _languageOption(
              context,
              "मराठी (Marathi)",
              "mr",
              languageProvider.appLocale.languageCode == 'mr',
              languageProvider,
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(
    BuildContext context,
    String label,
    String code,
    bool isSelected,
    LanguageProvider provider,
  ) {
    return InkWell(
      onTap: () {
        provider.setLocale(Locale(code));
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? MyTheme.primary.withOpacity(0.05)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? MyTheme.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Styles.body.copyWith(
                color: isSelected ? MyTheme.primary : MyTheme.text_primary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: MyTheme.primary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
