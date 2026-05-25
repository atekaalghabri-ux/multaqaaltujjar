import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../widgets/merchant_bottom_nav_bar.dart';

class MerchantOrdersScreen extends StatelessWidget {
  const MerchantOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF3E2D2A) : const Color(0xFFF8ECE9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/merchant_dashboard');
                            }
                          },
                          child: Icon(
                            isAr ? Iconsax.arrow_right_3 : Iconsax.arrow_left_2,
                            color: isDark ? const Color(0xFFC39088) : AppColors.primary[700],
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          context.tr('manage_orders_nav'),
                          style: GoogleFonts.cairo(
                            color: isDark ? Colors.white : AppColors.primary[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Orders List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 100),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return _buildOrderCard(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: MerchantBottomNavBar(currentPath: 'orders'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // Top Card (Order Details)
          GestureDetector(
            onTap: () => context.push('/merchant_order_details'),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isAr ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                            size: 14,
                            color: isDark ? Colors.grey[400] : AppColors.neutral[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.tr('view_details'),
                            style: GoogleFonts.cairo(
                              color: isDark ? Colors.grey[400] : AppColors.neutral[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${context.tr('order_number')}1024',
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.tr('mock_order_date'),
                    style: GoogleFonts.cairo(
                      color: isDark ? Colors.grey[400] : AppColors.neutral[500],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '92,000 ${context.tr('currency')}',
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFFC39088) : AppColors.primary[500],
                          fontSize: 16,
                        ),
                      ),
                      // Product Avatars
                      SizedBox(
                        width: 96,
                        height: 32,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            PositionedDirectional(start: 64, child: _buildProductAvatar(context)),
                            PositionedDirectional(start: 48, child: _buildProductAvatar(context)),
                            PositionedDirectional(start: 32, child: _buildProductAvatar(context)),
                            PositionedDirectional(start: 16, child: _buildProductAvatar(context)),
                            PositionedDirectional(start: 0, child: _buildAvatarBadge(context, '+7')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Actions
          Row(
            children: [
              Expanded(
                child: _buildActionBtn(
                  title: context.tr('cancel'),
                  color: isDark ? Colors.redAccent : Colors.red.shade700,
                  bgColor: isDark ? const Color(0xFF331111) : const Color(0xFFFFF0F0),
                  borderRadius: const BorderRadiusDirectional.only(bottomStart: Radius.circular(16)),
                ),
              ),
              Expanded(
                child: _buildActionBtn(
                  title: context.tr('suspend'),
                  color: isDark ? Colors.amberAccent : Colors.amber.shade800,
                  bgColor: isDark ? const Color(0xFF332B11) : const Color(0xFFFFFDF0),
                  borderRadius: BorderRadius.zero,
                ),
              ),
              Expanded(
                child: _buildActionBtn(
                  title: context.tr('confirm'),
                  color: isDark ? Colors.greenAccent : Colors.green.shade700,
                  bgColor: isDark ? const Color(0xFF113311) : const Color(0xFFF0FFF0),
                  borderRadius: const BorderRadiusDirectional.only(bottomEnd: Radius.circular(16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductAvatar(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(context).cardColor, width: 2),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1556821840-3a63f95609a7?q=80&w=100&auto=format&fit=crop'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAvatarBadge(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.black,
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(context).cardColor, width: 2),
      ),
      child: Text(
        text,
        style: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionBtn({
    required String title,
    required Color color,
    required Color bgColor,
    required BorderRadiusGeometry borderRadius,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: GoogleFonts.cairo(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
