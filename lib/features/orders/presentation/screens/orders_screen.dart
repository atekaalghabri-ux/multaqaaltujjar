import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

// استيراد الشاشات الأساسية لربط البار السفلي
import '../../../../widgets/custom_bottom_nav_bar.dart';
import '../../../../core/localization/app_localizations.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              // الهيدر المخصص
              const _OrdersHeader(),
              
              // قائمة الطلبات
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 15, left: 16, right: 16, bottom: 100),
                  itemCount: 5, // عدد الطلبات للعرض
                  itemBuilder: (context, index) {
                    return const _OrderCard();
                  },
                ),
              ),
            ],
          ),
          
          // البار السفلي
          const Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: CustomBottomNavBar(currentPath: 'orders'),
          ),
        ],
      ),
    );
  }
}

// --- الهيدر الخاص بطلباتي ---
class _OrdersHeader extends StatelessWidget {
  const _OrdersHeader();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
              ? [const Color(0xFF3E2D2A), const Color(0xFF301F1C)] 
              : [const Color(0xFFCCB6B3), const Color(0xFFC39088)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: isDark ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => context.go('/dashboard'),
              child: Icon(
                Localizations.localeOf(context).languageCode == 'ar' 
                    ? Iconsax.arrow_right_1 
                    : Iconsax.arrow_left_2, 
                color: isDark ? Colors.white : const Color(0xFF572F29),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              context.tr("my_orders"),
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF572F29),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- بطاقة الطلب ---
class _OrderCard extends StatelessWidget {
  const _OrderCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // القسم العلوي: رقم الطلب وحالة الطلب
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF32D74B), // لون أخضر للحالة
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.tr("completed"),
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${context.tr("order_number")}1024",
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    context.tr("mock_order_date"),
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // قسم صور المنتجات المتداخلة
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 40,
                width: 180, // مساحة تكفي للصور المتداخلة
                child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: [
                    // الدائرة الإضافية للعدد +7
                    PositionedDirectional(
                      end: 140, // كل صورة تبعد 35 بكسل عن التي قبلها لتكوين التداخل
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          border: Border.all(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            "+7",
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // منتج 4
                    PositionedDirectional(
                      end: 105,
                      child: _buildOverlappedImage(context),
                    ),
                    // منتج 3
                    PositionedDirectional(
                      end: 70,
                      child: _buildOverlappedImage(context),
                    ),
                    // منتج 2
                    PositionedDirectional(
                      end: 35,
                      child: _buildOverlappedImage(context),
                    ),
                    // منتج 1
                    PositionedDirectional(
                      end: 0,
                      child: _buildOverlappedImage(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 15),
          
          // القسم السفلي: السعر وزر عرض التفاصيل
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Localizations.localeOf(context).languageCode == 'ar' 
                        ? Iconsax.arrow_left_2 
                        : Iconsax.arrow_right_3, 
                    size: 14, 
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    context.tr("view_details"),
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "92.000",
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF99574D),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    context.tr("currency"),
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF99574D),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ويدجت مساعدة للصور المتداخلة
  Widget _buildOverlappedImage(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFEBEBEB),
        shape: BoxShape.circle,
        border: Border.all(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, width: 2),
      ),
      child: ClipOval(
        // يمكن تغيير مسار الصورة ليطابق منتج حقيقي لاحقاً
        child: Image.network(
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=100',
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => const Icon(Iconsax.image, size: 16, color: Colors.grey),
        ),
      ),
    );
  }
}

// --- محرك التدرج للأيقونات (Bulk Effect) ---
Widget _buildBulkIcon(IconData icon, {double size = 24, Color? color}) {
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

