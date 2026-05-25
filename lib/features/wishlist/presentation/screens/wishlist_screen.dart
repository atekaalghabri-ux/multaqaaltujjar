import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/localization/app_localizations.dart';

// Global wishlist items
List<Map<String, dynamic>> globalWishlistItems = [];

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2220) : const Color(0xFFF8ECE9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Icon(
                  Localizations.localeOf(context).languageCode == 'ar'
                      ? Iconsax.arrow_right_1
                      : Iconsax.arrow_left_2,
                  color: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D),
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                context.tr("my_wishlist"),
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
      body: globalWishlistItems.isEmpty
          ? Center(
              child: Text(
                context.tr('empty_wishlist'),
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: globalWishlistItems.length,
              itemBuilder: (context, index) {
                final item = globalWishlistItems[index];
                return WishlistItem(
                  item: item, 
                  index: index, 
                  onRemove: () {
                    setState(() {
                      globalWishlistItems.removeAt(index);
                    });
                  },
                  onPinChanged: () {
                    setState(() {
                      globalWishlistItems.sort((a, b) {
                        bool aPinned = a['isPinned'] ?? false;
                        bool bPinned = b['isPinned'] ?? false;
                        if (aPinned && !bPinned) return -1;
                        if (!aPinned && bPinned) return 1;
                        return 0;
                      });
                    });
                  },
                );
              },
            ),
    );
  }
}

class WishlistItem extends StatefulWidget {
  final Map<String, dynamic> item;
  final int index;
  final VoidCallback onRemove;
  final VoidCallback onPinChanged;

  const WishlistItem({
    super.key,
    required this.item,
    required this.index,
    required this.onRemove,
    required this.onPinChanged,
  });

  @override
  State<WishlistItem> createState() => _WishlistItemState();
}

class _WishlistItemState extends State<WishlistItem> {
  void _togglePin() {
    bool currentPinned = widget.item['isPinned'] ?? false;
    if (currentPinned) {
      widget.item['isPinned'] = false;
      widget.onPinChanged();
    } else {
      int pinnedCount = globalWishlistItems.where((i) => i['isPinned'] == true).length;
      if (pinnedCount >= 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('wishlist_limit_msg'), style: GoogleFonts.cairo()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        widget.item['isPinned'] = true;
        widget.onPinChanged();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: isAr ? [
          // أزرار التثبيت والحذف
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _togglePin,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (widget.item['isPinned'] ?? false) ? const Color(0xFF99574D) : (isDark ? const Color(0xFF2C2220) : const Color(0xFFF8ECE9)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.push_pin, 
                    size: 18, 
                    color: (widget.item['isPinned'] ?? false) ? Colors.white : (isDark ? const Color(0xFFC39088) : const Color(0xFF99574D)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: widget.onRemove,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2220) : const Color(0xFFF8ECE9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Iconsax.trash, size: 18, color: Colors.red),
                ),
              ),
            ],
          ),
          
          const Spacer(),

          // تفاصيل المنتج
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(widget.item['name'] ?? "mock_product_name"),
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF572F29),
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    Text(
                      "${widget.item['oldPrice'] ?? '60'} ${context.tr('currency')}",
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      "${widget.item['price'] ?? '50'} ${context.tr('currency')}",
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...List.generate(
                      5,
                      (index) => const Icon(Iconsax.star1, color: Colors.amber, size: 12),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "(6,890)",
                      style: GoogleFonts.cairo(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // صورة المنتج
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF7F5F4),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: widget.item['image'] != null && widget.item['image'].startsWith('assets/')
                      ? Image.asset(
                          widget.item['image'],
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=1000',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ],
          ),
        ] : [
          // صورة المنتج
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF7F5F4),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: widget.item['image'] != null && widget.item['image'].startsWith('assets/')
                      ? Image.asset(
                          widget.item['image'],
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=1000',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          // تفاصيل المنتج
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(widget.item['name'] ?? "mock_product_name"),
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF572F29),
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    Text(
                      "${widget.item['price'] ?? '50'} ${context.tr('currency')}",
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D),
                      ),
                    ),
                    Text(
                      "${widget.item['oldPrice'] ?? '60'} ${context.tr('currency')}",
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...List.generate(
                      5,
                      (index) => const Icon(Iconsax.star1, color: Colors.amber, size: 12),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "(6,890)",
                      style: GoogleFonts.cairo(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // أزرار التثبيت والحذف
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _togglePin,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (widget.item['isPinned'] ?? false) ? const Color(0xFF99574D) : (isDark ? const Color(0xFF2C2220) : const Color(0xFFF8ECE9)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.push_pin, 
                    size: 18, 
                    color: (widget.item['isPinned'] ?? false) ? Colors.white : (isDark ? const Color(0xFFC39088) : const Color(0xFF99574D)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: widget.onRemove,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2220) : const Color(0xFFF8ECE9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Iconsax.trash, size: 18, color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}