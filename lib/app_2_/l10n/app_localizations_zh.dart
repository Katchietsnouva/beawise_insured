// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Insured';

  @override
  String get newPolicy => '新机动车保单';

  @override
  String get policy => '保单';

  @override
  String get premium => '保费';

  @override
  String get claim => '理赔';

  @override
  String get addClient => '添加新客户';

  @override
  String welcomeMessage(String name) {
    return '欢迎回来, $name';
  }

  @override
  String get settings_appearanceTitle => '外观';

  @override
  String get settings_appearanceSubtitle => '自定义应用外观';

  @override
  String get settings_themeLabel => '主题';

  @override
  String get settings_textSizeLabel => '文字大小';

  @override
  String get settings_DisplayTitle => '显示';

  @override
  String get settings_DisplaySubtitle => '配置默认显示选项';

  @override
  String get settings_DefaultViewLabel => '默认视图';

  @override
  String get settings_CompactModeTitle => '紧凑模式';

  @override
  String get settings_CompactModeDescription => '减少元素间距';

  @override
  String get settings_NotificationsTitle => '通知';

  @override
  String get settings_NotificationsSubtitle => '管理通知偏好';

  @override
  String get settings_EnableNotificationsTitle => '启用通知';

  @override
  String get settings_EnableNotificationsDescription => '接收应用内通知';

  @override
  String get settings_EmailNotificationsTitle => '邮件通知';

  @override
  String get settings_EmailNotificationsDescription => '通过邮件接收更新';

  @override
  String get settings_RenewalRemindersTitle => '续保提醒';

  @override
  String get settings_RenewalRemindersDescription => '获取即将到期的续保通知';

  @override
  String get settings_LanguageTitle => '语言与地区';

  @override
  String get settings_LanguageSubtitle => '设置您的语言偏好';

  @override
  String get settings_LanguageLabel => '语言';

  @override
  String get settings_PrivacyTitle => '隐私与安全';

  @override
  String get settings_PrivacySubtitle => '控制您的隐私和安全设置';

  @override
  String get settings_TwoFactorTitle => '双重身份验证';

  @override
  String get settings_TwoFactorDescription => '增加额外的安全层';

  @override
  String get settings_ActivityLoggingTitle => '活动日志';

  @override
  String get settings_ActivityLoggingDescription => '跟踪账户活动';

  @override
  String get settings_ShowSensitiveTitle => '显示敏感数据';

  @override
  String get settings_ShowSensitiveDescription => '显示身份证号和财务数据';

  @override
  String get settings_ChangePassword => '修改密码';

  @override
  String get settings_DataTitle => '数据管理';

  @override
  String get settings_DataSubtitle => '导出、导入并管理您的数据';

  @override
  String get settings_ExportSettings => '导出设置';

  @override
  String get settings_ImportSettings => '导入设置';

  @override
  String get settings_DownloadAllData => '下载所有数据';

  @override
  String get settings_ClearCache => '清除缓存';

  @override
  String get settings_AccessibilityTitle => '无障碍';

  @override
  String get settings_AccessibilitySubtitle => '增强无障碍功能';

  @override
  String get settings_HighContrastTitle => '高对比度模式';

  @override
  String get settings_HighContrastDescription => '提高对比度以便更好可见';

  @override
  String get settings_ReduceMotionTitle => '减少动画';

  @override
  String get settings_ReduceMotionDescription => '最小化动画和过渡效果';

  @override
  String get settings_ScreenReaderTitle => '屏幕阅读器支持';

  @override
  String get settings_ScreenReaderDescription => '增强屏幕阅读器兼容性';

  @override
  String get settings_PerformanceTitle => '性能';

  @override
  String get settings_PerformanceSubtitle => '优化应用性能';

  @override
  String get settings_AutoSaveTitle => '自动保存';

  @override
  String get settings_AutoSaveDescription => '自动保存更改';

  @override
  String get settings_LazyLoadingTitle => '延迟加载';

  @override
  String get settings_LazyLoadingDescription => '滚动时加载内容';

  @override
  String get settings_OfflineModeTitle => '离线模式';

  @override
  String get settings_OfflineModeDescription => '在无网络情况下工作';

  @override
  String get settings_AdvancedTitle => '高级';

  @override
  String get settings_AdvancedSubtitle => '高级用户功能和快捷方式';

  @override
  String get settings_KeyboardShortcutsTitle => '键盘快捷键';

  @override
  String get settings_KeyboardShortcutsDescription => '启用键盘导航';

  @override
  String get settings_DeveloperModeTitle => '开发者模式';

  @override
  String get settings_DeveloperModeDescription => '显示高级调试选项';

  @override
  String get settings_BetaFeaturesTitle => '测试功能';

  @override
  String get settings_BetaFeaturesDescription => '尝试实验性功能';

  @override
  String get settings_ViewKeyboardShortcuts => '查看键盘快捷键';

  @override
  String get settings_DangerTitle => '危险区域';

  @override
  String get settings_DangerSubtitle => '不可逆操作';

  @override
  String get settings_ResetAllSettings => '重置所有设置';

  @override
  String get settings_DeleteAllData => '删除所有数据';

  @override
  String get sidebar_dashboard => '仪表板';

  @override
  String get subtitle_dashboard => '管理您的客户和报价';

  @override
  String get sidebar_clients => '客户';

  @override
  String get subtitle_clients => '查看并管理所有客户';

  @override
  String get sidebar_motorQuote => '车辆报价';

  @override
  String get subtitle_motorQuote => '管理车辆保险报价';

  @override
  String get sidebar_policies => '保单';

  @override
  String get subtitle_policies => '查看并管理保单';

  @override
  String get sidebar_production => '生产';

  @override
  String get subtitle_production => '跟踪生产指标';

  @override
  String get sidebar_dmvic => 'DMVIC';

  @override
  String get subtitle_dmvic => 'DMVIC 相关操作';

  @override
  String get sidebar_dmvicDoubleInsurance => 'DMVIC 双重保险';

  @override
  String get subtitle_dmvicDoubleInsurance => '管理 DMVIC 双重保险保单';

  @override
  String get sidebar_dmvicStock => 'DMVIC 库存';

  @override
  String get subtitle_dmvicStock => '管理 DMVIC 库存相关保单';

  @override
  String get sidebar_statement => '对账单';

  @override
  String get subtitle_statement => '查看对账单';

  @override
  String get sidebar_renewals => '续保';

  @override
  String get subtitle_renewals => '监控保单续保';

  @override
  String get sidebar_certificates => '证书';

  @override
  String get subtitle_certificates => '查看已签发的证书';

  @override
  String get sidebar_quotes => '报价';

  @override
  String get subtitle_quotes => '管理保险报价';

  @override
  String get sidebar_settings => '设置';

  @override
  String get subtitle_settings => '应用偏好设置';

  @override
  String get sidebar_profile => '我的资料';

  @override
  String get subtitle_profile => '管理您的账户';

  @override
  String get sidebar_notifications => '通知';

  @override
  String get subtitle_notifications => '查看所有通知';

  @override
  String get sidebar_offlineQueueScreen => '离线队列屏幕';

  @override
  String get subtitle_offlineQueueScreen => '查看所有离线保存';

  @override
  String get sidebar_logout => '退出登录';

  @override
  String get sidebar_loading => '加载中...';

  @override
  String get sidebar_add_client => '添加客户';

  @override
  String get subtitle_add_client => '输入新客户信息';

  @override
  String get subtitle_default => '始终有保障';
}
