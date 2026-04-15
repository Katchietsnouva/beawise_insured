// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Insured';

  @override
  String get newPolicy => 'Nouvelle police automobile';

  @override
  String get policy => 'Police';

  @override
  String get premium => 'Prime';

  @override
  String get claim => 'Réclamation';

  @override
  String get addClient => 'Ajouter un nouveau client';

  @override
  String welcomeMessage(String name) {
    return 'Bon retour, $name';
  }
}
