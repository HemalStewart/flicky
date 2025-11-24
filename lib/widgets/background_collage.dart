import 'package:flutter/material.dart';

class BackgroundCollage extends StatelessWidget {
  const BackgroundCollage({super.key, required this.assetPath, this.dim = 0.7});

  final String assetPath;
  final double dim;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            Color.fromRGBO(0, 0, 0, dim),
            BlendMode.darken,
          ),
          child: Image.asset(
            assetPath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Surface a visible placeholder if the asset failed to load.
              debugPrint('Background asset missing: $assetPath -> $error');
              return Container(
                color: const Color(0xFF0F1117),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
