import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/bulk_icon.dart';
import '../../../../core/localization/app_localizations.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  int _productFormsCount = 2; // Default to 2 forms as seen in the screenshot

  void _addAnotherProduct() {
    setState(() {
      _productFormsCount++;
    });
  }

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
                      context.tr('add_new_product'),
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
            
            // Main Forms List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _productFormsCount,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildProductForm(context),
                  );
                },
              ),
            ),
            
            // Bottom Action Buttons
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _addAnotherProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary[500],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        context.tr('add_products'),
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Save action
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF2C2220) : AppColors.primary[600],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        context.tr('save'),
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductForm(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('upload_image'),
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // Dashed Image Picker Placeholder
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark ? const Color(0xFFC39088).withOpacity(0.5) : Colors.blueAccent.withOpacity(0.5), 
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: BulkIcon(
                icon: Iconsax.add, 
                size: 40, 
                color: isDark ? const Color(0xFFC39088) : Colors.blueAccent,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Product Name Field
          _buildTextField(context, context.tr('product_name')),
          const SizedBox(height: 12),
          // Product Price Field
          _buildTextField(context, context.tr('product_price')),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : AppColors.primary[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.cairo(
              color: isDark ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          TextField(
            style: GoogleFonts.cairo(
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '|||||||||||||||||',
              hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
