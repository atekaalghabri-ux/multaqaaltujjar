import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class BulkIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;

  const BulkIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color ?? AppColors.primary[500]!,
            (color ?? AppColors.primary[500]!).withOpacity(0.4),
          ],
        ).createShader(bounds);
      },
      child: Icon(icon, size: size, color: Colors.white),
    );
  }
}
