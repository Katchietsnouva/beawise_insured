// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Insured';

  @override
  String get newPolicy => 'Новая страховая полис автомобиля';

  @override
  String get policy => 'Полис';

  @override
  String get premium => 'Премия';

  @override
  String get claim => 'Иск';

  @override
  String get addClient => 'Добавить нового клиента';

  @override
  String welcomeMessage(String name) {
    return 'С возвращением, $name';
  }
}
