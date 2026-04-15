// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Insured';

  @override
  String get newPolicy => 'Neue Kfz-Versicherung';

  @override
  String get policy => 'Police';

  @override
  String get premium => 'Prämie';

  @override
  String get claim => 'Schadenmeldung';

  @override
  String get addClient => 'Neuen Kunden hinzufügen';

  @override
  String welcomeMessage(String name) {
    return 'Willkommen zurück, $name';
  }
}
