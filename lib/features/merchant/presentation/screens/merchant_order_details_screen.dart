import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/app_localizations.dart';

class MerchantOrderDetailsScreen extends StatelessWidget {
  const MerchantOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
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
                          context.go('/merchant_orders');
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
            const SizedBox(height: 20),

            // Order Header Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${context.tr('order_number')}1024',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      context.tr('mock_order_date'),
                      style: GoogleFonts.cairo(
                        color: isDark ? Colors.grey[400] : AppColors.neutral[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Products Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return _buildProductCard(context);
                },
              ),
            ),

            // Bottom Summary & Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black38 : Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr('total'),
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '92,000 ${context.tr('currency')}',
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isDark ? const Color(0xFFC39088) : AppColors.primary[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionBtn(
                          title: context.tr('cancel'),
                          color: isDark ? Colors.redAccent : Colors.red.shade700,
                          bgColor: isDark ? const Color(0xFF331111) : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionBtn(
                          title: context.tr('suspend'),
                          color: isDark ? Colors.amberAccent : Colors.amber.shade800,
                          bgColor: isDark ? const Color(0xFF332B11) : Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionBtn(
                          title: context.tr('confirm'),
                          color: isDark ? Colors.greenAccent : Colors.green.shade700,
                          bgColor: isDark ? const Color(0xFF113311) : Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isDark ? const Color(0xFF2C2C2C) : AppColors.primary[50],
            ),
            child: Stack(
              children: [
                Center(
                  child: Image.network(
                    'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=200&auto=format&fit=crop',
                    fit: BoxFit.cover,
                  ),
                ),
                PositionedDirectional(
                  top: 8,
                  start: 8,
                  child: Icon(Iconsax.heart, color: isDark ? Colors.grey[600] : AppColors.neutral[400], size: 20),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.tr('mock_product_name'),
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '60 ${context.tr('currency')}',
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: isDark ? Colors.grey[500] : AppColors.neutral[400],
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '30 ${context.tr('currency')}',
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDark ? const Color(0xFFC39088) : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionBtn({
    required String title,
    required Color color,
    required Color bgColor,
    required BorderRadius borderRadius,
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
