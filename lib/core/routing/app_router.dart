import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../localization/app_localizations.dart';

// استيراد الشاشات الأساسية
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/products/presentation/screens/product_details_screen.dart';
import '../../features/products/presentation/screens/products_by_category_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/cart/presentation/screens/checkout_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/wishlist/presentation/screens/wishlist_screen.dart';
import '../../features/merchant/presentation/screens/merchant_dashboard_screen.dart';
import '../../features/merchant/presentation/screens/add_product_screen.dart';
import '../../features/merchant/presentation/screens/merchant_orders_screen.dart';
import '../../features/auth/presentation/screens/lock_screen.dart';
import '../../features/merchant/presentation/screens/store_setup_screen.dart';
import '../../features/merchant/presentation/screens/manage_products_screen.dart';
import '../../features/merchant/presentation/screens/merchant_order_details_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/splash',
      ),
      GoRoute(
        path: '/lock',
        builder: (context, state) {
          final extra = state.extra is Map ? (state.extra as Map).cast<String, dynamic>() : <String, dynamic>{};
          final isSettingPin = extra['isSettingPin'] as bool? ?? false;
          final targetRoute = extra['targetRoute'] as String? ?? '/dashboard';
          return LockScreen(
            isSettingPin: isSettingPin,
            targetRoute: targetRoute,
          );
        },
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) {
          final userName = state.extra as String? ?? '';
          return DashboardScreen(userName: userName);
        },
      ),
      GoRoute(
        path: '/product_details',
        builder: (context, state) => const ProductDetailsScreen(),
      ),
      GoRoute(
        path: '/products_by_category',
        builder: (context, state) {
          final categoryName = state.extra as String? ?? context.tr('all_categories');
          return ProductsByCategoryScreen(categoryName: categoryName);
        },
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) {
          final extra = state.extra is Map ? (state.extra as Map).cast<String, dynamic>() : <String, dynamic>{};
          return CheckoutScreen(
            totalAmount: extra['totalAmount'] ?? 0.0,
            subtotal: extra['subtotal'] ?? 0.0,
            shipping: extra['shipping'] ?? 0.0,
            cartItems: extra['cartItems'] ?? [],
          );
        },
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/wishlist',
        builder: (context, state) => const WishlistScreen(),
      ),
      GoRoute(
        path: '/merchant_dashboard',
        builder: (context, state) => const MerchantDashboardScreen(),
      ),
      GoRoute(
        path: '/merchant/add_product',
        builder: (context, state) => const AddProductScreen(),
      ),
      GoRoute(
        path: '/merchant_orders',
        builder: (context, state) => const MerchantOrdersScreen(),
      ),
      GoRoute(
        path: '/store_setup',
        builder: (context, state) => const StoreSetupScreen(),
      ),
      GoRoute(
        path: '/manage_products',
        builder: (context, state) => const ManageProductsScreen(),
      ),
      GoRoute(
        path: '/merchant_order_details',
        builder: (context, state) => const MerchantOrderDetailsScreen(),
      ),
    ],
  );
});
