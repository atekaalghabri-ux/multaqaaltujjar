import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/localization/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isMerchant = false;
  
  String? _usernameError;
  String? _passwordError;

  bool _validateFields() {
    setState(() {
      _usernameError = _usernameController.text.trim().isEmpty ? context.tr('field_required') : null;
      _passwordError = _passwordController.text.trim().isEmpty ? context.tr('field_required') : null;
    });
    return _usernameError == null && _passwordError == null;
  }

  void _handleLogin() {
    if (_validateFields()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _isLoading = false);
          if (_isMerchant) {
            context.go('/merchant_dashboard');
          } else {
            context.go('/dashboard', extra: _usernameController.text);
          }
        }
      });
    }
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
                // الشعار
                Container(
                  padding: const EdgeInsets.only(top: 40, bottom: 20),
                  child: Column(
                    children: [
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
                    ],
                  ),
                ),
                // الكارت الأبيض
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
                      // تبويبات تاجر / مستخدم
                      Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2C2522) : const Color(0xFFF5EBE7),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _isMerchant = false),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: !_isMerchant 
                                        ? (isDark ? const Color(0xFFC39088) : const Color(0xFF99574D)) 
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    context.tr('buyer'),
                                    style: TextStyle(
                                      color: !_isMerchant ? Colors.white : (isDark ? Colors.grey[400] : Colors.grey.shade600),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _isMerchant = true),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _isMerchant 
                                        ? (isDark ? const Color(0xFFC39088) : const Color(0xFF99574D)) 
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    context.tr('merchant'),
                                    style: TextStyle(
                                      color: _isMerchant ? Colors.white : (isDark ? Colors.grey[400] : Colors.grey.shade600),
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
                      // حقل اسم المستخدم
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF8F4F2),
                              borderRadius: BorderRadius.circular(12),
                              border: _usernameError != null ? Border.all(color: Colors.red, width: 1) : null,
                            ),
                            child: TextField(
                              controller: _usernameController,
                              style: GoogleFonts.cairo(
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              onChanged: (value) {
                                if (_usernameError != null) {
                                  setState(() => _usernameError = null);
                                }
                              },
                              decoration: InputDecoration(
                                labelText: context.tr('username'),
                                labelStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey.shade600, fontSize: 14),
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                hintText: context.tr('username_hint'),
                                hintStyle: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey.shade400, fontSize: 13),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                              ),
                            ),
                          ),
                          if (_usernameError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6, right: 12, left: 12),
                              child: Text(
                                _usernameError!,
                                style: GoogleFonts.cairo(fontSize: 12, color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // حقل كلمة المرور
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF8F4F2),
                              borderRadius: BorderRadius.circular(14),
                              border: _passwordError != null ? Border.all(color: Colors.red, width: 1) : null,
                            ),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              style: GoogleFonts.cairo(
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              onChanged: (value) {
                                if (_passwordError != null) {
                                  setState(() => _passwordError = null);
                                }
                              },
                              decoration: InputDecoration(
                                labelText: context.tr('password'),
                                labelStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey.shade600, fontSize: 14),
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                hintText: context.tr('password_hint'),
                                hintStyle: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey.shade400, fontSize: 13),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                    size: 20,
                                    color: isDark ? Colors.grey[400] : Colors.grey.shade500,
                                  ),
                                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                ),
                              ),
                            ),
                          ),
                          if (_passwordError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6, right: 12, left: 12),
                              child: Text(
                                _passwordError!,
                                style: GoogleFonts.cairo(fontSize: 12, color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // نسيت كلمة المرور
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            context.tr('forgot_password'),
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // زر تسجيل الدخول
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: _isLoading
                              ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Text(context.tr('login_btn'), style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // إنشاء حساب جديد
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(context.tr('no_account'), style: GoogleFonts.cairo(fontSize: 13, color: isDark ? Colors.grey[400] : Colors.grey.shade600)),
                          TextButton(
                            onPressed: () => context.push('/register'),
                            child: Text(context.tr('create_account'), style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // أو عبر
                      Row(
                        children: [
                          Expanded(child: Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(context.tr('or_via'), style: GoogleFonts.cairo(fontSize: 12, color: isDark ? Colors.grey[500] : Colors.grey.shade500)),
                          ),
                          Expanded(child: Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // أزرار التواصل
                      Row(
                        children: [
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
                                height: 28,
                                width: 28,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'G',
                                    style: GoogleFonts.cairo(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF2C2522) : const Color(0xFFF5EBE7),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: Icon(Icons.facebook, size: 32, color: Colors.blue.shade700),
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