import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flowcycle/app/router/app_router.dart';
import 'package:flowcycle/core/data/app_data_manager.dart';
import 'package:flowcycle/core/localization/app_localizations.dart';
import 'package:flowcycle/core/localization/locale_controller.dart';
import 'package:flowcycle/core/theme/app_theme.dart';
import 'package:flowcycle/shared/providers/app_scope.dart';
import 'package:flowcycle/shared/providers/cycle_data_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization notice: $e (running in local/offline fallback mode)');
  }
  await AppDataManager.instance.initialize();
  runApp(const FlowCycleApp());
}

class FlowCycleApp extends StatelessWidget {
  const FlowCycleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScope(
      controller: CycleDataController.instance,
      child: ListenableBuilder(
        listenable: Listenable.merge([
          LocaleController.instance,
          CycleDataController.instance,
        ]),
        builder: (context, _) {
          final themeId = CycleDataController.instance.selectedThemeId;
          return MaterialApp.router(
            title: 'FlowCycle',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeById(themeId),
            routerConfig: appRouter,
            locale: LocaleController.instance.currentLocale,
            supportedLocales: LocaleController.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
