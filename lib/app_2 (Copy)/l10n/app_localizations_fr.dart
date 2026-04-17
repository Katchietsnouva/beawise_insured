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

  @override
  String get settings_appearanceTitle => 'Apparence';

  @override
  String get settings_appearanceSubtitle =>
      'Personnalisez l\'apparence de l\'application';

  @override
  String get settings_themeLabel => 'Thème';

  @override
  String get settings_textSizeLabel => 'Taille du texte';

  @override
  String get settings_DisplayTitle => 'Affichage';

  @override
  String get settings_DisplaySubtitle =>
      'Configurer les options d\'affichage par défaut';

  @override
  String get settings_DefaultViewLabel => 'Vue par défaut';

  @override
  String get settings_CompactModeTitle => 'Mode compact';

  @override
  String get settings_CompactModeDescription =>
      'Réduire l\'espacement entre les éléments';

  @override
  String get settings_NotificationsTitle => 'Notifications';

  @override
  String get settings_NotificationsSubtitle =>
      'Gérer les préférences de notification';

  @override
  String get settings_EnableNotificationsTitle => 'Activer les notifications';

  @override
  String get settings_EnableNotificationsDescription =>
      'Recevoir des notifications dans l\'application';

  @override
  String get settings_EmailNotificationsTitle => 'Notifications par e-mail';

  @override
  String get settings_EmailNotificationsDescription =>
      'Recevoir des mises à jour par e-mail';

  @override
  String get settings_RenewalRemindersTitle => 'Rappels de renouvellement';

  @override
  String get settings_RenewalRemindersDescription =>
      'Recevoir des notifications sur les renouvellements à venir';

  @override
  String get settings_LanguageTitle => 'Langue et région';

  @override
  String get settings_LanguageSubtitle =>
      'Définissez vos préférences linguistiques';

  @override
  String get settings_LanguageLabel => 'Langue';

  @override
  String get settings_PrivacyTitle => 'Confidentialité et sécurité';

  @override
  String get settings_PrivacySubtitle =>
      'Contrôlez vos paramètres de confidentialité et de sécurité';

  @override
  String get settings_TwoFactorTitle => 'Authentification à deux facteurs';

  @override
  String get settings_TwoFactorDescription =>
      'Ajouter une couche de sécurité supplémentaire';

  @override
  String get settings_ActivityLoggingTitle => 'Journal d\'activité';

  @override
  String get settings_ActivityLoggingDescription =>
      'Suivre l\'activité du compte';

  @override
  String get settings_ShowSensitiveTitle => 'Afficher les données sensibles';

  @override
  String get settings_ShowSensitiveDescription =>
      'Afficher les numéros d\'identité et les données financières';

  @override
  String get settings_ChangePassword => 'Changer le mot de passe';

  @override
  String get settings_DataTitle => 'Gestion des données';

  @override
  String get settings_DataSubtitle => 'Exporter, importer et gérer vos données';

  @override
  String get settings_ExportSettings => 'Exporter les paramètres';

  @override
  String get settings_ImportSettings => 'Importer les paramètres';

  @override
  String get settings_DownloadAllData => 'Télécharger toutes les données';

  @override
  String get settings_ClearCache => 'Vider le cache';

  @override
  String get settings_AccessibilityTitle => 'Accessibilité';

  @override
  String get settings_AccessibilitySubtitle =>
      'Améliorer les fonctionnalités d\'accessibilité';

  @override
  String get settings_HighContrastTitle => 'Mode contraste élevé';

  @override
  String get settings_HighContrastDescription =>
      'Augmenter le contraste pour une meilleure visibilité';

  @override
  String get settings_ReduceMotionTitle => 'Réduire les animations';

  @override
  String get settings_ReduceMotionDescription =>
      'Minimiser les animations et transitions';

  @override
  String get settings_ScreenReaderTitle => 'Support du lecteur d\'écran';

  @override
  String get settings_ScreenReaderDescription =>
      'Compatibilité améliorée avec les lecteurs d\'écran';

  @override
  String get settings_PerformanceTitle => 'Performance';

  @override
  String get settings_PerformanceSubtitle =>
      'Optimiser les performances de l\'application';

  @override
  String get settings_AutoSaveTitle => 'Sauvegarde automatique';

  @override
  String get settings_AutoSaveDescription =>
      'Enregistrer automatiquement les modifications';

  @override
  String get settings_LazyLoadingTitle => 'Chargement progressif';

  @override
  String get settings_LazyLoadingDescription =>
      'Charger le contenu au fur et à mesure du défilement';

  @override
  String get settings_OfflineModeTitle => 'Mode hors ligne';

  @override
  String get settings_OfflineModeDescription =>
      'Travailler sans connexion Internet';

  @override
  String get settings_AdvancedTitle => 'Avancé';

  @override
  String get settings_AdvancedSubtitle =>
      'Fonctionnalités avancées et raccourcis';

  @override
  String get settings_KeyboardShortcutsTitle => 'Raccourcis clavier';

  @override
  String get settings_KeyboardShortcutsDescription =>
      'Activer la navigation au clavier';

  @override
  String get settings_DeveloperModeTitle => 'Mode développeur';

  @override
  String get settings_DeveloperModeDescription =>
      'Afficher les options de débogage avancées';

  @override
  String get settings_BetaFeaturesTitle => 'Fonctionnalités bêta';

  @override
  String get settings_BetaFeaturesDescription =>
      'Essayer les fonctionnalités expérimentales';

  @override
  String get settings_ViewKeyboardShortcuts => 'Voir les raccourcis clavier';

  @override
  String get settings_DangerTitle => 'Zone dangereuse';

  @override
  String get settings_DangerSubtitle => 'Actions irréversibles';

  @override
  String get settings_ResetAllSettings => 'Réinitialiser tous les paramètres';

  @override
  String get settings_DeleteAllData => 'Supprimer toutes les données';

  @override
  String get sidebar_dashboard => 'Tableau de bord';

  @override
  String get subtitle_dashboard => 'Gérez vos clients et devis';

  @override
  String get sidebar_clients => 'Clients';

  @override
  String get subtitle_clients => 'Voir et gérer tous les clients';

  @override
  String get sidebar_motorQuote => 'Devis automobile';

  @override
  String get subtitle_motorQuote => 'Gérer les devis automobiles';

  @override
  String get sidebar_policies => 'Polices';

  @override
  String get subtitle_policies => 'Voir et gérer les polices';

  @override
  String get sidebar_production => 'Production';

  @override
  String get subtitle_production => 'Suivre les indicateurs de production';

  @override
  String get sidebar_dmvic => 'DMVIC';

  @override
  String get subtitle_dmvic => 'Opérations liées au DMVIC';

  @override
  String get sidebar_dmvicDoubleInsurance => 'Double assurance DMVIC';

  @override
  String get subtitle_dmvicDoubleInsurance =>
      'Gérer les polices de double assurance DMVIC';

  @override
  String get sidebar_dmvicStock => 'Stock DMVIC';

  @override
  String get subtitle_dmvicStock => 'Gérer les polices liées au stock DMVIC';

  @override
  String get sidebar_statement => 'Relevé';

  @override
  String get subtitle_statement => 'Voir les relevés';

  @override
  String get sidebar_renewals => 'Renouvellements';

  @override
  String get subtitle_renewals => 'Suivre les renouvellements de polices';

  @override
  String get sidebar_certificates => 'Certificats';

  @override
  String get subtitle_certificates => 'Voir les certificats émis';

  @override
  String get sidebar_quotes => 'Devis';

  @override
  String get subtitle_quotes => 'Gérer les devis d\'assurance';

  @override
  String get sidebar_settings => 'Paramètres';

  @override
  String get subtitle_settings => 'Préférences de l\'application';

  @override
  String get sidebar_profile => 'Mon profil';

  @override
  String get subtitle_profile => 'Gérer votre compte';

  @override
  String get sidebar_notifications => 'Notifications';

  @override
  String get subtitle_notifications => 'Voir toutes vos notifications';

  @override
  String get sidebar_offlineQueueScreen => 'Écran de la file hors ligne';

  @override
  String get subtitle_offlineQueueScreen =>
      'Afficher toutes vos sauvegardes hors ligne';

  @override
  String get sidebar_logout => 'Déconnexion';

  @override
  String get sidebar_loading => 'Chargement...';

  @override
  String get sidebar_add_client => 'Ajouter un client';

  @override
  String get subtitle_add_client => 'Saisir les informations du nouveau client';

  @override
  String get subtitle_default => 'Toujours assuré';
}
