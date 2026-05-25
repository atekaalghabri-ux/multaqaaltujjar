import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/localization/app_localizations.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalAmount;
  final double subtotal;
  final double shipping;
  final List<CartItem> cartItems;
  
  const CheckoutScreen({
    super.key,
    this.totalAmount = 70.0,
    this.subtotal = 60.0,
    this.shipping = 10.0,
    this.cartItems = const [],
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPayment = 0;
  String _selectedAddress = 'mock_address_2';
  String _selectedShipping = 'fast_delivery';
  
  final List<String> _addresses = [
    'mock_address_2',
    'mock_address_3',
    'mock_address_4',
  ];
  
  final List<String> _shippingMethods = [
    'fast_delivery',
    'normal_delivery',
    'store_pickup',
  ];
  
  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(name: 'al_kuraimi', textColor: const Color(0xFF5D407A), iconBgColor: const Color(0xFF5D407A), icon: Iconsax.bank),
    PaymentMethod(name: 'yemen_kuwait', textColor: const Color(0xFF00589B), iconBgColor: const Color(0xFF00589B), icon: Iconsax.card),
    PaymentMethod(name: 'al_kuraimi', textColor: const Color(0xFF5D407A), iconBgColor: const Color(0xFF5D407A), icon: Iconsax.bank),
    PaymentMethod(name: 'my_wallet_pay', textColor: const Color(0xFF7F95A4), iconBgColor: const Color(0xFF7F95A4), icon: Iconsax.wallet_2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildOrderSummary(),
                  const SizedBox(height: 20),
                  _buildPriceSummary(),
                  const SizedBox(height: 20),
                  _buildPaymentMethods(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark 
              ? [const Color(0xFF3E2D2A), Theme.of(context).scaffoldBackgroundColor] 
              : [const Color(0xFFCCB6B3), const Color(0xFFFAFAFA)],
        ),
      ),
      child: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: isDark ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(context.tr('payment'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(width: 10),
              Icon(Iconsax.arrow_right_3, size: 16, color: isDark ? Colors.white70 : Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr('order_summary'), style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF7F5F4),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              _buildProductsSection(),
              const SizedBox(height: 10),
              _buildAddressSection(),
              const SizedBox(height: 10),
              _buildShippingSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr('requested_products'), style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          SizedBox(
            height: 35,
            child: Stack(
              children: [
                ...List.generate(7, (index) {
                  return Positioned(
                    right: index * 25.0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        color: Colors.grey.shade200,
                      ),
                    ),
                  );
                }),
                Positioned(
                  right: 7 * 25.0,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('+3', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return GestureDetector(
      onTap: () => _showAddressPicker(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Iconsax.arrow_left_2, size: 14, color: Colors.black54),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.tr('address_label'), style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(context.tr(_selectedAddress), style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingSection() {
    return GestureDetector(
      onTap: () => _showShippingPicker(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Iconsax.arrow_left_2, size: 14, color: Colors.black54),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.tr('delivery_label'), style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(context.tr(_selectedShipping), style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.subtotal.toStringAsFixed(0)} ${context.tr('currency')}', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14)),
              Text(context.tr('subtotal_products'), style: GoogleFonts.cairo(color: Colors.grey, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.shipping.toStringAsFixed(0)} ${context.tr('currency')}', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14)),
              Text(context.tr('delivery_label'), style: GoogleFonts.cairo(color: Colors.grey, fontSize: 14)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Color(0xFFEEEEEE), height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.totalAmount.toStringAsFixed(0)} ${context.tr('currency')}', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 18)),
              Text(context.tr('total'), style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr('payment_method'), style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF7F5F4),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildPaymentCard(index: 0, method: _paymentMethods[0])),
                  const SizedBox(width: 10),
                  Expanded(child: _buildPaymentCard(index: 1, method: _paymentMethods[1])),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildPaymentCard(index: 2, method: _paymentMethods[2])),
                  const SizedBox(width: 10),
                  Expanded(child: _buildPaymentCard(index: 3, method: _paymentMethods[3])),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentCard({required int index, required PaymentMethod method}) {
    bool isSelected = _selectedPayment == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = index),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? method.iconBgColor : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                context.tr(method.name),
                style: GoogleFonts.cairo(
                  color: method.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: method.name.contains('\n') || context.tr(method.name).contains('\n') ? 11 : 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: method.iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(method.icon, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom > 0 ? MediaQuery.of(context).padding.bottom : 20,
        top: 10,
      ),
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: _confirmOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B5A50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Text(context.tr('confirm'), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void _showAddressPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.tr('select_delivery_address'), style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ..._addresses.map((address) => RadioListTile<String>(
                title: Text(context.tr(address), style: GoogleFonts.cairo(fontSize: 14)),
                value: address,
                groupValue: _selectedAddress,
                activeColor: const Color(0xFF8B5A50),
                onChanged: (value) {
                  setState(() => _selectedAddress = value!);
                  context.pop();
                },
              )),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  context.pop();
                  _showAddAddressDialog();
                },
                icon: const Icon(Icons.add, color: const Color(0xFF8B5A50)),
                label: Text(context.tr('add_new_address'), style: GoogleFonts.cairo(color: const Color(0xFF8B5A50))),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showShippingPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.tr('select_delivery_method'), style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ..._shippingMethods.map((method) => RadioListTile<String>(
                title: Text(context.tr(method), style: GoogleFonts.cairo(fontSize: 14)),
                value: method,
                groupValue: _selectedShipping,
                activeColor: const Color(0xFF8B5A50),
                onChanged: (value) {
                  setState(() => _selectedShipping = value!);
                  context.pop();
                },
              )),
            ],
          ),
        );
      },
    );
  }

  void _showAddAddressDialog() {
    final TextEditingController addressController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.tr('add_new_address'), style: GoogleFonts.cairo()),
          content: TextField(
            controller: addressController,
            decoration: InputDecoration(
              hintText: context.tr('enter_full_address'),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(context.tr('cancel'), style: GoogleFonts.cairo(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (addressController.text.isNotEmpty) {
                  setState(() => _selectedAddress = addressController.text);
                  context.pop();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5A50)),
              child: Text(context.tr('add'), style: GoogleFonts.cairo()),
            ),
          ],
        );
      },
    );
  }

  void _confirmOrder() {
    if (_selectedAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('select_address_msg'), style: GoogleFonts.cairo())),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Iconsax.tick_circle, color: Colors.green, size: 60),
              const SizedBox(height: 16),
              Text(context.tr('order_confirmed_title'), style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(context.tr('order_confirmed_msg'), style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.pop();
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5A50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(context.tr('back_to_cart'), style: GoogleFonts.cairo()),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PaymentMethod {
  final String name;
  final Color textColor;
  final Color iconBgColor;
  final IconData icon;

  const PaymentMethod({
    required this.name,
    required this.textColor,
    required this.iconBgColor,
    required this.icon,
  });
}