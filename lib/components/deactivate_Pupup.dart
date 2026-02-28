import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:flutter/material.dart';

class DeactivatedAccountPopup {
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Account Deactivated", style: Styles.bold_arsenic_16),
          content: Text(
            "Your account is currently deactivated. Please reactivate it to continue.",
            style: Styles.regular_arsenic_14,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: Styles.regular_arsenic_14),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: MyTheme.app_accent_color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                'Reactivate',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Account reactivation request sent."),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  static Widget buildDeactivatedAccountView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.visibility_off_outlined,
              size: 60,
              color: MyTheme.storm_grey,
            ),
            const SizedBox(height: 20),
            Text(
              'Your Account is Deactivated',
              style: Styles.bold_arsenic_16,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Please reactivate your account to continue browsing members.',
              style: Styles.regular_arsenic_14,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyTheme.app_accent_color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
              ),
              onPressed: () => show(context), // This opens the dialog
              child: const Text(
                'Reactivate Now',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
