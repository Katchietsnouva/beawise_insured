// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Insured';

  @override
  String get newPolicy => 'Nuova polizza auto';

  @override
  String get policy => 'Polizza';

  @override
  String get premium => 'Premio';

  @override
  String get claim => 'Sinistro';

  @override
  String get addClient => 'Aggiungi nuovo cliente';

  @override
  String welcomeMessage(String name) {
    return 'Bentornato, $name';
  }
}
