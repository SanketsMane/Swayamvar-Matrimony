import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:http/http.dart' as http;

class MyImages {
  static String _getFormattedUrl(String? url) {
    if (url == null || url.isEmpty || url.toLowerCase() == "null") {
      if (kDebugMode) print("MyImages: URL is null, empty, or literal 'null'");
      return "";
    }
    String cleanUrl = url.trim();

    // Sanket: Handle absolute URLs
    if (cleanUrl.startsWith("http")) {
      if (kDebugMode) print("MyImages: Absolute URL -> $cleanUrl");
      return cleanUrl;
    }

    // Sanket: Prefix relative path with Raw Base URL
    String baseUrl = AppConfig.RAW_BASE_URL;
    String finalUrl = "$baseUrl/$cleanUrl";
    if (kDebugMode) print("MyImages: Relative URL -> $finalUrl");
    return finalUrl;
  }

  static Widget normalImage(
    String? url, {
    BoxFit fit = BoxFit.cover,
    Alignment alignment = Alignment.center,
  }) {
    String formattedUrl = _getFormattedUrl(url);

    if (formattedUrl.isEmpty) {
      return Image.asset(
        'assets/images/342x200.png',
        fit: fit,
        alignment: alignment,
      );
    }

    return _VerifiedImageWidget(
      url: formattedUrl,
      fit: fit,
      alignment: alignment,
    );
  }
}

class _VerifiedImageWidget extends StatefulWidget {
  final String url;
  final BoxFit fit;
  final Alignment alignment;

  const _VerifiedImageWidget({
    Key? key,
    required this.url,
    required this.fit,
    required this.alignment,
  }) : super(key: key);

  @override
  State<_VerifiedImageWidget> createState() => _VerifiedImageWidgetState();
}

class _VerifiedImageWidgetState extends State<_VerifiedImageWidget> {
  bool _isValidImage = true;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkImageSize();
  }

  Future<void> _checkImageSize() async {
    try {
      final response = await http.head(Uri.parse(widget.url));
      if (response.statusCode == 200) {
        final contentLength = response.headers['content-length'];
        if (contentLength != null && int.parse(contentLength) < 100) {
          // Sanket: Server is serving a 68 byte 1x1 transparent pixel. Consider it invalid.
          if (mounted) setState(() => _isValidImage = false);
        }
      } else {
        if (mounted) setState(() => _isValidImage = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isValidImage = false);
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: MyTheme.app_accent_color,
          ),
        ),
      );
    }

    if (!_isValidImage) {
      String fallbackAsset = 'assets/images/342x200.png';
      if (widget.url.contains('male') || widget.url.contains('Male')) {
        fallbackAsset = 'assets/images/placeholder_male.png';
        if (widget.url.contains('female') || widget.url.contains('Female')) {
          fallbackAsset = 'assets/images/placeholder_female.png';
        }
      } else if (widget.url.contains('female') || widget.url.contains('Female')) {
        fallbackAsset = 'assets/images/placeholder_female.png';
      }

      return Image.asset(
        fallbackAsset,
        fit: widget.fit,
        alignment: widget.alignment,
      );
    }

    if (kIsWeb) {
      return Image.network(
        widget.url,
        fit: widget.fit,
        alignment: widget.alignment,
        errorBuilder: (context, error, stackTrace) {
          String fallbackAsset = 'assets/images/342x200.png';
          if (widget.url.contains('male')) fallbackAsset = 'assets/images/placeholder_male.png';
          if (widget.url.contains('female')) fallbackAsset = 'assets/images/placeholder_female.png';
          
          return Image.asset(
            fallbackAsset,
            fit: widget.fit,
            alignment: widget.alignment,
          );
        },
      );
    }

    return CachedNetworkImage(
      fit: widget.fit,
      alignment: widget.alignment,
      imageUrl: widget.url,
      placeholder: (context, url) {
        String fallbackAsset = 'assets/images/342x200.png';
        if (widget.url.contains('male')) fallbackAsset = 'assets/images/placeholder_male.png';
        if (widget.url.contains('female')) fallbackAsset = 'assets/images/placeholder_female.png';
          
        return Image.asset(
          fallbackAsset,
          fit: widget.fit,
          alignment: widget.alignment,
        );
      },
      errorWidget: (context, url, dynamic error) {
        String fallbackAsset = 'assets/images/342x200.png';
        if (widget.url.contains('male')) fallbackAsset = 'assets/images/placeholder_male.png';
        if (widget.url.contains('female')) fallbackAsset = 'assets/images/placeholder_female.png';
          
        return Image.asset(
          fallbackAsset,
          fit: widget.fit,
          alignment: widget.alignment,
        );
      },
    );
  }
}

class MyImage {
  static ImageProvider<Object> imageProvider(String? url) {
    String formattedUrl = MyImages._getFormattedUrl(url);
    if (formattedUrl.isEmpty) {
      return const AssetImage('assets/images/342x200.png');
    }

    if (kIsWeb) {
      return NetworkImage(formattedUrl);
    }
    return CachedNetworkImageProvider(formattedUrl);
  }
}
