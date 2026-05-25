import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/security/security_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;
      final hasLock = await SecurityService.isAppLockEnabled();
      if (!mounted) return;
      if (hasLock) {
        context.go('/lock', extra: {'targetRoute': '/login'});
      } else {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFF99574D),
      body: Center(
        child: SizedBox(
          width: 160,
          child: Image.asset(
            'assets/images/slogan.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}