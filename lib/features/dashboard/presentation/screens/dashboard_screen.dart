import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../widgets/custom_bottom_nav_bar.dart';
import '../../../wishlist/presentation/screens/wishlist_screen.dart';
import '../../../../core/localization/app_localizations.dart';

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

class DashboardScreen extends StatelessWidget {
  final String userName;
  const DashboardScreen({super.key, this.userName = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // المحتوى القابل للتمرير
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 110), // مساحة لعدم تغطية البار السفلي لآخر المنتجات
              child: Column(
                children: [
                  _TopHeader(userName: userName),
                  const SizedBox(height: 15),
                  const _PromoSlider(),
                  const SizedBox(height: 20),
                  const _CategoriesSection(),
                  const SizedBox(height: 20),
                  const _BrandsSection(),
                  const SizedBox(height: 20),
                  const _FeaturedSection(),
                ],
              ),
            ),
          ),
          // البار السفلي الثابت
          const Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: CustomBottomNavBar(currentPath: 'home'),
          ),
        ],
      ),
    );
  }
}

// --- الهيدر العلوي ---
class _TopHeader extends StatefulWidget {
  final String userName;
  const _TopHeader({required this.userName});

  @override
  State<_TopHeader> createState() => _TopHeaderState();
}

class _TopHeaderState extends State<_TopHeader> {
  String? currentAddress;
  LatLng? selectedLocation;
  GoogleMapController? mapController;

  void _showLocationPickerBottomSheet() {
    LatLng tempLocation = selectedLocation ?? const LatLng(24.7136, 46.6753); // Default to Riyadh
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final modalIsDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(context.tr('select_your_location'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: modalIsDark ? Colors.white : const Color(0xFF572F29))),
                  ),
                  Expanded(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(target: tempLocation, zoom: 14),
                      onMapCreated: (controller) => mapController = controller,
                      onTap: (location) {
                        setModalState(() {
                          tempLocation = location;
                        });
                      },
                      markers: {
                        Marker(
                          markerId: const MarkerId('pickedLocation'),
                          position: tempLocation,
                        ),
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF99574D),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () async {
                        context.pop();
                        setState(() {
                          selectedLocation = tempLocation;
                          currentAddress = context.tr('detecting_location');
                        });
                        try {
                          List<Placemark> placemarks = await placemarkFromCoordinates(tempLocation.latitude, tempLocation.longitude);
                          if (placemarks.isNotEmpty) {
                            Placemark place = placemarks.first;
                            setState(() {
                              currentAddress = '${place.street ?? place.name ?? ''}، ${place.locality ?? place.subAdministrativeArea ?? ''}';
                            });
                          }
                        } catch (e) {
                          setState(() {
                            currentAddress = context.tr('location_from_map');
                          });
                        }
                      },
                      child: Text(context.tr('confirm_location'), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayAddress = currentAddress ?? context.tr('mock_address_1');
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
            ? [const Color(0xFF3E2D2A), const Color(0xFF301F1C)]
            : [const Color(0xFFCCB6B3), const Color(0xFFC39088)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName.isNotEmpty ? '${context.tr('welcome_user')} ${widget.userName}' : context.tr('welcome_default'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: _showLocationPickerBottomSheet,
                    child: Row(children: [
                      _buildBulkIcon(Iconsax.location5, size: 14, color: const Color(0xFF99574D)),
                      const SizedBox(width: 4),
                      Text(displayAddress.length > 25 ? '${displayAddress.substring(0, 25)}...' : displayAddress, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    ]),
                  ),
                ],
              ),
              Row(children: [
                GestureDetector(
                  onTap: () => context.push('/notifications'),
                  child: _buildIconBtn(context, Iconsax.notification5, true),
                ),
              ])
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              GestureDetector(
                onTap: () => context.push('/wishlist'),
                child: Container(
                  width: 45, height: 45,
                  decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
                  child: _buildBulkIcon(Iconsax.heart5, color: Colors.red),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    const SizedBox(width: 15),
                    _buildBulkIcon(Iconsax.search_normal_15, color: Colors.grey, size: 18),
                    const SizedBox(width: 10),
                    Text(context.tr('search_hint'), style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildIconBtn(BuildContext context, IconData icon, bool hasDot) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.5), 
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(alignment: Alignment.center, children: [
        _buildBulkIcon(icon, size: 22, color: const Color(0xFF99574D)),
        if (hasDot) Positioned(top: 8, right: 8, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
      ]),
    );
  }
}

// --- سلايدر العروض ---
class _PromoSlider extends StatefulWidget {
  const _PromoSlider();
  @override
  State<_PromoSlider> createState() => _PromoSliderState();
}

class _PromoSliderState extends State<_PromoSlider> {
  late final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  final List<String> _banners = ['assets/images/banner.png', 'assets/images/banner.png', 'assets/images/banner.png'];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (t) {
      if (_pageController.hasClients) {
        _pageController.animateToPage((_pageController.page!.toInt() + 1), duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
      }
    });
  }

  @override
  void dispose() { _timer?.cancel(); _pageController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 160,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [Color(0xFFFA788E), Color(0xFFFCA5B3)])),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (v) => setState(() => _currentPage = v % _banners.length),
              itemBuilder: (context, index) => Stack(
                children: [
                  Positioned(left: 10, child: Image.asset(_banners[index % _banners.length], width: 373, height: 189, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.image, size: 80, color: Colors.white54))),
                  Positioned(
                    right: 20, top: 25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.tr('discount_promo'), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(context.tr('promo_available'), style: const TextStyle(color: Colors.white, fontSize: 11)),
                        Text(context.tr('all_colors'), style: const TextStyle(color: Colors.white, fontSize: 11)),
                        const SizedBox(height: 15),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6), decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(15)), child: Row(children: [Text(context.tr('shop_now_btn'), style: const TextStyle(color: Colors.white, fontSize: 12)), const SizedBox(width: 5), const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 10)]))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(bottom: 10, left: 0, right: 0, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_banners.length, (i) => Container(margin: const EdgeInsets.symmetric(horizontal: 3), width: _currentPage == i ? 8 : 6, height: _currentPage == i ? 8 : 6, decoration: BoxDecoration(color: _currentPage == i ? Colors.white : Colors.white54, shape: BoxShape.circle))))),
          ],
        ),
      ),
    );
  }
}

