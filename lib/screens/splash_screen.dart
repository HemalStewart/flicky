import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/background_collage.dart';
import '../widgets/flicky_mark.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const BackgroundCollage(
            assetPath: 'assets/images/splash_bg.png',
            dim: 0.65,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FlickyMark(size: 160),
                const SizedBox(height: 24),
                Text(
                  'Flicky',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  'The phrase “Copyright Reserved” or “All Rights Reserved” is a legal statement used in copyright notices to indicate that the copyright holder retains all exclusive rights to their work.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.muted, fontSize: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
