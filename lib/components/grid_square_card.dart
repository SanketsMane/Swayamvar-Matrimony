
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:flutter/material.dart';

class GridSquareCard extends StatelessWidget {
  final VoidCallback? onpressed;
  final String icon;
  final bool isSmallScreen;
  final String text;

  const GridSquareCard({
    required this.onpressed,
    required this.icon,
    this.isSmallScreen = false,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpressed,
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // Using fixed width and height
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: MyTheme.app_accent_color,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/icon/$icon',
                  // Using fixed width and height
                  width: 16,
                  height: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              // Using fixed width
              width: 90,
              child: Text(
                text,
                style: isSmallScreen
                    ? Styles.regular_arsenic_11
                    : Styles.regular_arsenic_12,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


