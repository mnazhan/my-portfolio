import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/l10n/locale_notifier.dart';
import 'package:my_portfolio/core/router/app_router.dart';
import 'package:my_portfolio/core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

/// Global scroll behaviour: replaces the default Android-style glow overscroll
/// with iOS BouncingScrollPhysics on every platform.
class _BouncingScrollBehaviour extends ScrollBehavior {
  const _BouncingScrollBehaviour();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      );

  // Keep all platform gestures (mouse drag, touch, trackpad).
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(appLocaleProvider);

    return MaterialApp.router(
          title: 'Nazhan Fahmy | Flutter Developer',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          routerConfig: AppRouter.router,

          // ── Localisation ──────────────────────────────────────────────
          locale: currentLocale,
          supportedLocales: supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          scrollBehavior: const _BouncingScrollBehaviour(),
        );
  }
}
