// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Insured';

  @override
  String get newPolicy => 'New Motor Policy';

  @override
  String get policy => 'Policy';

  @override
  String get premium => 'Premium';

  @override
  String get claim => 'Claim';

  @override
  String get addClient => 'Add New Client';

  @override
  String welcomeMessage(String name) {
    return 'Welcome back, $name';
  }
}
