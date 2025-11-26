import 'package:flutter/material.dart';

import 'routes/fade_slide_route.dart';
import 'screens/main_shell.dart';
import 'screens/otp_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/subscription_plan_screen.dart';
import 'screens/subscribe_screen.dart';
import 'services/auth_service.dart';
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
          page: SubscribeScreen(
            onLoginSuccess: goToMain,
            onOtpRequested: (mobile) {
              final navInner = navigatorKey.currentState;
              navInner?.pushReplacement(
                FadeSlideRoute(
                  page: OtpScreen(
                    mobile: mobile,
                    onVerified: goToMain,
                    onEditNumber: goToPhone,
                  ),
                ),
              );
            },
          ),
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

    void handleSplashDone() async {
      final hasSession = await AuthService.instance.hasActiveSession();
      if (hasSession) {
        goToMain();
      } else {
        goToPlan();
      }
    }

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flicky',
      theme: buildDarkTheme(),
      themeMode: ThemeMode.dark,
      home: SplashScreen(onFinish: handleSplashDone),
    );
  }
}
