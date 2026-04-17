// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مؤمَّن';

  @override
  String get newPolicy => 'بوليصة مركبة جديدة';

  @override
  String get policy => 'بوليصة';

  @override
  String get premium => 'القسط';

  @override
  String get claim => 'مطالبة';

  @override
  String get addClient => 'إضافة عميل جديد';

  @override
  String welcomeMessage(String name) {
    return 'مرحبًا بعودتك، $name';
  }

  @override
  String get settings_appearanceTitle => 'المظهر';

  @override
  String get settings_appearanceSubtitle => 'تخصيص مظهر التطبيق';

  @override
  String get settings_themeLabel => 'السمة';

  @override
  String get settings_textSizeLabel => 'حجم النص';

  @override
  String get settings_DisplayTitle => 'العرض';

  @override
  String get settings_DisplaySubtitle => 'تكوين خيارات العرض الافتراضية';

  @override
  String get settings_DefaultViewLabel => 'طريقة العرض الافتراضية';

  @override
  String get settings_CompactModeTitle => 'الوضع المضغوط';

  @override
  String get settings_CompactModeDescription => 'تقليل المسافات بين العناصر';

  @override
  String get settings_NotificationsTitle => 'الإشعارات';

  @override
  String get settings_NotificationsSubtitle => 'إدارة تفضيلات الإشعارات';

  @override
  String get settings_EnableNotificationsTitle => 'تفعيل الإشعارات';

  @override
  String get settings_EnableNotificationsDescription =>
      'تلقي إشعارات داخل التطبيق';

  @override
  String get settings_EmailNotificationsTitle => 'إشعارات البريد الإلكتروني';

  @override
  String get settings_EmailNotificationsDescription =>
      'تلقي التحديثات عبر البريد الإلكتروني';

  @override
  String get settings_RenewalRemindersTitle => 'تذكيرات التجديد';

  @override
  String get settings_RenewalRemindersDescription =>
      'تلقي إشعارات حول التجديدات القادمة';

  @override
  String get settings_LanguageTitle => 'اللغة والمنطقة';

  @override
  String get settings_LanguageSubtitle => 'تعيين تفضيلات اللغة';

  @override
  String get settings_LanguageLabel => 'اللغة';

  @override
  String get settings_PrivacyTitle => 'الخصوصية والأمان';

  @override
  String get settings_PrivacySubtitle => 'التحكم في إعدادات الخصوصية والأمان';

  @override
  String get settings_TwoFactorTitle => 'المصادقة الثنائية';

  @override
  String get settings_TwoFactorDescription => 'إضافة طبقة أمان إضافية';

  @override
  String get settings_ActivityLoggingTitle => 'تسجيل النشاط';

  @override
  String get settings_ActivityLoggingDescription => 'تتبع نشاط الحساب';

  @override
  String get settings_ShowSensitiveTitle => 'إظهار البيانات الحساسة';

  @override
  String get settings_ShowSensitiveDescription =>
      'عرض أرقام الهوية والبيانات المالية';

  @override
  String get settings_ChangePassword => 'تغيير كلمة المرور';

  @override
  String get settings_DataTitle => 'إدارة البيانات';

  @override
  String get settings_DataSubtitle => 'تصدير واستيراد وإدارة بياناتك';

  @override
  String get settings_ExportSettings => 'تصدير الإعدادات';

  @override
  String get settings_ImportSettings => 'استيراد الإعدادات';

  @override
  String get settings_DownloadAllData => 'تنزيل جميع البيانات';

  @override
  String get settings_ClearCache => 'مسح ذاكرة التخزين المؤقت';

  @override
  String get settings_AccessibilityTitle => 'إمكانية الوصول';

  @override
  String get settings_AccessibilitySubtitle => 'تحسين ميزات إمكانية الوصول';

  @override
  String get settings_HighContrastTitle => 'وضع التباين العالي';

  @override
  String get settings_HighContrastDescription => 'زيادة التباين لتحسين الرؤية';

  @override
  String get settings_ReduceMotionTitle => 'تقليل الحركة';

  @override
  String get settings_ReduceMotionDescription =>
      'تقليل الرسوم المتحركة والانتقالات';

  @override
  String get settings_ScreenReaderTitle => 'دعم قارئ الشاشة';

  @override
  String get settings_ScreenReaderDescription => 'تحسين التوافق مع قارئ الشاشة';

  @override
  String get settings_PerformanceTitle => 'الأداء';

  @override
  String get settings_PerformanceSubtitle => 'تحسين أداء التطبيق';

  @override
  String get settings_AutoSaveTitle => 'الحفظ التلقائي';

  @override
  String get settings_AutoSaveDescription => 'حفظ التغييرات تلقائيًا';

  @override
  String get settings_LazyLoadingTitle => 'التحميل التدريجي';

  @override
  String get settings_LazyLoadingDescription => 'تحميل المحتوى أثناء التمرير';

  @override
  String get settings_OfflineModeTitle => 'وضع عدم الاتصال';

  @override
  String get settings_OfflineModeDescription => 'العمل بدون اتصال بالإنترنت';

  @override
  String get settings_AdvancedTitle => 'متقدم';

  @override
  String get settings_AdvancedSubtitle =>
      'ميزات واختصارات للمستخدمين المتقدمين';

  @override
  String get settings_KeyboardShortcutsTitle => 'اختصارات لوحة المفاتيح';

  @override
  String get settings_KeyboardShortcutsDescription =>
      'تمكين التنقل باستخدام لوحة المفاتيح';

  @override
  String get settings_DeveloperModeTitle => 'وضع المطور';

  @override
  String get settings_DeveloperModeDescription =>
      'عرض خيارات تصحيح الأخطاء المتقدمة';

  @override
  String get settings_BetaFeaturesTitle => 'الميزات التجريبية';

  @override
  String get settings_BetaFeaturesDescription => 'تجربة الميزات التجريبية';

  @override
  String get settings_ViewKeyboardShortcuts => 'عرض اختصارات لوحة المفاتيح';

  @override
  String get settings_DangerTitle => 'منطقة الخطر';

  @override
  String get settings_DangerSubtitle => 'إجراءات غير قابلة للتراجع';

  @override
  String get settings_ResetAllSettings => 'إعادة تعيين جميع الإعدادات';

  @override
  String get settings_DeleteAllData => 'حذف جميع البيانات';

  @override
  String get sidebar_dashboard => 'لوحة التحكم';

  @override
  String get subtitle_dashboard => 'إدارة العملاء وعروض الأسعار';

  @override
  String get sidebar_clients => 'العملاء';

  @override
  String get subtitle_clients => 'عرض وإدارة جميع العملاء';

  @override
  String get sidebar_motorQuote => 'عرض سعر المركبة';

  @override
  String get subtitle_motorQuote => 'إدارة عروض أسعار المركبات';

  @override
  String get sidebar_policies => 'البوالص';

  @override
  String get subtitle_policies => 'عرض وإدارة البوالص';

  @override
  String get sidebar_production => 'الإنتاج';

  @override
  String get subtitle_production => 'متابعة مؤشرات الإنتاج';

  @override
  String get sidebar_dmvic => 'DMVIC';

  @override
  String get subtitle_dmvic => 'عمليات متعلقة بـ DMVIC';

  @override
  String get sidebar_dmvicDoubleInsurance => 'تأمين مزدوج DMVIC';

  @override
  String get subtitle_dmvicDoubleInsurance =>
      'إدارة بوالص التأمين المزدوج DMVIC';

  @override
  String get sidebar_dmvicStock => 'مخزون DMVIC';

  @override
  String get subtitle_dmvicStock => 'إدارة البوالص المتعلقة بمخزون DMVIC';

  @override
  String get sidebar_statement => 'كشف الحساب';

  @override
  String get subtitle_statement => 'عرض كشوف الحساب';

  @override
  String get sidebar_renewals => 'التجديدات';

  @override
  String get subtitle_renewals => 'مراقبة تجديد البوالص';

  @override
  String get sidebar_certificates => 'الشهادات';

  @override
  String get subtitle_certificates => 'عرض الشهادات الصادرة';

  @override
  String get sidebar_quotes => 'عروض الأسعار';

  @override
  String get subtitle_quotes => 'إدارة عروض أسعار التأمين';

  @override
  String get sidebar_settings => 'الإعدادات';

  @override
  String get subtitle_settings => 'تفضيلات التطبيق';

  @override
  String get sidebar_profile => 'ملفي الشخصي';

  @override
  String get subtitle_profile => 'إدارة حسابك';

  @override
  String get sidebar_notifications => 'الإشعارات';

  @override
  String get subtitle_notifications => 'عرض جميع الإشعارات';

  @override
  String get sidebar_offlineQueueScreen => 'شاشة قائمة الانتظار دون اتصال';

  @override
  String get subtitle_offlineQueueScreen => 'عرض جميع عمليات الحفظ دون اتصال';

  @override
  String get sidebar_logout => 'تسجيل الخروج';

  @override
  String get sidebar_loading => 'جارٍ التحميل...';

  @override
  String get sidebar_add_client => 'إضافة عميل';

  @override
  String get subtitle_add_client => 'إدخال تفاصيل العميل الجديد';

  @override
  String get subtitle_default => 'مؤمَّن دائمًا';
}
