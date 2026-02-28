import 'package:flutter/material.dart';

import '../const/my_theme.dart';

class GalleryExtendedBox extends StatelessWidget {
  final String? text;
  final String? icon;

  const GalleryExtendedBox({super.key, this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
        child: Row(
          children: [
            Image.asset('$icon', height: 16, width: 16),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                text!,
                style: const TextStyle(
                  color: MyTheme.app_accent_color,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
