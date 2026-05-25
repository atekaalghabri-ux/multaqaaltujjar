import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/localization/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // للتحكم باختيار نوع الحساب (مستخدم أو تاجر)
  bool isMerchant = false; 
  // لإظهار وإخفاء كلمة المرور
  bool isPasswordVisible = false;
  bool isRepeatPasswordVisible = false;

  // متحكمات النصوص للتحقق من المدخلات
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/backgruond_logo.png'),
            fit: BoxFit.cover,
            colorFilter: isDark ? ColorFilter.mode(Colors.black.withOpacity(0.85), BlendMode.darken) : null,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                // --- الشعار (القسم العلوي) ---
                Image.asset(
                  'assets/images/slogan.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Iconsax.bag,
                    size: 60,
                    color: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context.tr('app_title'),
                  style: GoogleFonts.cairo(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D),
                  ),
                ),
                Text(
                  'MULTAQA AL-TUJJAR',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                    color: isDark ? Colors.grey[400] : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 20),
                
                // --- الكارت السفلي الأبيض/الداكن ---
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? Theme.of(context).cardColor.withOpacity(0.95) : Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black38 : Colors.grey.shade200,
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        context.tr('welcome_title'),
                        style: GoogleFonts.cairo(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.tr('welcome_subtitle'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: isDark ? Colors.grey[400] : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // --- تبويبات (مستخدم / تاجر) ---
                      Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2C2522) : const Color(0xFFF5EBE7),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            // زر مستخدم
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isMerchant = false),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: !isMerchant 
                                        ? (isDark ? const Color(0xFFC39088) : const Color(0xFF99574D)) 
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    context.tr('buyer'),
                                    style: TextStyle(
                                      color: !isMerchant ? Colors.white : (isDark ? Colors.grey[400] : Colors.grey.shade600),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // زر تاجر
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isMerchant = true),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isMerchant 
                                        ? (isDark ? const Color(0xFFC39088) : const Color(0xFF99574D)) 
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    context.tr('merchant'),
                                    style: TextStyle(
                                      color: isMerchant ? Colors.white : (isDark ? Colors.grey[400] : Colors.grey.shade600),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // --- اسم المستخدم ---
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF8F4F2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: TextField(
                          controller: _usernameController,
                          style: GoogleFonts.cairo(
                            color: isDark ? Colors.white : Colors.black87,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: context.tr('username'),
                            hintStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.black38, fontSize: 13),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // --- رقم الهاتف ---
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF8F4F2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: GoogleFonts.cairo(
                            color: isDark ? Colors.white : Colors.black87,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: context.tr('phone_number'),
                            hintStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.black38, fontSize: 13),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            prefixIcon: Container(
                              width: 80,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('+967', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white70 : Colors.black87)),
                                  const SizedBox(width: 8),
                                  Container(width: 1, height: 25, color: isDark ? Colors.grey.shade800 : Colors.black12),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- كلمة المرور ---
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF8F4F2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: !isPasswordVisible,
                          style: GoogleFonts.cairo(
                            color: isDark ? Colors.white : Colors.black87,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: context.tr('password'),
                            hintStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.black38, fontSize: 13),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: isDark ? Colors.grey[400] : Colors.black54,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- تكرار كلمة المرور ---
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF8F4F2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: TextField(
                          controller: _repeatPasswordController,
                          obscureText: !isRepeatPasswordVisible,
                          style: GoogleFonts.cairo(
                            color: isDark ? Colors.white : Colors.black87,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: context.tr('confirm_password'),
                            hintStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.black38, fontSize: 13),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isRepeatPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: isDark ? Colors.grey[400] : Colors.black54,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  isRepeatPasswordVisible = !isRepeatPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // --- زر إنشاء الحساب ---
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                              if (isMerchant) {
                                context.go('/merchant_dashboard');
                              } else {
                                context.go('/dashboard', extra: _usernameController.text);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.tr('complete_fields_msg')),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            context.tr('register_btn'),
                            style: GoogleFonts.cairo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // --- نصوص تسجيل/إنشاء الحساب ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${context.tr('already_have_account')} ',
                            style: GoogleFonts.cairo(
                              color: isDark ? Colors.grey[400] : Colors.black87,
                              fontSize: 13,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.pop(); // العودة لشاشة تسجيل الدخول
                            },
                            child: Text(
                              context.tr('login_title'),
                              style: GoogleFonts.cairo(
                                color: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D),
                                decoration: TextDecoration.underline,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // --- (أو عبر) ---
                      Row(
                        children: [
                          Expanded(child: Divider(color: isDark ? Colors.grey.shade800 : Colors.black26)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              context.tr('or_via'),
                              style: GoogleFonts.cairo(
                                color: isDark ? Colors.grey[500] : Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: isDark ? Colors.grey.shade800 : Colors.black26)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // --- أزرار الشبكات الاجتماعية ---
                      Row(
                        children: [
                          // جوجل
                          Expanded(
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF2C2522) : const Color(0xFFF5EBE7),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/google_logo.png', 
                                width: 24,
                                height: 24,
                                errorBuilder: (context, error, stackTrace) => Text(
                                  'G', 
                                  style: GoogleFonts.cairo(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // فيسبوك
                          Expanded(
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF2C2522) : const Color(0xFFF5EBE7),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/facebook_logo.png', 
                                width: 24,
                                height: 24,
                                errorBuilder: (context, error, stackTrace) => Icon(
                                  Icons.facebook,
                                  color: Colors.blue.shade700,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
