import 'package:flutter/material.dart';
import 'package:practice_book/image_select_screen.dart';
import 'package:practice_book/l10n/app_localizations.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
   final l10n = L10n.of(context);
   return Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(l10n.startScreenTitle),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.helloWorldOn(DateTime.now()),
            textAlign: TextAlign.center
          ),
          ElevatedButton(
            child: Text(l10n.start),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ImageSelectScreen(), 
                )
              );
            },
          ),
        ],
      ),
    ),
   ); 
  }
}