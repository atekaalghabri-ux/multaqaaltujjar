import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/security/security_service.dart';

class LockScreen extends StatefulWidget {
  final bool isSettingPin;
  final String targetRoute;

  const LockScreen({
    super.key,
    this.isSettingPin = false,
    this.targetRoute = '/dashboard',
  });

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String _pin = '';
  String _firstPin = ''; // Used when setting pin for confirmation
  bool _isConfirming = false;
  String? _errorMessage;
  bool _hasBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    if (widget.isSettingPin) return;

    final hasBiometricsEnabled = await SecurityService.isFingerprintEnabled();
    final canAuth = await SecurityService.canAuthenticate();

    if (hasBiometricsEnabled && canAuth) {
      setState(() => _hasBiometrics = true);
      // Auto-trigger biometric after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerBiometricAuth();
      });
    }
  }

  Future<void> _triggerBiometricAuth() async {
    final reason = context.tr('auth_reason');
    final authenticated = await SecurityService.authenticateWithBiometrics(reason);
    if (authenticated && mounted) {
      context.go(widget.targetRoute);
    }
  }

  void _handleNumberPress(int number) {
    if (_pin.length >= 4) return;
    setState(() {
      _errorMessage = null;
      _pin += number.toString();
    });

    if (_pin.length == 4) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _processPin();
      });
    }
  }

  void _handleDelete() {
    if (_pin.isEmpty) return;
    setState(() {
      _errorMessage = null;
      _pin = _pin.substring(0, _pin.length - 1);
    });
  }

  Future<void> _processPin() async {
    if (widget.isSettingPin) {
      if (!_isConfirming) {
        // Set first PIN and ask for confirmation
        setState(() {
          _firstPin = _pin;
          _pin = '';
          _isConfirming = true;
        });
      } else {
        // Confirm second PIN matches first
        if (_pin == _firstPin) {
          await SecurityService.setPin(_pin);
          await SecurityService.setAppLockEnabled(true);
          if (mounted) {
            context.pop(true); // Return success to settings
          }
        } else {
          setState(() {
            _pin = '';
            _errorMessage = context.tr('pin_mismatch');
          });
        }
      }
    } else {
      // Authenticating
      final matches = await SecurityService.verifyPin(_pin);
      if (matches) {
        if (mounted) {
          context.go(widget.targetRoute);
        }
      } else {
        setState(() {
          _pin = '';
          _errorMessage = context.tr('incorrect_pin');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF99574D);

    String titleText = context.tr('enter_pin');
    if (widget.isSettingPin) {
      titleText = _isConfirming ? context.tr('confirm_pin') : context.tr('set_pin');
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 20),
            // Header: Logo and Title
            Column(
              children: [
                Icon(
                  Iconsax.lock5,
                  size: 64,
                  color: primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  titleText,
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF572F29),
                  ),
                ),
                const SizedBox(height: 10),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: GoogleFonts.cairo(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),

            // PIN Indicator Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isFilled = index < _pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled
                        ? primaryColor
                        : (isDark ? const Color(0xFF2C2C2C) : const Color(0xFFEBEBEB)),
                    border: Border.all(
                      color: isFilled ? primaryColor : Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
                );
              }),
            ),

            // Keyboard Grid
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                children: [
                  for (var row = 0; row < 3; row++) ...[
                    Row(
                      textDirection: TextDirection.ltr,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(3, (col) {
                        final number = row * 3 + col + 1;
                        return _buildKeypadButton(number.toString(), () => _handleNumberPress(number));
                      }),
                    ),
                    const SizedBox(height: 15),
                  ],
                  Row(
                    textDirection: TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Biometric or Empty
                      _hasBiometrics
                          ? _buildKeypadIcon(Iconsax.finger_scan, _triggerBiometricAuth)
                          : const SizedBox(width: 70, height: 70),
                      _buildKeypadButton('0', () => _handleNumberPress(0)),
                      _buildKeypadIcon(Icons.backspace_outlined, _handleDelete),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String label, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5EBE7),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF572F29),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadIcon(IconData icon, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5EBE7),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 26,
          color: const Color(0xFF99574D),
        ),
      ),
    );
  }
}
