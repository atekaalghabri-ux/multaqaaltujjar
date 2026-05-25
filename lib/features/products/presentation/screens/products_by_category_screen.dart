import '../../../wishlist/presentation/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/localization/app_localizations.dart';

// شاشة عرض المنتجات
class ProductsByCategoryScreen extends StatefulWidget {
  final String? categoryName;

  const ProductsByCategoryScreen({super.key, this.categoryName});

  @override
  State<ProductsByCategoryScreen> createState() => _ProductsByCategoryScreenState();
}

class _ProductsByCategoryScreenState extends State<ProductsByCategoryScreen> {
  int _selectedCategoryIndex = 0;

  final List<String> _sidebarCategories = [
    'all_categories',
    'men_clothing',
    'women_clothing',
    'handbags',
    'shoes_cat',
    'children_clothing',
    'accessories',
    'electronics',
    'cosmetics',
    'supermarket',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        elevation: 0,
        title: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2220) : const Color(0xFFF8ECE9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: isAr ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: isAr ? [
              Text(
                widget.categoryName ?? context.tr('all_categories'),
                style: GoogleFonts.cairo(
                  color: isDark ? Colors.white : const Color(0xFF572F29),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Iconsax.arrow_right_1, color: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D), size: 18),
            ] : [
              Icon(Iconsax.arrow_left_1, color: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D), size: 18),
              const SizedBox(width: 8),
              Text(
                widget.categoryName ?? context.tr('all_categories'),
                style: GoogleFonts.cairo(
                  color: isDark ? Colors.white : const Color(0xFF572F29),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          // القائمة الجانبية للأقسام
          Container(
            width: 105,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              border: Border(
                right: isAr ? BorderSide.none : BorderSide(color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100),
                left: isAr ? BorderSide(color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100) : BorderSide.none,
              ),
            ),
            child: ListView.builder(
              itemCount: _sidebarCategories.length,
              itemBuilder: (context, index) {
                bool isSelected = index == _selectedCategoryIndex;
                final catKey = _sidebarCategories[index];
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategoryIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? (isDark ? const Color(0xFFC39088) : const Color(0xFF99574D)) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected ? null : Border.all(color: isDark ? const Color(0xFF2C2220) : const Color(0xFFF8ECE9)),
                    ),
                    child: Text(
                      context.tr(catKey),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? (isDark ? const Color(0xFF201513) : Colors.white) : (isDark ? Colors.white70 : const Color(0xFF572F29)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // شبكة المنتجات
          Expanded(
            flex: 3,
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: 8,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) => const ProductCardInternal(),
            ),
          ),
        ],
      ),
    );
  }
}

// ويدجت بطاقة المنتج (تم دمجها هنا لحل مشكلة المسارات)
class ProductCardInternal extends StatefulWidget {
  const ProductCardInternal({super.key});

  @override
  State<ProductCardInternal> createState() => _ProductCardInternalState();
}

class _ProductCardInternalState extends State<ProductCardInternal> {
  bool isFavorite = false;

  void _toggleFavorite() {
    setState(() => isFavorite = !isFavorite);
    if (isFavorite) {
      globalWishlistItems.add({'name': 'mock_product_test', 'price': '30', 'oldPrice': '45', 'image': 'assets/images/product.png'});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('added_to_favorites'), style: GoogleFonts.cairo()),
          backgroundColor: const Color(0xFF99574D),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      globalWishlistItems.removeWhere((item) => item['name'] == 'mock_product_test');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('removed_from_favorites'), style: GoogleFonts.cairo()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF7F5F4),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(child: Icon(Iconsax.image, color: Colors.grey, size: 30)),
            ),
            PositionedDirectional(
              top: 8, start: 8,
              child: GestureDetector(
                onTap: _toggleFavorite,
                child: Icon(
                  isFavorite ? Iconsax.heart5 : Iconsax.heart, 
                  color: isFavorite ? Colors.red : (isDark ? Colors.white24 : Colors.black12), 
                  size: 22,
                ),
              ),
            ),
            PositionedDirectional(
              bottom: 8, end: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.white, 
                  shape: BoxShape.circle,
                ),
                child: Icon(Iconsax.add_circle5, color: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D), size: 24),
              ),
            )
          ],
        ),
        const SizedBox(height: 5),
        Text(
          context.tr("mock_product_test"),
          textAlign: TextAlign.start,
          style: GoogleFonts.cairo(
            fontSize: 12, 
            fontWeight: FontWeight.bold, 
            color: isDark ? Colors.white : const Color(0xFF572F29),
          ),
        ),
        Text(
          "30 ${context.tr('currency')}",
          textAlign: TextAlign.start,
          style: GoogleFonts.cairo(
            fontSize: 13, 
            fontWeight: FontWeight.w800, 
            color: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(5, (index) => const Icon(Iconsax.star1, color: Colors.amber, size: 12)),
        ),
      ],
    );
  }
}