import 'package:flutter/material.dart';
import 'package:test_trinity_wizard/modules/contact_detail/contact_detail_screen.dart';
import 'package:test_trinity_wizard/modules/home/home_screen.dart';
import 'package:test_trinity_wizard/modules/login/login_screen.dart';
import 'package:test_trinity_wizard/modules/splash/splash_screen.dart';

class AppRoutes {
  static const String splashScreen = '/';
  static const String loginScreen = '/login-screen';
  static const String homeScreen = '/home-screen';
  static const String detailContactScreen = '/detail-contact-screen';

  static Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: const RouteSettings(name: splashScreen),
        );
      case loginScreen:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: const RouteSettings(name: loginScreen),
        );

      case homeScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: const RouteSettings(name: homeScreen),
        );

      case detailContactScreen:
        return MaterialPageRoute(
          builder: (_) => const ContactDetailScren(),
          settings: const RouteSettings(name: detailContactScreen),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic>? _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: const Center(
            child: Text('Page Not Found !'),
          ),
        );
      },
    );
  }
}
