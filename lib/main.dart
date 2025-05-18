import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Screens/Splash Screen/splash_screen.dart';
import 'Them/color_notifier_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ColorNotifier colorNotifier = ColorNotifier(Colors.white);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Reference design dimensions (width x height)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ValueListenableBuilder<Color>(
          valueListenable: colorNotifier,
          builder: (context, currentColor, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'University Quality Assurance',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                scaffoldBackgroundColor: Colors.white,
                textTheme: TextTheme(
                  bodyMedium: TextStyle(
                    color: Colors.black87,
                    fontSize: 16.sp, // Use ScreenUtil scaling
                  ),
                ),
              ),
              initialRoute: '/',
              routes: {
                '/': (context) => const SplashScreen(),
              },
            );
          },
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'Screens/Splash Screen/splash_screen.dart';
// import 'Them/color_notifier_page.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({
//     super.key,
//   });
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   final ColorNotifier colorNotifier = ColorNotifier(Colors.white);
//
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<Color>(
//         valueListenable: colorNotifier,
//         builder: (context, currentColor, child) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             title: 'University Quality Assurance',
//             theme: ThemeData(
//               primarySwatch: Colors.blue,
//               scaffoldBackgroundColor: Colors.white,
//               textTheme: const TextTheme(
//                 bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
//               ),
//             ),
//             initialRoute: '/',
//             routes: {
//               '/': (context) => const SplashScreen(),
//             },
//           );
//         });
//   }
// }
