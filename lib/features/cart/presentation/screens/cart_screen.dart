import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../widgets/custom_bottom_nav_bar.dart';
import '../../../../core/localization/app_localizations.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // بيانات وهمية للسلة
  List<CartItemModel> _cartItems = [
    CartItemModel(
      id: '1',
      name: 'mock_product_short',
      price: 50.0,
      quantity: 1,
      imageUrl: 'assets/images/product1.png',
    ),
    CartItemModel(
      id: '2',
      name: 'mock_product_short',
      price: 50.0,
      quantity: 2,
      imageUrl: 'assets/images/product2.png',
    ),
    CartItemModel(
      id: '3',
      name: 'mock_product_short',
      price: 50.0,
      quantity: 1,
      imageUrl: 'assets/images/product3.png',
    ),
    CartItemModel(
      id: '4',
      name: 'mock_product_short',
      price: 50.0,
      quantity: 3,
      imageUrl: 'assets/images/product4.png',
    ),
    CartItemModel(
      id: '5',
      name: 'mock_product_short',
      price: 50.0,
      quantity: 1,
      imageUrl: 'assets/images/product5.png',
    ),
  ];

  // تحديث كمية المنتج
  void _updateQuantity(String id, int newQuantity) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        if (newQuantity <= 0) {
          _cartItems.removeAt(index);
          _showSnackBar(context.tr('cart_deleted_msg'));
        } else {
          _cartItems[index].quantity = newQuantity;
        }
      }
    });
  }

  // حذف منتج معين
  void _removeItem(String id) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == id);
      _showSnackBar(context.tr('cart_deleted_msg'));
    });
  }

  // تفريغ السلة بالكامل
  void _clearCart() {
    if (_cartItems.isEmpty) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('clear_cart_title'), style: GoogleFonts.cairo()),
        content: Text(context.tr('clear_cart_msg'), style: GoogleFonts.cairo()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(context.tr('cancel'), style: GoogleFonts.cairo(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _cartItems.clear());
              context.pop();
              _showSnackBar(context.tr('cart_cleared_msg'));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(context.tr('confirm'), style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  // عرض رسالة سريعة
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.cairo()),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // حساب المجموع الفرعي
  double get _subtotal {
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // حساب رسوم التوصيل (مجاني إذا كان المجموع > 100)
  double get _shipping {
    if (_cartItems.isEmpty) return 0;
    return _subtotal > 100 ? 0 : 10.0;
  }

  // حساب الإجمالي النهائي
  double get _total => _subtotal + _shipping;

  // عدد المنتجات في السلة
  int get _itemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // الانتقال إلى شاشة الدفع
  void _checkout() {
    if (_cartItems.isEmpty) {
      _showSnackBar(context.tr('cart_empty_error'));
      return;
    }
    context.push('/checkout', extra: {
          'totalAmount': _total,
          'subtotal': _subtotal,
          'shipping': _shipping,
          'cartItems': _cartItems.map((e) => CartItem(
            id: e.id,
            name: e.name,
            price: e.price,
            quantity: e.quantity,
            imageUrl: e.imageUrl,
          )).toList(),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _cartItems.isEmpty ? const EmptyCartView() : _buildCartContent(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_cartItems.isNotEmpty) _buildBottomBar(),
          const Padding(
            padding: EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 10),
            child: CustomBottomNavBar(currentPath: 'cart'),
          ),
        ],
      ),
    );
  }

  // AppBar مخصص
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(context.tr('shopping_cart'), style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Iconsax.arrow_right_3),
        onPressed: () => context.pop(),
      ),
      actions: [
        if (_cartItems.isNotEmpty)
          TextButton(
            onPressed: _clearCart,
            child: Text(
              context.tr('delete_all'),
              style: GoogleFonts.cairo(
                color: const Color(0xFF99574D),
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  // محتوى السلة (قائمة المنتجات)
  Widget _buildCartContent() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 20),
            itemCount: _cartItems.length,
            itemBuilder: (context, index) {
              return CartItemCard(
                item: _cartItems[index],
                onQuantityChanged: _updateQuantity,
                onRemove: _removeItem,
              );
            },
          ),
        ),
      ],
    );
  }

  // BottomBar مع ملخص الأسعار وزر الدفع
  Widget _buildBottomBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // تفاصيل الأسعار
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_itemCount ${context.tr('products_count')}',
                style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey.shade600),
              ),
              Text(
                '${_subtotal.toStringAsFixed(0)} ${context.tr('currency')}',
                style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('delivery_label'),
                style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey.shade600),
              ),
              Text(
                _shipping == 0 ? context.tr('free') : '${_shipping.toStringAsFixed(0)} ${context.tr('currency')}',
                style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w500, color: _shipping == 0 ? Colors.green : Colors.grey.shade600),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('total'),
                style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${_total.toStringAsFixed(0)} ${context.tr('currency')}',
                style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF99574D)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // زر الدفع
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _checkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF99574D),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text(
                context.tr('payment'),
                style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          // زر متابعة التسوق
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              context.tr('continue_shopping'),
              style: GoogleFonts.cairo(fontSize: 14, color: const Color(0xFF99574D)),
            ),
          ),
        ],
      ),
    );
  }
}

// نموذج بيانات المنتج في السلة
class CartItemModel {
  final String id;
  final String name;
  final double price;
  int quantity;
  final String imageUrl;

  CartItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

// بطاقة المنتج في السلة
class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final Function(String, int) onQuantityChanged;
  final Function(String) onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.grey.shade50,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة + اسم + سعر + زر حذف
          Row(
            children: [
              // صورة المنتج
              GestureDetector(
                onTap: () {
                  context.push('/product_details');
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF5EBE7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    item.imageUrl,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Iconsax.image,
                      size: 35,
                      color: const Color(0xFF99574D),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // اسم المنتج والسعر
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.push('/product_details');
                      },
                      child: Text(
                        context.tr(item.name),
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.price.toStringAsFixed(0)} ${context.tr('currency')}',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF99574D),
                      ),
                    ),
                  ],
                ),
              ),
              // زر حذف المنتج
              IconButton(
                onPressed: () => onRemove(item.id),
                icon: Icon(Iconsax.trash, size: 20, color: Colors.grey.shade400),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // أزرار التحكم في الكمية
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    // زر الزائد +
                    InkWell(
                      onTap: () => onQuantityChanged(item.id, item.quantity + 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: const Icon(Iconsax.add, size: 18, color: Color(0xFF99574D)),
                      ),
                    ),
                    // الكمية
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        item.quantity.toString(),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // زر الناقص -
                    InkWell(
                      onTap: () => onQuantityChanged(item.id, item.quantity - 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: const Icon(Iconsax.minus, size: 18, color: Color(0xFF99574D)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // السعر الإجمالي للمنتج (إذا كان الكمية > 1)
          if (item.quantity > 1) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '- ${(item.price * item.quantity).toStringAsFixed(0)} ${context.tr('currency')}',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// شاشة السلة الفارغة
class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF99574D).withOpacity(isDark ? 0.2 : 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Iconsax.shopping_cart, size: 60, color: const Color(0xFF99574D)),
          ),
          const SizedBox(height: 24),
          Text(
            context.tr('empty_cart'),
            style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr('empty_cart_msg'),
            style: GoogleFonts.cairo(fontSize: 14, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF99574D),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(context.tr('go_shopping'), style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }
}