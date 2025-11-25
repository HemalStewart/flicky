import 'package:flutter/material.dart';

import 'routes/fade_slide_route.dart';
import 'screens/main_shell.dart';
import 'screens/splash_screen.dart';
import 'screens/subscription_plan_screen.dart';
import 'screens/subscribe_screen.dart';
import 'theme/app_theme.dart';

class FlickyApp extends StatelessWidget {
  const FlickyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    void goToMain() {
      final nav = navigatorKey.currentState;
      nav?.pushReplacement(
        FadeSlideRoute(page: const FlickyShell()),
      );
    }

    void goToPhone() {
      final nav = navigatorKey.currentState;
      nav?.pushReplacement(
        FadeSlideRoute(
          page: SubscribeScreen(onContinue: goToMain),
        ),
      );
    }

    void goToPlan() {
      final nav = navigatorKey.currentState;
      nav?.pushReplacement(
        FadeSlideRoute(
          page: SubscriptionPlanScreen(onContinue: goToPhone),
        ),
      );
    }

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flicky',
      theme: buildDarkTheme(),
      themeMode: ThemeMode.dark,
      home: SplashScreen(onFinish: goToPlan),
    );
  }
}
