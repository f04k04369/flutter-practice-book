// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

  @override
  String get startScreenTitle => 'Edit Snap';

  @override
  String helloWorldOn(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MEd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'こんにちは！\n今日は$dateStringです';
  }

  @override
  String get start => '開始する';
}
