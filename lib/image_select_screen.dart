import 'package:flutter/material.dart';
import 'package:practice_book/l10n/app_localizations.dart';

class ImageSelectScreen extends StatelessWidget {
  const ImageSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n.imageSelectScreenTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text(l10n.imageSelect),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(l10n.imageEdit),
            ),
          ],
        ),
      ),
    );
  }
}