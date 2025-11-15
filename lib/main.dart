// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:veggify_delivery_app/global/toast.dart';
// import 'package:veggify_delivery_app/provider/Auth/login_provider.dart';
// import 'package:veggify_delivery_app/provider/Auth/signup_provider.dart';
// import 'package:veggify_delivery_app/provider/LocationProvider/location_provider.dart';
// import 'package:veggify_delivery_app/provider/Profile/profile_provider.dart';
// import 'package:veggify_delivery_app/provider/RiderStatus/delivery_status_provider.dart';
// import 'package:veggify_delivery_app/provider/Wallet/wallet_provider.dart';
// import 'package:veggify_delivery_app/views/splash_screen.dart';

// // Global Navigator Key
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();

//   GlobalToast.init(navigatorKey);

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => SignupProvider()),
//         ChangeNotifierProvider(create: (_) => LoginProvider()),
//         ChangeNotifierProvider(create: (_) => LocationProvider()),
//         ChangeNotifierProvider(create: (_) => ProfileProvider()),
//         ChangeNotifierProvider(create: (_) => WalletProvider()),
//         ChangeNotifierProvider(create: (_) => DeliveryStatusProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Veggify Delivery App',
//       navigatorKey: navigatorKey,
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const SplashScreen(),
//     );
//   }
// }

// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:veggify_delivery_app/global/toast.dart';
import 'package:veggify_delivery_app/provider/Auth/login_provider.dart';
import 'package:veggify_delivery_app/provider/Auth/signup_provider.dart';
import 'package:veggify_delivery_app/provider/Dashboard/dashboard_provider.dart';
import 'package:veggify_delivery_app/provider/LocationProvider/location_provider.dart';
import 'package:veggify_delivery_app/provider/PendingOrder/new_order_provider.dart';
import 'package:veggify_delivery_app/provider/Profile/profile_provider.dart';
import 'package:veggify_delivery_app/provider/RiderStatus/delivery_status_provider.dart';
import 'package:veggify_delivery_app/provider/Wallet/wallet_provider.dart';
import 'package:veggify_delivery_app/services/PendingOrder/pending_order_service.dart';
import 'package:veggify_delivery_app/views/splash_screen.dart';

// NotificationTester (zero-touch tester that observes DeliveryStatusProvider)
import 'package:veggify_delivery_app/utils/notification_tester.dart';

// Global navigator key for GlobalToast / navigation from services
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize global toast (requires navigatorKey)
  GlobalToast.init(navigatorKey);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignupProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryStatusProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => NewOrderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veggify Delivery App',

      // Make navigatorKey available app-wide for toasts/navigation from services
      navigatorKey: navigatorKey,

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      // IMPORTANT: use builder to insert NotificationTester *inside* MaterialApp
      builder: (context, child) {
        return Stack(
          children: [
            if (child != null) child,
            // NotificationTester is invisible (SizedBox.shrink) but will listen to provider
            const NotificationTester(),
          ],
        );
      },

      home: const SplashScreen(),
    );
  }
}
