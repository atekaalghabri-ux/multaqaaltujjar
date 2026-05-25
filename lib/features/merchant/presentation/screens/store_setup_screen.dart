import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/bulk_icon.dart';
import '../../../../core/localization/app_localizations.dart';

class StoreSetupScreen extends StatefulWidget {
  const StoreSetupScreen({super.key});

  @override
  State<StoreSetupScreen> createState() => _StoreSetupScreenState();
}

class _StoreSetupScreenState extends State<StoreSetupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/merchant_dashboard');
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/merchant_dashboard');
      }
    }
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
                      onTap: _previousStep,
                      child: Icon(
                        isAr ? Iconsax.arrow_right_3 : Iconsax.arrow_left_2,
                        color: isDark ? const Color(0xFFC39088) : AppColors.primary[700],
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.tr('store_info'),
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
            
            // Main Container
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    // Title and Progress
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('setup_store_intro'),
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: List.generate(3, (index) {
                              return Expanded(
                                child: Container(
                                  margin: EdgeInsetsDirectional.only(end: index < 2 ? 8 : 0),
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: _currentStep >= index 
                                        ? AppColors.primary[500] 
                                        : (isDark ? Colors.grey.shade800 : AppColors.neutral[100]),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Pages
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(), // Disable swipe to force using buttons
                        onPageChanged: (index) {
                          setState(() {
                            _currentStep = index;
                          });
                        },
                        children: const [
                          _Step1Info(),
                          _Step2Logo(),
                          _Step3Location(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Action Buttons
            Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go('/merchant_dashboard'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF2C2220) : AppColors.primary[600],
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        context.tr('complete_later'),
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
                      onPressed: _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary[500],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentStep == 2 ? context.tr('finish') : context.tr('next'),
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isAr ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.white38,
                          ),
                        ],
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
}

// --- Step 1: Info ---
class _Step1Info extends StatelessWidget {
  const _Step1Info();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store Name Field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2C) : AppColors.primary[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('store_name'),
                  style: GoogleFonts.cairo(
                    color: isDark ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.tr('select_activity_type'),
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // Categories Grid
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.start,
            children: List.generate(12, (index) {
              bool isSelected = index == 1; // Highlight the second item to match design
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.primary[500] 
                      : (isDark ? const Color(0xFF2C2C2C) : AppColors.primary[50]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.tr('cosmetics'),
                  style: GoogleFonts.cairo(
                    color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppColors.primary[700]),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// --- Step 2: Logo ---
class _Step2Logo extends StatelessWidget {
  const _Step2Logo();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('add_logo_here'),
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // Dashed Image Picker Placeholder
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark ? const Color(0xFFC39088).withOpacity(0.5) : Colors.blueAccent.withOpacity(0.5), 
                width: 1.5, 
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(
                Icons.add, 
                size: 40, 
                color: isDark ? const Color(0xFFC39088) : Colors.blueAccent,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF2C2220) : AppColors.primary[100],
                foregroundColor: isDark ? const Color(0xFFC39088) : AppColors.primary[700],
                elevation: 0,
                side: BorderSide(
                  color: isDark ? const Color(0xFFC39088) : AppColors.primary[700]!, 
                  width: 0.5,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                context.tr('save'),
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Step 3: Location ---
class _Step3Location extends StatelessWidget {
  const _Step3Location();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('select_your_location'),
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          // Map Placeholder
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade900 : AppColors.neutral[200],
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: NetworkImage('https://maps.googleapis.com/maps/api/staticmap?center=24.7136,46.6753&zoom=13&size=600x300&key=YOUR_API_KEY'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.map, size: 60, color: isDark ? Colors.white30 : Colors.black26),
                const Icon(Icons.location_on, size: 40, color: Colors.red),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary[600],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          context.tr('update_location'),
                          style: GoogleFonts.cairo(color: Colors.white, fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.location_on, color: Colors.white, size: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.tr('select_address'),
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          // Address Option
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : AppColors.primary[100]!,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2C) : AppColors.primary[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: BulkIcon(
                    icon: Iconsax.home, 
                    color: isDark ? const Color(0xFFC39088) : AppColors.primary[500],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr('mock_address_5'),
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        context.tr('primary'),
                        style: GoogleFonts.cairo(
                          color: isDark ? const Color(0xFFC39088) : AppColors.primary[500], 
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Add Branch Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF2C2220) : AppColors.primary[100],
                foregroundColor: isDark ? const Color(0xFFC39088) : AppColors.primary[700],
                elevation: 0,
                side: BorderSide(
                  color: isDark ? const Color(0xFFC39088) : AppColors.primary[700]!, 
                  width: 0.5,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                context.tr('add_branch'),
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
