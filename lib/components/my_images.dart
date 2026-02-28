import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyImages {
  static Widget normalImage(
    String? url, {
    BoxFit fit = BoxFit.cover,
    Alignment alignment = Alignment.center,
  }) {
    if (url == null || url.isEmpty) {
      return Image.asset(
        'assets/images/342x200.png',
        fit: fit,
        alignment: alignment,
      );
    }
    return CachedNetworkImage(
      fit: fit,
      alignment: alignment,
      imageUrl: url,
      placeholder: (BuildContext context, String url) {
        return Image.asset(
          'assets/images/342x200.png',
          fit: fit,
          alignment: alignment,
        );
      },
      errorWidget: (BuildContext context, String url, dynamic error) {
        return Image.asset(
          'assets/logo/app_logo.png',
          fit: fit,
          alignment: alignment,
          color: Colors.grey.withOpacity(0.4),
        );
      },
    );
  }
}

class MyImage {
  static ImageProvider<Object> imageProvider(String? url) {
    if (url == null || url.isEmpty) {
      return const AssetImage('assets/images/342x200.png');
    }
    return CachedNetworkImageProvider(url);
  }
}
