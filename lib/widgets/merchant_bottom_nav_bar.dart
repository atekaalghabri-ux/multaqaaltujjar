import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../core/theme/app_theme.dart';
import '../core/localization/app_localizations.dart';
import 'bulk_icon.dart';

class MerchantBottomNavBar extends StatelessWidget {
  final String currentPath;

  const MerchantBottomNavBar({super.key, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(
              context,
              icon: Iconsax.user,
              label: context.tr('profile'),
              path: 'profile',
              route: '/profile',
            ),
            _buildNavItem(
              context,
              icon: Iconsax.box,
              label: context.tr('orders_nav'),
              path: 'orders',
              route: '/merchant_orders',
            ),
            _buildNavItem(
              context,
              icon: Iconsax.bag,
              label: context.tr('products_nav'),
              path: 'products',
              route: '/manage_products',
            ),
            _buildNavItem(
              context,
              icon: Iconsax.home_2,
              label: context.tr('dashboard_nav'),
              path: 'dashboard',
              route: '/merchant_dashboard',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {
    required IconData icon,
    required String label,
    required String path,
    required String route,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = currentPath == path;
    final color = isSelected 
        ? (isDark ? AppColors.primary[300] : AppColors.primary[500]) 
        : (isDark ? Colors.white70 : AppColors.neutral[400]);

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          context.go(route);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? (isDark ? const Color(0xFF2C2522) : AppColors.primary[50]) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isSelected
                ? BulkIcon(icon: icon, color: AppColors.primary[500], size: 24)
                : Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.cairo(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
