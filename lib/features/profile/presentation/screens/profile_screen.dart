import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../widgets/custom_bottom_nav_bar.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/security/security_service.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // حالات أزرار التبديل
  bool isAppLockEnabled = false;
  bool isFingerprintEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSecuritySettings();
  }

  Future<void> _loadSecuritySettings() async {
    final appLock = await SecurityService.isAppLockEnabled();
    final fingerprint = await SecurityService.isFingerprintEnabled();
    if (mounted) {
      setState(() {
        isAppLockEnabled = appLock;
        isFingerprintEnabled = fingerprint;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedLanguage = ref.watch(localeProvider).languageCode;
    final themeMode = ref.watch(themeModeProvider);
    final isLightTheme = themeMode == ThemeMode.light;
    final isDark = !isLightTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              // --- الرأس (Header) مع الصورة الشخصية ---
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark 
                          ? [const Color(0xFF3E2D2A), const Color(0xFF301F1C)]
                          : [const Color(0xFFCCB6B3), const Color(0xFFC39088)],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: Icon(
                                selectedLanguage == 'ar' ? Iconsax.arrow_right_1 : Iconsax.arrow_left_2,
                                color: isDark ? Colors.white : const Color(0xFF572F29),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              context.tr("settings"),
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF572F29),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // الصورة الشخصية
                  Positioned(
                    bottom: -50,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: const Color(0xFF99574D),
                            child: Text(
                              "A",
                              style: GoogleFonts.cairo(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF4A3430) : const Color(0xFFF8ECE9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Iconsax.add, size: 20, color: Color(0xFF99574D)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),

              // --- بيانات المستخدم ---
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserField(context.tr("username"), "عاتكة أحمد"),
                      _buildUserField(context.tr("phone_number"), "0096777777777"),
                      _buildUserField(context.tr("address"), "اليمن - صنعاء"),

                      const SizedBox(height: 20),
                      Text(context.tr("settings"), style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 10),

                      // أزرار التحكم
                      _buildSettingSwitch(
                        context.tr("light_theme"), 
                        Iconsax.shield_tick, 
                        isLightTheme, 
                        (val) {
                          ref.read(themeModeProvider.notifier).setThemeMode(val ? ThemeMode.light : ThemeMode.dark);
                        },
                      ),
                      _buildSettingSwitch(
                        context.tr("app_lock"), 
                        Iconsax.shield_tick, 
                        isAppLockEnabled, 
                        (val) async {
                          if (val) {
                            final success = await context.push<bool>('/lock', extra: {'isSettingPin': true});
                            if (!mounted) return;
                            if (success == true) {
                              setState(() {
                                isAppLockEnabled = true;
                              });
                            }
                          } else {
                            await SecurityService.setAppLockEnabled(false);
                            await SecurityService.setFingerprintEnabled(false);
                            setState(() {
                              isAppLockEnabled = false;
                              isFingerprintEnabled = false;
                            });
                          }
                        },
                      ),
                      _buildSettingSwitch(
                        context.tr("fingerprint"), 
                        Iconsax.finger_scan, 
                        isFingerprintEnabled, 
                        (val) async {
                          if (val) {
                            final messenger = ScaffoldMessenger.of(context);
                            final lockRequiredMsg = context.tr('enable_app_lock_first');
                            final notSupportedMsg = context.tr('biometrics_not_supported');
                            final authReasonMsg = context.tr('auth_reason');

                            if (!isAppLockEnabled) {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    lockRequiredMsg,
                                    style: GoogleFonts.cairo(),
                                  ),
                                ),
                              );
                              return;
                            }
                            final canBiometric = await SecurityService.canAuthenticate();
                            if (canBiometric) {
                              final authenticated = await SecurityService.authenticateWithBiometrics(authReasonMsg);
                              if (authenticated) {
                                await SecurityService.setFingerprintEnabled(true);
                                if (!mounted) return;
                                setState(() {
                                  isFingerprintEnabled = true;
                                });
                              }
                            } else {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    notSupportedMsg,
                                    style: GoogleFonts.cairo(),
                                  ),
                                ),
                              );
                            }
                          } else {
                            await SecurityService.setFingerprintEnabled(false);
                            setState(() {
                              isFingerprintEnabled = false;
                            });
                          }
                        },
                      ),

                      // اختيار اللغة
                      _buildLanguageSelector(selectedLanguage),

                      const SizedBox(height: 15),
                      _buildSimpleButton(context.tr("privacy_policy"), Iconsax.document_text),
                      const SizedBox(height: 15),
                      
                      // التبديل لواجهة التاجر
                      GestureDetector(
                        onTap: () {
                          // Switch to merchant dashboard temporarily for testing
                          context.go('/merchant_dashboard');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: isDark 
                              ? const Color(0xFF2E2421) 
                              : const Color(0xFFF1E4E0).withOpacity(0.5), 
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Iconsax.shop, size: 20, color: isDark ? const Color(0xFFCCB6B3) : const Color(0xFF572F29)),
                              const SizedBox(width: 10),
                              Text(
                                context.tr("switch_to_merchant"), 
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold, 
                                  color: isDark ? const Color(0xFFCCB6B3) : const Color(0xFF572F29),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      
                      // تسجيل الخروج
                      GestureDetector(
                        onTap: () => _showLogoutConfirmationDialog(context),
                        child: _buildLogoutButton(),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: CustomBottomNavBar(currentPath: 'profile'),
          ),
        ],
      ),
    );
  }

  // ويدجت حقول البيانات
  Widget _buildUserField(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF1E4E0).withOpacity(0.5), 
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.cairo(fontSize: 12, color: const Color(0xFF99574D))),
          Text(value, style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ويدجت أزرار الـ Switch
  Widget _buildSettingSwitch(String title, IconData icon, bool value, Function(bool) onChanged) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white, 
        borderRadius: BorderRadius.circular(15), 
        border: Border.all(color: isDark ? Colors.transparent : Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Text(title, style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600)),
          const Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF99574D),
          ),
        ],
      ),
    );
  }

  // ويدجت اختيار اللغة
  Widget _buildLanguageSelector(String selectedLanguage) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white, 
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(Iconsax.language_square, size: 20),
          const SizedBox(width: 10),
          Text(context.tr("language"), style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600)),
          const Spacer(),
          Row(
            children: [
              _langBtn("العربية", selectedLanguage == 'ar', () {
                ref.read(localeProvider.notifier).setLocale(const Locale('ar', 'AE'));
              }),
              const SizedBox(width: 5),
              _langBtn("English", selectedLanguage == 'en', () {
                ref.read(localeProvider.notifier).setLocale(const Locale('en', 'US'));
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _langBtn(String label, bool isSelected, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF99574D) 
              : (isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF4F4F4)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label, 
          style: GoogleFonts.cairo(
            color: isSelected 
                ? Colors.white 
                : (isDark ? Colors.grey.shade400 : Colors.black), 
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleButton(String title, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2E2421) : const Color(0xFFF1E4E0).withOpacity(0.5), 
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Text(title, style: GoogleFonts.cairo(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2E2421) : const Color(0xFFF1E4E0).withOpacity(0.5), 
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.tr("logout"), style: GoogleFonts.cairo(color: Colors.red, fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          const Icon(Iconsax.logout, color: Colors.red, size: 20),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Iconsax.logout, color: Colors.red, size: 30),
                ),
                const SizedBox(height: 15),
                Text(
                  context.tr("logout"),
                  style: GoogleFonts.cairo(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: isDark ? Colors.white : const Color(0xFF572F29),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  context.tr("logout_confirm_msg"),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          side: const BorderSide(color: Color(0xFF99574D)),
                        ),
                        child: Text(context.tr("cancel"), style: GoogleFonts.cairo(color: const Color(0xFF99574D), fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // تسجيل الخروج والتوجه لشاشة تسجيل الدخول وإغلاق جميع الشاشات السابقة
                          context.go('/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(context.tr("confirm"), style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}