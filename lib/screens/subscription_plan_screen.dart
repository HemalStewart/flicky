import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/background_collage.dart';
import '../widgets/flicky_mark.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  const SubscriptionPlanScreen({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  String _plan = 'monthly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          const BackgroundCollage(
            assetPath: 'assets/images/subscribe_bg.png',
            dim: 0.55,
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Hero(
                  tag: 'flicky-logo',
                  child: FlickyMark(size: 120),
                ),
                const SizedBox(height: 12),
                Text(
                  'Flicky',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 22,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(31, 31, 35, 0.94),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Buy Our Subscription',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _PlanTile(
                          title: 'Monthly',
                          subtitle: 'Most popular',
                          price: 'Rs.399',
                          selected: _plan == 'monthly',
                          onTap: () => setState(() => _plan = 'monthly'),
                        ),
                        const SizedBox(height: 14),
                        _PlanTile(
                          title: 'Yearly',
                          subtitle: 'Most suitable plan',
                          price: 'Rs.8499',
                          selected: _plan == 'yearly',
                          onTap: () => setState(() => _plan = 'yearly'),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: widget.onContinue,
                            child: const Text(
                              'Subscribe',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            'The phrase “Copyright Reserved” or “All Rights Reserved” is a legal statement used in copyright notices to indicate that the copyright holder retains all exclusive rights to their work.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFECEFF4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.accent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              price,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
