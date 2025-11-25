import 'package:flutter/material.dart';

import 'dart:ui';

import '../theme/app_colors.dart';

class FlickyNavItem {
  const FlickyNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class FlickyNavBar extends StatelessWidget {
  const FlickyNavBar({
    super.key,
    required this.currentIndex,
    required this.onChanged,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;
  final List<FlickyNavItem> items;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xB31B1D24),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final active = index == currentIndex;
              final slide =
                  (index - currentIndex).clamp(-1, 1).toDouble() * 0.1;

              return Expanded(
                flex: active ? 3 : 2,
                child: GestureDetector(
                  onTap: () => onChanged(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: EdgeInsets.symmetric(
                      horizontal: active ? 14 : 8,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: active
                          ? const LinearGradient(
                              colors: [Color(0xFFB00015), Color(0xFFE0001B)],
                            )
                          : null,
                      color: active ? null : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSlide(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOut,
                            offset: Offset(slide, 0),
                            child: Icon(
                              item.icon,
                              color: active ? Colors.white : AppColors.muted,
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            transitionBuilder: (child, anim) => FadeTransition(
                              opacity: anim,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.2, 0),
                                  end: Offset.zero,
                                ).animate(anim),
                                child: child,
                              ),
                            ),
                            child: active
                                ? Padding(
                                    key: ValueKey(item.label),
                                    padding: const EdgeInsets.only(left: 6),
                                    child: Text(
                                      item.label,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
