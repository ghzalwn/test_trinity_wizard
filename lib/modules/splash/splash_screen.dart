import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_trinity_wizard/controller/app_controller.dart';
import 'package:test_trinity_wizard/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final appController = Provider.of<AppController>(context, listen: false);

      if (!mounted) return;

      try {
        await appController.checkLoginStatus();
        if (appController.user != null) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
          }
        } else {
          if (mounted) {
            Navigator.pushNamed(context, AppRoutes.loginScreen);
          }
        }
      } catch (e) {
        print('Error checking login status: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
