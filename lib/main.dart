import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tooka App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        textTheme: GoogleFonts.cairoTextTheme(), // Using Google Fonts Cairo
      ),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                const _TopHeader(),
                const SizedBox(height: 15),
                const _PromoSlider(),
                const SizedBox(height: 20),
                const _CategoriesSection(),
                const SizedBox(height: 20),
                const _BrandsSection(),
                const SizedBox(height: 20),
                const _FeaturedSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: _BottomNavBar(),
          ),
        ],
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFE6C8B8),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'أهلاً وسهلاً أمةالله محمد',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: Color(0xFF9E695F), size: 14),
                      SizedBox(width: 4),
                      Text(
                        'شارع الرباط، جوار مكتبة القلم الذهبي',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  _buildIconBtn(Icons.person, false),
                  const SizedBox(width: 10),
                  _buildIconBtn(Icons.notifications, true),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
               Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.favorite, color: Colors.red),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      SizedBox(width: 15),
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 10),
                      Text('ابحث هنا...', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconBtn(IconData icon, bool hasDot) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, size: 22, color: const Color(0xFF9E695F)),
          if (hasDot)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
  }
}

class _PromoSlider extends StatefulWidget {
  const _PromoSlider();

  @override
  State<_PromoSlider> createState() => _PromoSliderState();
}

class _PromoSliderState extends State<_PromoSlider> {
  final PageController _pageController = PageController(initialPage: 3000);
  int _currentPage = 0;
  Timer? _timer;

  final List<String> _banners = [
    'assets/images/banner.png',
    'assets/images/banner.png',
    'assets/images/banner.png',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFFA788E), Color(0xFFFCA5B3)],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page % _banners.length;
                });
              },
              itemBuilder: (context, index) {
                final realIndex = index % _banners.length;
                return Stack(
                  children: [
                    Positioned(
                      left: 10,
                      child: Image.asset(
                        _banners[realIndex],
                        width: 373,
                        height: 189,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image, size: 80, color: Colors.white54),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('خصم من 40 إلى 50%', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          const Text('متوفر الآن في (المنتج)', style: TextStyle(color: Colors.white, fontSize: 11)),
                          const Text('جميع الألوان', style: TextStyle(color: Colors.white, fontSize: 11)),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Row(
                              children: [
                                Text('تسوق الان', style: TextStyle(color: Colors.white, fontSize: 12)),
                                SizedBox(width: 5),
                                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_banners.length, (index) => _dot(index == _currentPage)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _dot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: active ? 8 : 6,
      height: active ? 8 : 6,
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.white54,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection();

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> cats = [
      {'name': 'ملابس رجالية', 'image': 'assets/images/Men\'s clothing.png'},
      {'name': 'ملابس نسائية', 'image': 'assets/images/Women\'s clothing.png'},
      {'name': 'حقائب يد', 'image': 'assets/images/Handbags.png'},
      {'name': 'أحذية', 'image': 'assets/images/shose.png'},
      {'name': 'ملابس أطفال', 'image': 'assets/images/Children\'s clothing.png'},
      {'name': 'اكسسوارات', 'image': 'assets/images/Accessories.png'},
      {'name': 'أجهزة إلكترونية', 'image': 'assets/images/Electronic devices.png'},
      {'name': 'أدوات مكتبية', 'image': 'assets/images/Office tools.png'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('ابحث حسب القسم', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text('عرض الكل <', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 180,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.1,
              ),
              itemCount: cats.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5EBE7),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFD2C4BE), width: 1.5),
                      ),
                      child: Center(
                        child: Image.asset(
                          cats[index]['image'],
                          width: 35,
                          height: 35,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.category, size: 24, color: Color(0xFF9E695F)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(cats[index]['name'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandsSection extends StatelessWidget {
  const _BrandsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('أشهر العلامات التجارية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text('تسوق حسب الماركة', style: TextStyle(color: Color(0xFF9E695F), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 80,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Image.asset(
                        'assets/images/trademark${index+1}.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.local_offer, size: 20, color: Colors.grey),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _FeaturedSection extends StatelessWidget {
  const _FeaturedSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('مختارات مميزة لك 🔥', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text('عرض الكل <', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildProductCard(hasQty: false)),
              const SizedBox(width: 15),
              Expanded(child: _buildProductCard(hasQty: true)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildProductCard(hasQty: false)),
              const SizedBox(width: 15),
              Expanded(
                child: Container(
                  height: 250,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EBE6),
                  borderRadius: BorderRadius.circular(15),
                ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(child: Text('مختارات خاصة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: List.generate(4, (index) => _buildSpecialItem()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
             crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildProductCard(hasQty: false)),
              const SizedBox(width: 15),
              Expanded(child: _buildProductCard(hasQty: false)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: Text('تيشيرت ستايل عصري', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
          const SizedBox(width: 5),
          ClipOval(
            child: Image.asset(
              'assets/images/Style_techirt.png',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.grey.shade300, width: 32, height: 32, child: const Icon(Icons.image, size: 16, color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProductCard({required bool hasQty}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 141,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3EAE5),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  child: Image.asset(
                    'assets/images/prodact.png',
                     fit: BoxFit.cover,
                     width: double.infinity,
                     height: 141,
                     errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.image, size: 60, color: Colors.grey)),
                  ),
                ),
              ),
              const Positioned(
                top: 10, right: 10,
                child: Icon(Icons.favorite_border, color: Colors.grey),
              ),
              Positioned(
                bottom: -15, left: 10,
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: hasQty ? Row(
                    children: const [
                      SizedBox(width: 8),
                      Icon(Icons.add, size: 16),
                      SizedBox(width: 8),
                      Text('1', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Icon(Icons.remove, size: 16),
                      SizedBox(width: 8),
                    ],
                  ) : Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: const Icon(Icons.add, size: 18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('اسم المنتج المكون من خمس كلمات أو أكثر', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold), maxLines: 2),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text('30 ﷼', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text('60 ﷼', style: TextStyle(fontSize: 11, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text('6,890', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    const SizedBox(width: 5),
                    Row(children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 10))),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EBE6),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF9E695F),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.home, color: Colors.white, size: 20),
                SizedBox(width: 5),
                Text('الرئيسية', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.shopping_cart_outlined, color: Color(0xFF9E695F)),
          const Icon(Icons.inventory_2_outlined, color: Color(0xFF9E695F)),
          const Icon(Icons.settings_outlined, color: Color(0xFF9E695F)),
        ],
      ),
    );
  }
}