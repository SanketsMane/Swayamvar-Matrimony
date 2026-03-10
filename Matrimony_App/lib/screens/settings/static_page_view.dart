import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class StaticPageView extends StatelessWidget {
  final String title;
  final String content;

  const StaticPageView({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.white,
      appBar: AppBar(
        title: Text(
          title,
          style: Styles.h2.copyWith(fontSize: 18, color: MyTheme.text_primary),
        ),
        elevation: 0,
        backgroundColor: MyTheme.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: MyTheme.text_primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child:
            content.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Html(data: content),
      ),
    );
  }
}
