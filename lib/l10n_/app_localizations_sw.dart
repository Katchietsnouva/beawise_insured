// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get appTitle => 'Insured';

  @override
  String get newPolicy => 'Bima Mpya ya Gari';

  @override
  String get policy => 'Bima';

  @override
  String get premium => 'Ada ya Bima';

  @override
  String get claim => 'Dai';

  @override
  String get addClient => 'Ongeza Mteja Mpya';

  @override
  String welcomeMessage(String name) {
    return 'Karibu tena, $name';
  }
}
