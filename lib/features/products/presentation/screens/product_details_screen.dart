import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/localization/app_localizations.dart';
 

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  String selectedSize = 'M';
  Color selectedColor = const Color(0xFF2D81FB);

  final List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL', '3XL'];
  final List<Color> colors = [
    const Color(0xFF000000),
    const Color(0xFFFFFFFF),
    const Color(0xFF2D81FB),
    const Color(0xFF2EAA7B),
  ];

  // دالة لإظهار رسالة النجاح عند الإضافة للسلة
  void _showAddToCartMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              context.tr('added_to_cart_msg'),
              style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            const Icon(Iconsax.tick_circle5, color: Colors.white),
          ],
        ),
        backgroundColor: const Color(0xFF99574D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // --- القسم العلوي (صورة المنتج مع الهيدر) ---
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark 
                        ? [const Color(0xFF3E2D2A), const Color(0xFF201513)] 
                        : [const Color(0xFFCCB6B3), const Color(0xFFF3EAE5)],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    // شريط التنقل العلوي
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: isAr ? [
                          _buildHeaderIcon(Iconsax.shopping_cart, onTap: () {
                            // انتقل للسلة إذا أردت
                          }),
                          const SizedBox(width: 12),
                          _buildHeaderIcon(Iconsax.share),
                          const SizedBox(width: 12),
                          // تفعيل زر العودة
                          Expanded(
                            child: GestureDetector(
                              onTap: () => context.pop(),
                              child: Container(
                                height: 45,
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        context.tr('mock_product_short'),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold, 
                                          fontSize: 13,
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(Iconsax.arrow_right_3, size: 18, color: isDark ? Colors.white : Colors.black87),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ] : [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => context.pop(),
                              child: Container(
                                height: 45,
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Iconsax.arrow_left_2, size: 18, color: isDark ? Colors.white : Colors.black87),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        context.tr('mock_product_short'),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold, 
                                          fontSize: 13,
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildHeaderIcon(Iconsax.share),
                          const SizedBox(width: 12),
                          _buildHeaderIcon(Iconsax.shopping_cart, onTap: () {
                            // انتقل للسلة إذا أردت
                          }),
                        ],
                      ),
                    ),
                    // الصورة الرئيسية
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Column(
                            children: List.generate(4, (index) => _buildThumbnail()),
                          ),
                          Expanded(
                            child: Image.network(
                              'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=1000',
                              height: 250,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // --- تفاصيل المنتج ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRating(),
                      Expanded(
                        child: Text(
                          context.tr('mock_product_name'),
                          textAlign: TextAlign.start,
                          style: GoogleFonts.cairo(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold, 
                            height: 1.4,
                            color: isDark ? Colors.white : const Color(0xFF201513),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPriceTag(),
                      _buildQuantitySelector(),
                    ],
                  ),
                  const SizedBox(height: 25),
                  _sectionTitle(context.tr('colors')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: colors.map((c) => _buildColorOption(c)).toList(),
                  ),
                  const SizedBox(height: 25),
                  _sectionTitle(context.tr('sizes')),
                  Wrap(
                    spacing: 12, runSpacing: 12,
                    alignment: WrapAlignment.start,
                    children: sizes.map((s) => _buildSizeOption(s)).toList().reversed.toList(),
                  ),
                  const SizedBox(height: 25),
                  _sectionTitle(context.tr('description')),
                  Text(
                    context.tr('mock_product_desc'),
                    textAlign: TextAlign.start,
                    style: GoogleFonts.cairo(
                      fontSize: 14, 
                      color: isDark ? Colors.grey[300] : Colors.grey[700], 
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- شريط الشراء السفلي المطور ---
          _buildBottomAction(context),
        ],
      ),
    );
  }

  // --- الأدوات المساعدة (Helper Widgets) ---

  Widget _buildHeaderIcon(IconData icon, {VoidCallback? onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45, height: 45,
        decoration: BoxDecoration(
          color: isDark ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D), size: 22),
      ),
    );
  }

  Widget _buildPriceTag() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('60 ${context.tr('currency')}', style: GoogleFonts.cairo(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 14)),
        Text('30 ${context.tr('currency')}', style: GoogleFonts.cairo(fontSize: 26, fontWeight: FontWeight.w900, color: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D))),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2220) : const Color(0xFFF8F0ED), 
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(onPressed: () => setState(() => quantity++), icon: Icon(Iconsax.add, size: 18, color: isDark ? Colors.white : Colors.black)),
          Text('$quantity', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
          IconButton(onPressed: () => quantity > 1 ? setState(() => quantity--) : null, icon: Icon(Iconsax.minus, size: 18, color: isDark ? Colors.white : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [BoxShadow(color: isDark ? Colors.black38 : Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          // زر شراء المنتج (ينتقل لشاشة الدفع)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                context.push('/checkout', extra: {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D),
                foregroundColor: isDark ? const Color(0xFF201513) : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(context.tr('buy_product'), style: GoogleFonts.cairo(color: isDark ? const Color(0xFF201513) : Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 15),
          // زر إضافة للسلة (يظهر الرسالة المنبثقة)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showAddToCartMessage(context),
              icon: Icon(Iconsax.bag_2, color: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D)),
              label: Text(context.tr('add_to_cart'), style: GoogleFonts.cairo(color: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D), fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // بقية الـ Widgets الصغيرة (Thumbnail, Rating, Color, Size, Title)
  Widget _buildThumbnail() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10), 
      width: 50, height: 50, 
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white, 
        borderRadius: BorderRadius.circular(10),
      ), 
      child: const Icon(Iconsax.image, color: Colors.grey),
    );
  }

  Widget _buildRating() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: List.generate(5, (index) => const Icon(Iconsax.star1, color: Colors.amber, size: 14))), Text('6,890 ${context.tr('ratings')}', style: GoogleFonts.cairo(fontSize: 10, color: Colors.grey))]);
  
  Widget _buildColorOption(Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color), 
      child: Container(
        margin: const EdgeInsetsDirectional.only(start: 12), 
        padding: const EdgeInsets.all(3), 
        decoration: BoxDecoration(
          shape: BoxShape.circle, 
          border: Border.all(
            color: selectedColor == color 
                ? (isDark ? const Color(0xFFC39088) : const Color(0xFF99574D)) 
                : Colors.transparent, 
            width: 2,
          ),
        ), 
        child: CircleAvatar(backgroundColor: color, radius: 14),
      ),
    );
  }

  Widget _buildSizeOption(String size) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => setState(() => selectedSize = size), 
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), 
        width: 45, height: 45, 
        decoration: BoxDecoration(
          color: selectedSize == size 
              ? (isDark ? const Color(0xFFC39088) : const Color(0xFF99574D)) 
              : (isDark ? const Color(0xFF1E1E1E) : Colors.white), 
          shape: BoxShape.circle, 
          border: Border.all(color: isDark ? const Color(0xFF4A3835) : const Color(0xFFCCB6B3)),
        ), 
        child: Center(
          child: Text(
            size, 
            style: GoogleFonts.cairo(
              color: selectedSize == size 
                  ? (isDark ? const Color(0xFF201513) : Colors.white) 
                  : (isDark ? Colors.white70 : Colors.black), 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10), 
      child: Text(
        title, 
        style: GoogleFonts.cairo(
          fontWeight: FontWeight.bold, 
          fontSize: 16, 
          color: isDark ? Colors.white : const Color(0xFF201513),
        ),
      ),
    );
  }
}