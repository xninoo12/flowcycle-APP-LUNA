import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Comprehensive typed localization dictionary and provider for FlowCycle.
/// Supports English (en), Spanish (es), French (fr), and German (de).
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Navigation & Tabs
      'tab_today': 'Today',
      'tab_calendar': 'Calendar',
      'tab_log': 'Log',
      'tab_insights': 'Insights',
      'tab_community': 'Community',
      'tab_ai': 'AI Companion',
      'tab_profile': 'Profile',

      // App Modes
      'mode_cycle_awareness': 'Cycle Awareness',
      'mode_ttc': 'Trying to Conceive',
      'mode_track_cycle': 'Track Cycle',
      'mode_conception': 'Conception Hub',

      // Cycle Phases
      'phase_menstrual': 'Menstrual Phase',
      'phase_follicular': 'Follicular Phase',
      'phase_ovulatory': 'Ovulatory Phase',
      'phase_luteal': 'Luteal Phase',

      // Daily Logging
      'log_title': 'Daily Log',
      'log_save': 'Save Log',
      'log_all_set': 'All Set!',
      'flow_title': 'Period Flow',
      'flow_none': 'None',
      'flow_spotting': 'Spotting',
      'flow_light': 'Light',
      'flow_medium': 'Medium',
      'flow_heavy': 'Heavy',
      'mood_title': 'Mood',
      'mood_great': 'Great',
      'mood_good': 'Good',
      'mood_okay': 'Okay',
      'mood_low': 'Low',
      'mood_awful': 'Awful',
      'energy_title': 'Energy Level',
      'energy_low': 'Low',
      'energy_medium': 'Medium',
      'energy_high': 'High',
      'symptoms_title': 'Symptoms & Body',
      'bbt_title': 'Basal Body Temperature',
      'mucus_title': 'Cervical Fluid',
      'lh_title': 'LH Ovulation Test',

      // Patterns & Clinical
      'patterns_title': 'Patterns & Biomarkers',
      'symptom_matrix': 'Symptom Correlation Matrix',
      'bbt_curve': 'Biphasic BBT Thermal Shift',
      'mood_energy_rhythm': 'Mood & Energy Rhythm',
      'doctor_export': 'Doctor / OB-GYN Clinical Export',

      // Settings & Security
      'settings_title': 'App Preferences',
      'reminders_title': 'Reminders & Alerts',
      'privacy_title': 'Privacy & Security',
      'pin_lock': '4-Digit Passcode Lock',
      'backup_title': 'Data Backup & Restore',
      'export_data': 'Export Cycle Data',
      'restore_data': 'Restore Data from Backup',
      'language': 'Language',
      'units': 'Units & Measurement',
      'help_center': 'Help & FAQ',
      'contact_support': 'Contact Support',
      'rate_app': 'Rate FlowCycle',
      'about_app': 'About FlowCycle',
      'logout': 'Log Out',
    },
    'es': {
      // Navigation & Tabs
      'tab_today': 'Hoy',
      'tab_calendar': 'Calendario',
      'tab_log': 'Registro',
      'tab_insights': 'Estadísticas',
      'tab_community': 'Comunidad',
      'tab_ai': 'Compañera IA',
      'tab_profile': 'Perfil',

      // App Modes
      'mode_cycle_awareness': 'Conciencia del Ciclo',
      'mode_ttc': 'Buscando Embarazo',
      'mode_track_cycle': 'Seguimiento',
      'mode_conception': 'Centro de Concepción',

      // Cycle Phases
      'phase_menstrual': 'Fase Menstrual',
      'phase_follicular': 'Fase Folicular',
      'phase_ovulatory': 'Fase Ovulatoria',
      'phase_luteal': 'Fase Lútea',

      // Daily Logging
      'log_title': 'Registro Diario',
      'log_save': 'Guardar Registro',
      'log_all_set': '¡Todo Listo!',
      'flow_title': 'Flujo Menstrual',
      'flow_none': 'Ninguno',
      'flow_spotting': 'Manchado',
      'flow_light': 'Ligero',
      'flow_medium': 'Moderado',
      'flow_heavy': 'Abundante',
      'mood_title': 'Estado de Ánimo',
      'mood_great': 'Excelente',
      'mood_good': 'Bueno',
      'mood_okay': 'Normal',
      'mood_low': 'Bajo',
      'mood_awful': 'Muy Bajo',
      'energy_title': 'Nivel de Energía',
      'energy_low': 'Baja',
      'energy_medium': 'Media',
      'energy_high': 'Alta',
      'symptoms_title': 'Síntomas y Cuerpo',
      'bbt_title': 'Temperatura Basal',
      'mucus_title': 'Moco Cervical',
      'lh_title': 'Prueba de Ovulación LH',

      // Patterns & Clinical
      'patterns_title': 'Patrones y Biomarcadores',
      'symptom_matrix': 'Matriz de Correlación de Síntomas',
      'bbt_curve': 'Curva Térmica Bifásica BBT',
      'mood_energy_rhythm': 'Ritmo de Ánimo y Energía',
      'doctor_export': 'Exportar Informe para el Médico',

      // Settings & Security
      'settings_title': 'Preferencias de la App',
      'reminders_title': 'Recordatorios y Alertas',
      'privacy_title': 'Privacidad y Seguridad',
      'pin_lock': 'Bloqueo con PIN de 4 Dígitos',
      'backup_title': 'Copia de Seguridad y Restauración',
      'export_data': 'Exportar Datos del Ciclo',
      'restore_data': 'Restaurar desde Copia de Seguridad',
      'language': 'Idioma',
      'units': 'Unidades de Medida',
      'help_center': 'Centro de Ayuda y FAQ',
      'contact_support': 'Contactar Soporte',
      'rate_app': 'Calificar FlowCycle',
      'about_app': 'Acerca de FlowCycle',
      'logout': 'Cerrar Sesión',
    },
    'fr': {
      // Navigation & Tabs
      'tab_today': 'Aujourd\'hui',
      'tab_calendar': 'Calendrier',
      'tab_log': 'Journal',
      'tab_insights': 'Statistiques',
      'tab_community': 'Communauté',
      'tab_ai': 'Compagne IA',
      'tab_profile': 'Profil',

      // App Modes
      'mode_cycle_awareness': 'Conscience du Cycle',
      'mode_ttc': 'Projet Bébé (TTC)',
      'mode_track_cycle': 'Suivre le Cycle',
      'mode_conception': 'Espace Conception',

      // Cycle Phases
      'phase_menstrual': 'Phase Menstruelle',
      'phase_follicular': 'Phase Folliculaire',
      'phase_ovulatory': 'Phase Ovulatoire',
      'phase_luteal': 'Phase Lutéale',

      // Daily Logging
      'log_title': 'Journal Quotidien',
      'log_save': 'Enregistrer',
      'log_all_set': 'Tout est prêt !',
      'flow_title': 'Flux Menstruel',
      'flow_none': 'Aucun',
      'flow_spotting': 'Spotting',
      'flow_light': 'Léger',
      'flow_medium': 'Moyen',
      'flow_heavy': 'Abondant',
      'mood_title': 'Humeur',
      'mood_great': 'Super',
      'mood_good': 'Bien',
      'mood_okay': 'Neutre',
      'mood_low': 'Morose',
      'mood_awful': 'Difficile',
      'energy_title': 'Niveau d\'Énergie',
      'energy_low': 'Faible',
      'energy_medium': 'Moyen',
      'energy_high': 'Élevé',
      'symptoms_title': 'Symptômes et Corps',
      'bbt_title': 'Température Basale',
      'mucus_title': 'Glaire Cervicale',
      'lh_title': 'Test d\'Ovulation LH',

      // Patterns & Clinical
      'patterns_title': 'Tendances et Biomarqueurs',
      'symptom_matrix': 'Matrice des Symptômes',
      'bbt_curve': 'Courbe Thermique Basale',
      'mood_energy_rhythm': 'Rythme Énergie et Humeur',
      'doctor_export': 'Rapport Médical Gynécologue',

      // Settings & Security
      'settings_title': 'Préférences de l\'App',
      'reminders_title': 'Rappels et Alertes',
      'privacy_title': 'Confidentialité et Sécurité',
      'pin_lock': 'Code PIN à 4 Chiffres',
      'backup_title': 'Sauvegarde et Restauration',
      'export_data': 'Exporter les Données',
      'restore_data': 'Restaurer depuis Sauvegarde',
      'language': 'Langue',
      'units': 'Unités de Mesure',
      'help_center': 'Aide et FAQ',
      'contact_support': 'Contacter le Support',
      'rate_app': 'Noter FlowCycle',
      'about_app': 'À propos de FlowCycle',
      'logout': 'Se Déconnecter',
    },
    'de': {
      // Navigation & Tabs
      'tab_today': 'Heute',
      'tab_calendar': 'Kalender',
      'tab_log': 'Eintrag',
      'tab_insights': 'Einblicke',
      'tab_community': 'Community',
      'tab_ai': 'KI-Begleiterin',
      'tab_profile': 'Profil',

      // App Modes
      'mode_cycle_awareness': 'Zyklusbewusstsein',
      'mode_ttc': 'Kinderwunsch (TTC)',
      'mode_track_cycle': 'Zyklus Tracken',
      'mode_conception': 'Empfängnis-Zentrum',

      // Cycle Phases
      'phase_menstrual': 'Menstruationsphase',
      'phase_follicular': 'Follikelphase',
      'phase_ovulatory': 'Ovulationsphase',
      'phase_luteal': 'Lutealphase',

      // Daily Logging
      'log_title': 'Täglicher Eintrag',
      'log_save': 'Eintrag Speichern',
      'log_all_set': 'Alles Erledigt!',
      'flow_title': 'Periodenblutung',
      'flow_none': 'Keine',
      'flow_spotting': 'Schmierblutung',
      'flow_light': 'Leicht',
      'flow_medium': 'Mittel',
      'flow_heavy': 'Stark',
      'mood_title': 'Stimmung',
      'mood_great': 'Großartig',
      'mood_good': 'Gut',
      'mood_okay': 'Okay',
      'mood_low': 'Gedrückt',
      'mood_awful': 'Sehr Schlecht',
      'energy_title': 'Energieniveau',
      'energy_low': 'Niedrig',
      'energy_medium': 'Mittel',
      'energy_high': 'Hoch',
      'symptoms_title': 'Symptome & Körper',
      'bbt_title': 'Basaltemperatur',
      'mucus_title': 'Zervixschleim',
      'lh_title': 'LH-Ovulationstest',

      // Patterns & Clinical
      'patterns_title': 'Muster & Biomarker',
      'symptom_matrix': 'Symptom-Korrelationsmatrix',
      'bbt_curve': 'Biphasische Basaltemperaturkurve',
      'mood_energy_rhythm': 'Stimmungs- und Energierhythmus',
      'doctor_export': 'Ärztlicher Befundbericht',

      // Settings & Security
      'settings_title': 'App-Einstellungen',
      'reminders_title': 'Erinnerungen & Alarme',
      'privacy_title': 'Datenschutz & Sicherheit',
      'pin_lock': '4-stellige PIN-Sperre',
      'backup_title': 'Datensicherung & Wiederherstellung',
      'export_data': 'Zyklusdaten Exportieren',
      'restore_data': 'Aus Sicherung Wiederherstellen',
      'language': 'Sprache',
      'units': 'Maßeinheiten',
      'help_center': 'Hilfebereich & FAQ',
      'contact_support': 'Support Kontaktieren',
      'rate_app': 'FlowCycle Bewerten',
      'about_app': 'Über FlowCycle',
      'logout': 'Abmelden',
    },
  };

  /// Translates a key based on the current locale, falling back to English.
  String translate(String key) {
    final langCode = locale.languageCode;
    return _localizedValues[langCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  /// Shorthand translation method.
  String t(String key) => translate(key);

  // Convenient Typed Getters
  String get tabToday => translate('tab_today');
  String get tabCalendar => translate('tab_calendar');
  String get tabLog => translate('tab_log');
  String get tabInsights => translate('tab_insights');
  String get tabCommunity => translate('tab_community');
  String get tabAi => translate('tab_ai');
  String get tabProfile => translate('tab_profile');

  String get modeCycleAwareness => translate('mode_cycle_awareness');
  String get modeTtc => translate('mode_ttc');

  String get phaseMenstrual => translate('phase_menstrual');
  String get phaseFollicular => translate('phase_follicular');
  String get phaseOvulatory => translate('phase_ovulatory');
  String get phaseLuteal => translate('phase_luteal');

  String get logTitle => translate('log_title');
  String get logSave => translate('log_save');
  String get logAllSet => translate('log_all_set');

  String get patternsTitle => translate('patterns_title');
  String get settingsTitle => translate('settings_title');
  String get remindersTitle => translate('reminders_title');
  String get privacyTitle => translate('privacy_title');
  String get backupTitle => translate('backup_title');
  String get language => translate('language');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'es', 'fr', 'de'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
