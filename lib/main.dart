// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';

// // import 'package:veggify_delivery_app/global/toast.dart';
// // import 'package:veggify_delivery_app/provider/Auth/login_provider.dart';
// // import 'package:veggify_delivery_app/provider/Auth/signup_provider.dart';
// // import 'package:veggify_delivery_app/provider/LocationProvider/location_provider.dart';
// // import 'package:veggify_delivery_app/provider/Profile/profile_provider.dart';
// // import 'package:veggify_delivery_app/provider/RiderStatus/delivery_status_provider.dart';
// // import 'package:veggify_delivery_app/provider/Wallet/wallet_provider.dart';
// // import 'package:veggify_delivery_app/views/splash_screen.dart';

// // // Global Navigator Key
// // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// // void main() {
// //   WidgetsFlutterBinding.ensureInitialized();

// //   GlobalToast.init(navigatorKey);

// //   runApp(
// //     MultiProvider(
// //       providers: [
// //         ChangeNotifierProvider(create: (_) => SignupProvider()),
// //         ChangeNotifierProvider(create: (_) => LoginProvider()),
// //         ChangeNotifierProvider(create: (_) => LocationProvider()),
// //         ChangeNotifierProvider(create: (_) => ProfileProvider()),
// //         ChangeNotifierProvider(create: (_) => WalletProvider()),
// //         ChangeNotifierProvider(create: (_) => DeliveryStatusProvider()),
// //       ],
// //       child: const MyApp(),
// //     ),
// //   );
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Veggify Delivery App',
// //       navigatorKey: navigatorKey,
// //       debugShowCheckedModeBanner: false,
// //       theme: ThemeData(
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// //       ),
// //       home: const SplashScreen(),
// //     );
// //   }
// // }

// // lib/main.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:veggify_delivery_app/global/toast.dart';
// import 'package:veggify_delivery_app/provider/AcceptedOrder/accepted_order_provider.dart';
// import 'package:veggify_delivery_app/provider/Auth/login_provider.dart';
// import 'package:veggify_delivery_app/provider/Auth/signup_provider.dart';
// import 'package:veggify_delivery_app/provider/Dashboard/dashboard_provider.dart';
// import 'package:veggify_delivery_app/provider/LocationProvider/location_provider.dart';
// import 'package:veggify_delivery_app/provider/PendingOrder/new_order_provider.dart';
// import 'package:veggify_delivery_app/provider/PickedOrder/picked_order_provider.dart';
// import 'package:veggify_delivery_app/provider/Profile/profile_provider.dart';
// import 'package:veggify_delivery_app/provider/RiderStatus/delivery_status_provider.dart';
// import 'package:veggify_delivery_app/provider/Wallet/wallet_provider.dart';
// import 'package:veggify_delivery_app/services/PendingOrder/pending_order_service.dart';
// import 'package:veggify_delivery_app/views/splash_screen.dart';

// // NotificationTester (zero-touch tester that observes DeliveryStatusProvider)
// import 'package:veggify_delivery_app/utils/notification_tester.dart';

// // Global navigator key for GlobalToast / navigation from services
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize global toast (requires navigatorKey)
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
//         ChangeNotifierProvider(create: (_) => DashboardProvider()),
//         ChangeNotifierProvider(create: (_) => NewOrderProvider()),
//         ChangeNotifierProvider(create: (_) => AcceptedOrderProvider()),
//         ChangeNotifierProvider(create: (_) => PickedOrderProvider()),
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

//       // Make navigatorKey available app-wide for toasts/navigation from services
//       navigatorKey: navigatorKey,

//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),

//       // IMPORTANT: use builder to insert NotificationTester *inside* MaterialApp
//       builder: (context, child) {
//         return Stack(
//           children: [
//             if (child != null) child,
//             // NotificationTester is invisible (SizedBox.shrink) but will listen to provider
//             const NotificationTester(),
//           ],
//         );
//       },

//       home: const SplashScreen(),
//     );
//   }
// }











// // lib/main.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:veggify_delivery_app/global/toast.dart';
// import 'package:veggify_delivery_app/provider/AcceptedOrder/accepted_order_provider.dart';
// import 'package:veggify_delivery_app/provider/Auth/login_provider.dart';
// import 'package:veggify_delivery_app/provider/Auth/signup_provider.dart';
// import 'package:veggify_delivery_app/provider/Dashboard/dashboard_provider.dart';
// import 'package:veggify_delivery_app/provider/LocationProvider/location_provider.dart';
// import 'package:veggify_delivery_app/provider/PendingOrder/new_order_provider.dart';
// import 'package:veggify_delivery_app/provider/PickedOrder/picked_order_provider.dart';
// import 'package:veggify_delivery_app/provider/Profile/profile_provider.dart';
// import 'package:veggify_delivery_app/provider/RiderStatus/delivery_status_provider.dart';
// import 'package:veggify_delivery_app/provider/Wallet/wallet_provider.dart';
// import 'package:veggify_delivery_app/services/PendingOrder/pending_order_service.dart';
// import 'package:veggify_delivery_app/utils/session_manager.dart';
// import 'package:veggify_delivery_app/views/splash_screen.dart';

// import 'package:veggify_delivery_app/utils/notification_tester.dart';

