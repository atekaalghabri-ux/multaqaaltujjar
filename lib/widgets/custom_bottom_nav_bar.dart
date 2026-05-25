import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/app_localizations.dart';

// --- محرك التدرج للأيقونات (Bulk Effect) ---
Widget buildBulkIcon(IconData icon, {double size = 24, Color? color}) {
  return ShaderMask(
    shaderCallback: (Rect bounds) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color ?? const Color(0xFF99574D),
          (color ?? const Color(0xFF99574D)).withOpacity(0.4),
        ],
      ).createShader(bounds);
    },
    child: Icon(icon, size: size, color: Colors.white),
  );
}

class CustomBottomNavBar extends StatelessWidget {
  final String currentPath;
  const CustomBottomNavBar({super.key, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF3EBE6),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.black.withOpacity(0.1),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            context,
            Iconsax.home_15,
            context.tr('home'),
            currentPath == 'home',
            () {
              if (currentPath != 'home') {
                context.go('/dashboard');
              }
            },
          ),
          _navItem(
            context,
            Iconsax.shopping_cart5,
            context.tr('cart'),
            currentPath == 'cart',
            () {
              if (currentPath != 'cart') {
                context.go('/cart');
              }
            },
          ),
          _navItem(
            context,
            Iconsax.archive_book5,
            context.tr('my_orders'),
            currentPath == 'orders',
            () {
              if (currentPath != 'orders') {
                context.go('/orders');
              }
            },
          ),
          _navItem(
            context,
            Iconsax.profile_circle5,
            context.tr('profile'),
            currentPath == 'profile',
            () {
              if (currentPath != 'profile') {
                context.go('/profile');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, bool active, VoidCallback onTap) {
    return active
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF99574D),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        : _navIcon(icon, onTap);
  }

  Widget _navIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildBulkIcon(icon, color: const Color(0xFF99574D)),
      ),
    );
  }
}