// --- كارد المنتج التفاعلي ---
class _ProductCard extends StatefulWidget {
  final bool hasQty;
  const _ProductCard({required this.hasQty});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool isFavorite = false;

  void _toggleFavorite() {
    setState(() => isFavorite = !isFavorite);
    if (isFavorite) {
      globalWishlistItems.add({'name': context.tr('mock_product_modern'), 'price': '30', 'oldPrice': '40', 'image': 'assets/images/product.png'});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('added_to_favorites'), style: GoogleFonts.cairo()),
          backgroundColor: const Color(0xFF99574D),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      globalWishlistItems.removeWhere((item) => item['name'] == context.tr('mock_product_modern'));
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
    return GestureDetector(
      onTap: () => context.push('/product_details'),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(clipBehavior: Clip.none, children: [
            Container(
              height: 141, 
              width: double.infinity, 
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF3EAE5), 
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              ), 
              child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), child: Image.asset('assets/images/product.png', fit: BoxFit.cover, errorBuilder: (c, e, s) => const Center(child: Icon(Icons.image)))),
            ),
            Positioned(top: 10, right: 10, child: GestureDetector(onTap: _toggleFavorite, child: _buildBulkIcon(isFavorite ? Iconsax.heart5 : Iconsax.heart, color: isFavorite ? Colors.red : Colors.grey))),
            Positioned(bottom: -15, left: 10, child: Container(decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(15), boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4)]), child: widget.hasQty ? Row(children: [const SizedBox(width: 8), _buildBulkIcon(Iconsax.add5, size: 16), const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('1')), _buildBulkIcon(Iconsax.minus5, size: 16), const SizedBox(width: 8)]) : Padding(padding: const EdgeInsets.all(6), child: _buildBulkIcon(Iconsax.add5, size: 18)))),
          ]),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text(
                  context.tr('mock_product_modern_style'),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  maxLines: 1,
                ),
                Text(
                  '30 ${context.tr('currency')}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

// --- الأقسام والماركات والمختارات ---
class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection();
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    List<Map<String, dynamic>> cats = [
      {'name': context.tr('men_clothing'), 'image': 'assets/images/men_clothing.png'},
      {'name': context.tr('women_clothing'), 'image': 'assets/images/women_clothing.png'},
      {'name': context.tr('handbags'), 'image': 'assets/images/handbags.png'},
      {'name': context.tr('shoes_cat'), 'image': 'assets/images/shoes.png'},
      {'name': context.tr('children_clothing'), 'image': 'assets/images/children_clothing.png'},
      {'name': context.tr('accessories'), 'image': 'assets/images/accessories.png'},
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(context.tr('search_by_category'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), GestureDetector(onTap: () => context.push('/products_by_category', extra: context.tr('all_categories')), child: Text('${context.tr('view_all')} <', style: const TextStyle(color: Colors.grey, fontSize: 12)))]),
        const SizedBox(height: 15),
        SizedBox(
          height: 180, 
          child: GridView.builder(
            scrollDirection: Axis.horizontal, 
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 15, childAspectRatio: 1.1), 
            itemCount: cats.length, 
            itemBuilder: (context, index) => Column(
              children: [
                Container(
                  width: 60, 
                  height: 60, 
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF5EBE7), 
                    shape: BoxShape.circle, 
                    border: Border.all(color: isDark ? Colors.transparent : const Color(0xFFD2C4BE), width: 1.5),
                  ), 
                  child: Center(child: Image.asset(cats[index]['image'], width: 35, height: 35, fit: BoxFit.contain, errorBuilder: (c, e, s) => _buildBulkIcon(Iconsax.category5))),
                ), 
                const SizedBox(height: 5), 
                Text(cats[index]['name'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class _BrandsSection extends StatelessWidget {
  const _BrandsSection();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(context.tr('most_popular_brands'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), Text(context.tr('shop_by_brand'), style: const TextStyle(color: Color(0xFF99574D), fontSize: 12))]),
        const SizedBox(height: 10),
        SizedBox(height: 45, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: 5, itemBuilder: (c, i) => Container(margin: const EdgeInsets.only(left: 10), width: 80, decoration: BoxDecoration(color: Theme.of(context).cardColor, border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.transparent : Colors.grey.shade200), borderRadius: BorderRadius.circular(25)), child: Center(child: Image.asset('assets/images/trademark${i+1}.png', fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.local_offer, size: 18, color: Colors.grey)))))),
      ]),
    );
  }
}

class _FeaturedSection extends StatelessWidget {
  const _FeaturedSection();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(context.tr('featured_for_you'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), Text('${context.tr('view_all')} <', style: const TextStyle(color: Colors.grey, fontSize: 12))]),
        const SizedBox(height: 15),
        const Row(children: [Expanded(child: _ProductCard(hasQty: false)), SizedBox(width: 15), Expanded(child: _ProductCard(hasQty: true))]),
        const SizedBox(height: 15),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Expanded(child: _ProductCard(hasQty: false)),
          const SizedBox(width: 15),
          Expanded(child: Container(height: 250, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2522) : const Color(0xFFF3EBE6), borderRadius: BorderRadius.circular(15)), child: Column(children: [Text(context.tr('special_choices'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), const SizedBox(height: 10), Expanded(child: ListView(children: List.generate(4, (i) => _buildSpecialItem(context))))]))),
        ]),
      ]),
    );
  }

  Widget _buildSpecialItem(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(child: Text(context.tr('mock_product_modern_tshirt'), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold), maxLines: 1)),
        ClipOval(child: Image.asset('assets/images/style_tshirt.png', width: 32, height: 32, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.image, size: 16))),
      ]),
    );
  }
}