// // Global navigator key for GlobalToast / navigation from services
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
//         ChangeNotifierProvider(create: (_) => DashboardProvider()),
//         ChangeNotifierProvider(create: (_) => NewOrderProvider()),
//         ChangeNotifierProvider(create: (_) => AcceptedOrderProvider()),
//         ChangeNotifierProvider(create: (_) => PickedOrderProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {

//   @override
//   void initState() {
//     super.initState();

//     /// 🔥 AUTO START BACKGROUND LOCATION FROM MAIN
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final loginProvider =
//           Provider.of<LoginProvider>(context, listen: false);

//       final locationProvider =
//           Provider.of<LocationProvider>(context, listen: false);

//       /// Listen for login status permanently
//       loginProvider.addListener(()async {
//               final id = await SessionManager.keyUserId;


//         if (id != '') {
//           print("kkkkkkkkkkkkk$id");
//           final riderId = id;

//           // Start location tracking
//           locationProvider.initLocation(riderId);
//           locationProvider.startLiveLocationUpdates(riderId);

//           debugPrint("📍 Location tracking started from MAIN for rider $riderId");
//         } else {
//           // Stop when logged out
//           locationProvider.stopLiveLocationUpdates();
//           debugPrint("🛑 Location tracking stopped (logout)");
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Veggify Delivery App',
//       navigatorKey: navigatorKey,
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),

//       builder: (context, child) {
//         return Stack(
//           children: [
//             if (child != null) child,
//             const NotificationTester(),
//           ],
//         );
//       },

//       home: const SplashScreen(),
//     );
//   }
// }

















// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:veggify_delivery_app/global/toast.dart';
import 'package:veggify_delivery_app/provider/AcceptedOrder/accepted_order_provider.dart';
import 'package:veggify_delivery_app/provider/Auth/login_provider.dart';
import 'package:veggify_delivery_app/provider/Auth/signup_provider.dart';
import 'package:veggify_delivery_app/provider/Dashboard/dashboard_provider.dart';
import 'package:veggify_delivery_app/provider/LocationProvider/location_provider.dart';
import 'package:veggify_delivery_app/provider/PendingOrder/new_order_provider.dart';
import 'package:veggify_delivery_app/provider/PickedOrder/picked_order_provider.dart';
import 'package:veggify_delivery_app/provider/Profile/profile_provider.dart';
import 'package:veggify_delivery_app/provider/RiderStatus/delivery_status_provider.dart';
import 'package:veggify_delivery_app/provider/Wallet/wallet_provider.dart';
import 'package:veggify_delivery_app/services/PendingOrder/pending_order_service.dart';
import 'package:veggify_delivery_app/utils/session_manager.dart';
import 'package:veggify_delivery_app/views/splash_screen.dart';

import 'package:veggify_delivery_app/utils/notification_tester.dart';

// Global navigator key for GlobalToast / navigation from services
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
        ChangeNotifierProvider(create: (_) => AcceptedOrderProvider()),
        ChangeNotifierProvider(create: (_) => PickedOrderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  VoidCallback? _loginListener;

  @override
  void initState() {
    super.initState();

    /// 🔥 AUTO START BACKGROUND LOCATION FROM MAIN
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   final loginProvider =
    //       Provider.of<LoginProvider>(context, listen: false);
    //   final locationProvider =
    //       Provider.of<LocationProvider>(context, listen: false);

    //   // 1️⃣ On app start: check if rider is already logged in (SessionManager)
    //   final initialId = await SessionManager.getUserId();
    //   debugPrint("[MAIN] SessionManager initialId: $initialId");

    //   if (initialId != "") {
    //     debugPrint("✅ [MAIN] Existing rider session found: $initialId");

    //     // This will print from LocationProvider.initLocation and _updateLiveLocation
    //     await locationProvider.initLocation(initialId.toString());
    //     locationProvider.startLiveLocationUpdates(initialId.toString());

    //     debugPrint(
    //       "📍 [MAIN] Location tracking started on app launch for rider $initialId",
    //     );
    //   } else {
    //     debugPrint("ℹ️ [MAIN] No rider session on launch, not starting tracking");
    //   }

    //   // 2️⃣ Listen for future login/logout changes
    //   _loginListener = () async {
    //     final id = await SessionManager.keyUserId;
    //     debugPrint("👀 [MAIN] LoginProvider changed, SessionManager userId: $id");

    //     if (id != null && id.isNotEmpty) {
    //       final riderId = id;
    //       debugPrint("✅ [MAIN] Rider logged in: $riderId");

    //       await locationProvider.initLocation(riderId);
    //       locationProvider.startLiveLocationUpdates(riderId);

    //       debugPrint(
    //         "📍 [MAIN] Location tracking started from MAIN listener for rider $riderId",
    //       );
    //     } else {
    //       locationProvider.stopLiveLocationUpdates();
    //       debugPrint("🛑 [MAIN] Location tracking stopped (logout)");
    //     }
    //   };

    //   loginProvider.addListener(_loginListener!);
    // });
  }

  @override
  void dispose() {
    final loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    if (_loginListener != null) {
      loginProvider.removeListener(_loginListener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veggify Express',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      builder: (context, child) {
        return Stack(
          children: [
            if (child != null) child,
            const NotificationTester(),
          ],
        );
      },
      home: const SplashScreen(),
    );
  }
}
