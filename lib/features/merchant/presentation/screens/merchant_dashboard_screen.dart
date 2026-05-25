import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../widgets/bulk_icon.dart';
import '../../../../widgets/merchant_bottom_nav_bar.dart';

class MerchantDashboardScreen extends StatelessWidget {
  const MerchantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100), // padding for bottom bar
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Top Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // Notification Bell
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF3E2D2A) : AppColors.primary[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: BulkIcon(
                            icon: Iconsax.notification,
                            color: isDark ? Colors.white : AppColors.primary[700],
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Store Info Bar
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isDark 
                                    ? [const Color(0xFF3E2D2A), const Color(0xFF2C2220)] 
                                    : [AppColors.primary[200]!, AppColors.primary[50]!],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               Text(
                                  context.tr('store_name'),
                                  style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : AppColors.primary[700],
                                    fontSize: 16,
                                  ),
                                ),
                                Icon(
                                  isAr ? Iconsax.arrow_left_2 : Iconsax.arrow_right_3, 
                                  color: isDark ? Colors.white : AppColors.primary[700], 
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Statistics
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('statistics'),
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Profits Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: isDark ? Colors.black38 : Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const BulkIcon(icon: Iconsax.wallet_add, color: Colors.green, size: 28),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    context.tr('earnings'),
                                    style: GoogleFonts.cairo(
                                      fontSize: 12,
                                      color: isDark ? Colors.grey[400] : AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    '40,689 ${context.tr('currency')}',
                                    style: GoogleFonts.cairo(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Mini stats Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildMiniStatCard(
                                context,
                                title: context.tr('orders_count'),
                                value: '3,334',
                                icon: Iconsax.box,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMiniStatCard(
                                context,
                                title: context.tr('active_products'),
                                value: '1,000',
                                icon: Iconsax.bag,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Order Management Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.tr('manage_orders_nav'),
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2C2220) : AppColors.primary[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                context.tr('daily'), 
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  color: isDark ? Colors.white70 : Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.keyboard_arrow_down, size: 16, color: isDark ? Colors.white70 : Colors.black87),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Custom Bar Chart
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    height: 200,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildChartBar(context, 480, 240, 'Jun'),
                        _buildChartBar(context, 340, 110, 'Feb'),
                        _buildChartBar(context, 330, 260, 'Mar'),
                        _buildChartBar(context, 480, 380, 'Apr'),
                        _buildChartBar(context, 150, 220, 'May'),
                        _buildChartBar(context, 400, 250, 'Jun'), // Second Jun as per design
                        _buildChartBar(context, 390, 320, 'Jul'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _buildActionButton(
                          context,
                          title: context.tr('add_new_product'),
                          icon: Iconsax.add,
                          onTap: () => context.push('/merchant/add_product'),
                        ),
                        const SizedBox(height: 12),
                        _buildActionButton(
                          context,
                          title: context.tr('manage_products_nav'),
                          icon: isAr ? Iconsax.arrow_left_2 : Iconsax.arrow_right_3,
                          onTap: () => context.push('/manage_products'),
                        ),
                        const SizedBox(height: 12),
                        _buildActionButton(
                          context,
                          title: context.tr('manage_orders_nav'),
                          icon: isAr ? Iconsax.arrow_left_2 : Iconsax.arrow_right_3,
                          onTap: () => context.push('/merchant_orders'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          
          const Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: MerchantBottomNavBar(currentPath: 'dashboard'),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatCard(BuildContext context, {required String title, required String value, required IconData icon}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2220) : AppColors.primary[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: BulkIcon(icon: icon, color: isDark ? const Color(0xFFC39088) : AppColors.primary[500], size: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 10,
                  color: isDark ? Colors.grey[400] : AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : AppColors.primary[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(BuildContext context, double val1, double val2, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Max height reference is roughly 500 for scaling in UI (height is 120 pixels max)
    double scale = 120 / 500;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 8,
              height: val1 * scale,
              decoration: BoxDecoration(
                color: AppColors.primary[500],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 8,
              height: val2 * scale,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF4A3835) : AppColors.primary[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.cairo(fontSize: 10, color: isDark ? Colors.grey[500] : AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2220) : AppColors.primary[50], // Very light background
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            Icon(icon, color: isDark ? const Color(0xFFC39088) : AppColors.primary[700], size: 20),
          ],
        ),
      ),
    );
  }
}
