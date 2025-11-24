import 'package:flutter/material.dart';

import 'screens/main_shell.dart';
import 'screens/splash_screen.dart';
import 'screens/subscription_plan_screen.dart';
import 'screens/subscribe_screen.dart';
import 'theme/app_theme.dart';

enum AppStage { splash, plan, phone, main }

class FlickyApp extends StatefulWidget {
  const FlickyApp({super.key});

  @override
  State<FlickyApp> createState() => _FlickyAppState();
}

class _FlickyAppState extends State<FlickyApp> {
  AppStage _stage = AppStage.splash;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _stage == AppStage.splash) {
        setState(() => _stage = AppStage.plan);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget home;
    switch (_stage) {
      case AppStage.splash:
        home = const SplashScreen();
        break;
      case AppStage.plan:
        home = SubscriptionPlanScreen(
          onContinue: () {
            setState(() => _stage = AppStage.phone);
          },
        );
        break;
      case AppStage.phone:
        home = SubscribeScreen(
          onContinue: () => setState(() => _stage = AppStage.main),
        );
        break;
      case AppStage.main:
        home = FlickyShell(
          tabIndex: _tabIndex,
          onTabChanged: (value) => setState(() => _tabIndex = value),
        );
        break;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flicky',
      theme: buildAppTheme(),
      home: home,
    );
  }
}
