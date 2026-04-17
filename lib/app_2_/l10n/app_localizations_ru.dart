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
  String get newPolicy => 'Новый страховой полис автомобиля';

  @override
  String get policy => 'Полис';

  @override
  String get premium => 'Премия';

  @override
  String get claim => 'Страховой случай';

  @override
  String get addClient => 'Добавить нового клиента';

  @override
  String welcomeMessage(String name) {
    return 'С возвращением, $name';
  }

  @override
  String get settings_appearanceTitle => 'Внешний вид';

  @override
  String get settings_appearanceSubtitle => 'Настройте внешний вид приложения';

  @override
  String get settings_themeLabel => 'Тема';

  @override
  String get settings_textSizeLabel => 'Размер текста';

  @override
  String get settings_DisplayTitle => 'Экран';

  @override
  String get settings_DisplaySubtitle =>
      'Настройка параметров отображения по умолчанию';

  @override
  String get settings_DefaultViewLabel => 'Вид по умолчанию';

  @override
  String get settings_CompactModeTitle => 'Компактный режим';

  @override
  String get settings_CompactModeDescription =>
      'Уменьшить расстояние между элементами';

  @override
  String get settings_NotificationsTitle => 'Уведомления';

  @override
  String get settings_NotificationsSubtitle =>
      'Управление настройками уведомлений';

  @override
  String get settings_EnableNotificationsTitle => 'Включить уведомления';

  @override
  String get settings_EnableNotificationsDescription =>
      'Получать уведомления в приложении';

  @override
  String get settings_EmailNotificationsTitle =>
      'Уведомления по электронной почте';

  @override
  String get settings_EmailNotificationsDescription =>
      'Получать обновления по электронной почте';

  @override
  String get settings_RenewalRemindersTitle => 'Напоминания о продлении';

  @override
  String get settings_RenewalRemindersDescription =>
      'Получать уведомления о предстоящих продлениях';

  @override
  String get settings_LanguageTitle => 'Язык и регион';

  @override
  String get settings_LanguageSubtitle => 'Установите предпочтительный язык';

  @override
  String get settings_LanguageLabel => 'Язык';

  @override
  String get settings_PrivacyTitle => 'Конфиденциальность и безопасность';

  @override
  String get settings_PrivacySubtitle =>
      'Управляйте настройками конфиденциальности и безопасности';

  @override
  String get settings_TwoFactorTitle => 'Двухфакторная аутентификация';

  @override
  String get settings_TwoFactorDescription =>
      'Добавить дополнительный уровень безопасности';

  @override
  String get settings_ActivityLoggingTitle => 'Журнал активности';

  @override
  String get settings_ActivityLoggingDescription =>
      'Отслеживать активность аккаунта';

  @override
  String get settings_ShowSensitiveTitle => 'Показать конфиденциальные данные';

  @override
  String get settings_ShowSensitiveDescription =>
      'Показывать номера удостоверений и финансовые данные';

  @override
  String get settings_ChangePassword => 'Изменить пароль';

  @override
  String get settings_DataTitle => 'Управление данными';

  @override
  String get settings_DataSubtitle =>
      'Экспортируйте, импортируйте и управляйте своими данными';

  @override
  String get settings_ExportSettings => 'Экспорт настроек';

  @override
  String get settings_ImportSettings => 'Импорт настроек';

  @override
  String get settings_DownloadAllData => 'Скачать все данные';

  @override
  String get settings_ClearCache => 'Очистить кэш';

  @override
  String get settings_AccessibilityTitle => 'Доступность';

  @override
  String get settings_AccessibilitySubtitle => 'Улучшите функции доступности';

  @override
  String get settings_HighContrastTitle => 'Высокая контрастность';

  @override
  String get settings_HighContrastDescription =>
      'Увеличить контрастность для лучшей видимости';

  @override
  String get settings_ReduceMotionTitle => 'Уменьшить анимации';

  @override
  String get settings_ReduceMotionDescription =>
      'Минимизировать анимации и переходы';

  @override
  String get settings_ScreenReaderTitle => 'Поддержка экранного диктора';

  @override
  String get settings_ScreenReaderDescription =>
      'Улучшенная совместимость с экранными дикторами';

  @override
  String get settings_PerformanceTitle => 'Производительность';

  @override
  String get settings_PerformanceSubtitle =>
      'Оптимизация производительности приложения';

  @override
  String get settings_AutoSaveTitle => 'Автосохранение';

  @override
  String get settings_AutoSaveDescription =>
      'Автоматически сохранять изменения';

  @override
  String get settings_LazyLoadingTitle => 'Ленивая загрузка';

  @override
  String get settings_LazyLoadingDescription =>
      'Загружать контент при прокрутке';

  @override
  String get settings_OfflineModeTitle => 'Офлайн режим';

  @override
  String get settings_OfflineModeDescription =>
      'Работать без подключения к интернету';

  @override
  String get settings_AdvancedTitle => 'Дополнительно';

  @override
  String get settings_AdvancedSubtitle =>
      'Расширенные функции и сочетания клавиш';

  @override
  String get settings_KeyboardShortcutsTitle => 'Горячие клавиши';

  @override
  String get settings_KeyboardShortcutsDescription =>
      'Включить навигацию с клавиатуры';

  @override
  String get settings_DeveloperModeTitle => 'Режим разработчика';

  @override
  String get settings_DeveloperModeDescription =>
      'Показать расширенные параметры отладки';

  @override
  String get settings_BetaFeaturesTitle => 'Бета-функции';

  @override
  String get settings_BetaFeaturesDescription =>
      'Попробовать экспериментальные функции';

  @override
  String get settings_ViewKeyboardShortcuts => 'Просмотреть горячие клавиши';

  @override
  String get settings_DangerTitle => 'Опасная зона';

  @override
  String get settings_DangerSubtitle => 'Необратимые действия';

  @override
  String get settings_ResetAllSettings => 'Сбросить все настройки';

  @override
  String get settings_DeleteAllData => 'Удалить все данные';

  @override
  String get sidebar_dashboard => 'Панель управления';

  @override
  String get subtitle_dashboard => 'Управляйте своими клиентами и котировками';

  @override
  String get sidebar_clients => 'Клиенты';

  @override
  String get subtitle_clients => 'Просмотр и управление всеми клиентами';

  @override
  String get sidebar_motorQuote => 'Котировка авто';

  @override
  String get subtitle_motorQuote => 'Управление авто котировками';

  @override
  String get sidebar_policies => 'Полисы';

  @override
  String get subtitle_policies => 'Просмотр и управление полисами';

  @override
  String get sidebar_production => 'Производство';

  @override
  String get subtitle_production => 'Отслеживание производственных показателей';

  @override
  String get sidebar_dmvic => 'DMVIC';

  @override
  String get subtitle_dmvic => 'Операции, связанные с DMVIC';

  @override
  String get sidebar_dmvicDoubleInsurance => 'Двойное страхование DMVIC';

  @override
  String get subtitle_dmvicDoubleInsurance =>
      'Управление полисами двойного страхования DMVIC';

  @override
  String get sidebar_dmvicStock => 'Запасы DMVIC';

  @override
  String get subtitle_dmvicStock => 'Управление полисами запасов DMVIC';

  @override
  String get sidebar_statement => 'Выписка';

  @override
  String get subtitle_statement => 'Просмотр выписок';

  @override
  String get sidebar_renewals => 'Продления';

  @override
  String get subtitle_renewals => 'Отслеживание продлений полисов';

  @override
  String get sidebar_certificates => 'Сертификаты';

  @override
  String get subtitle_certificates => 'Просмотр выданных сертификатов';

  @override
  String get sidebar_quotes => 'Котировки';

  @override
  String get subtitle_quotes => 'Управление страховыми котировками';

  @override
  String get sidebar_settings => 'Настройки';

  @override
  String get subtitle_settings => 'Настройки приложения';

  @override
  String get sidebar_profile => 'Мой профиль';

  @override
  String get subtitle_profile => 'Управление аккаунтом';

  @override
  String get sidebar_notifications => 'Уведомления';

  @override
  String get subtitle_notifications => 'Просмотр всех уведомлений';

  @override
  String get sidebar_offlineQueueScreen => 'Экран офлайн очереди';

  @override
  String get subtitle_offlineQueueScreen =>
      'Просмотреть все ваши офлайн-сохранения';

  @override
  String get sidebar_logout => 'Выйти';

  @override
  String get sidebar_loading => 'Загрузка...';

  @override
  String get sidebar_add_client => 'Добавить клиента';

  @override
  String get subtitle_add_client => 'Введите данные нового клиента';

  @override
  String get subtitle_default => 'Всегда застрахован';
}
