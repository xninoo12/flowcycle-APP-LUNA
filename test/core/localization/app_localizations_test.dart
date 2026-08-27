import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/core/localization/app_localizations.dart';
import 'package:flowcycle/core/localization/locale_controller.dart';

void main() {
  group('AppLocalizations & LocaleController Comprehensive Test Suite', () {
    test('1. English (en) dictionary covers all essential keys', () {
      final locEn = AppLocalizations(const Locale('en'));

      expect(locEn.tabToday, 'Today');
      expect(locEn.tabCalendar, 'Calendar');
      expect(locEn.tabLog, 'Log');
      expect(locEn.tabInsights, 'Insights');
      expect(locEn.tabAi, 'AI Companion');
      expect(locEn.tabProfile, 'Profile');

      expect(locEn.modeCycleAwareness, 'Cycle Awareness');
      expect(locEn.modeTtc, 'Trying to Conceive');

      expect(locEn.phaseMenstrual, 'Menstrual Phase');
      expect(locEn.phaseFollicular, 'Follicular Phase');
      expect(locEn.phaseOvulatory, 'Ovulatory Phase');
      expect(locEn.phaseLuteal, 'Luteal Phase');

      expect(locEn.logTitle, 'Daily Log');
      expect(locEn.logSave, 'Save Log');
      expect(locEn.logAllSet, 'All Set!');

      expect(locEn.patternsTitle, 'Patterns & Biomarkers');
      expect(locEn.remindersTitle, 'Reminders & Alerts');
      expect(locEn.privacyTitle, 'Privacy & Security');
      expect(locEn.backupTitle, 'Data Backup & Restore');
    });

    test('2. Spanish (es) dictionary provides accurate localized translations', () {
      final locEs = AppLocalizations(const Locale('es'));

      expect(locEs.tabToday, 'Hoy');
      expect(locEs.tabCalendar, 'Calendario');
      expect(locEs.tabLog, 'Registro');
      expect(locEs.tabInsights, 'Estadísticas');
      expect(locEs.tabAi, 'Compañera IA');
      expect(locEs.tabProfile, 'Perfil');

      expect(locEs.modeCycleAwareness, 'Conciencia del Ciclo');
      expect(locEs.modeTtc, 'Buscando Embarazo');

      expect(locEs.phaseMenstrual, 'Fase Menstrual');
      expect(locEs.phaseFollicular, 'Fase Folicular');
      expect(locEs.phaseOvulatory, 'Fase Ovulatoria');
      expect(locEs.phaseLuteal, 'Fase Lútea');

      expect(locEs.logTitle, 'Registro Diario');
      expect(locEs.logSave, 'Guardar Registro');
      expect(locEs.patternsTitle, 'Patrones y Biomarcadores');
    });

    test('3. French (fr) dictionary provides accurate localized translations', () {
      final locFr = AppLocalizations(const Locale('fr'));

      expect(locFr.tabToday, 'Aujourd\'hui');
      expect(locFr.tabCalendar, 'Calendrier');
      expect(locFr.tabLog, 'Journal');
      expect(locFr.tabInsights, 'Statistiques');
      expect(locFr.tabAi, 'Compagne IA');
      expect(locFr.tabProfile, 'Profil');

      expect(locFr.modeCycleAwareness, 'Conscience du Cycle');
      expect(locFr.modeTtc, 'Projet Bébé (TTC)');

      expect(locFr.phaseMenstrual, 'Phase Menstruelle');
      expect(locFr.phaseFollicular, 'Phase Folliculaire');
      expect(locFr.phaseOvulatory, 'Phase Ovulatoire');
      expect(locFr.phaseLuteal, 'Phase Lutéale');

      expect(locFr.logTitle, 'Journal Quotidien');
      expect(locFr.logSave, 'Enregistrer');
      expect(locFr.patternsTitle, 'Tendances et Biomarqueurs');
    });

    test('4. German (de) dictionary provides accurate localized translations', () {
      final locDe = AppLocalizations(const Locale('de'));

      expect(locDe.tabToday, 'Heute');
      expect(locDe.tabCalendar, 'Kalender');
      expect(locDe.tabLog, 'Eintrag');
      expect(locDe.tabInsights, 'Einblicke');
      expect(locDe.tabAi, 'KI-Begleiterin');
      expect(locDe.tabProfile, 'Profil');

      expect(locDe.modeCycleAwareness, 'Zyklusbewusstsein');
      expect(locDe.modeTtc, 'Kinderwunsch (TTC)');

      expect(locDe.phaseMenstrual, 'Menstruationsphase');
      expect(locDe.phaseFollicular, 'Follikelphase');
      expect(locDe.phaseOvulatory, 'Ovulationsphase');
      expect(locDe.phaseLuteal, 'Lutealphase');

      expect(locDe.logTitle, 'Täglicher Eintrag');
      expect(locDe.logSave, 'Eintrag Speichern');
      expect(locDe.patternsTitle, 'Muster & Biomarker');
    });

    test('5. LocaleController manages active language and notifies listeners', () {
      final controller = LocaleController.instance;
      int notificationCount = 0;
      void listener() => notificationCount++;

      controller.addListener(listener);

      controller.setLanguageCode('es');
      expect(controller.currentLocale.languageCode, 'es');
      expect(controller.currentLanguageName, 'Español (Spanish)');
      expect(controller.currentLanguageFlag, '🇪🇸');
      expect(notificationCount, 1);

      controller.setLanguageCode('fr');
      expect(controller.currentLocale.languageCode, 'fr');
      expect(controller.currentLanguageName, 'Français (French)');
      expect(controller.currentLanguageFlag, '🇫🇷');
      expect(notificationCount, 2);

      controller.setLanguageCode('de');
      expect(controller.currentLocale.languageCode, 'de');
      expect(controller.currentLanguageName, 'Deutsch (German)');
      expect(controller.currentLanguageFlag, '🇩🇪');
      expect(notificationCount, 3);

      // Revert to English
      controller.setLanguageCode('en');
      expect(controller.currentLocale.languageCode, 'en');
      expect(controller.currentLanguageName, 'English (US)');
      expect(controller.currentLanguageFlag, '🇺🇸');
      expect(notificationCount, 4);

      controller.removeListener(listener);
    });

    test('6. AppLocalizationsDelegate validates supported locales', () {
      const delegate = AppLocalizations.delegate;

      expect(delegate.isSupported(const Locale('en')), isTrue);
      expect(delegate.isSupported(const Locale('es')), isTrue);
      expect(delegate.isSupported(const Locale('fr')), isTrue);
      expect(delegate.isSupported(const Locale('de')), isTrue);
      expect(delegate.isSupported(const Locale('ja')), isFalse);
      expect(delegate.shouldReload(delegate), isFalse);
    });
  });
}
