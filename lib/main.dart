import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_trinity_wizard/controller/app_controller.dart';
import 'package:test_trinity_wizard/routes/app_routes.dart';
import 'package:test_trinity_wizard/service/api_service.dart';
import 'package:test_trinity_wizard/utils/app_colors.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppController(ApiService()),
      child: const MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
BuildContext? appContext;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return const MainApp();
      },
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: MaterialApp(
        title: 'TEST',
        theme: ThemeData(
          primaryColor: Colors.white,
          colorScheme: const ColorScheme.light(
              primary: Colors.white, secondary: AppColors.blue),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: AppColors.blue, // Set the cursor color
            selectionColor:
                Colors.blue.withOpacity(0.4), // Set the selection color
            selectionHandleColor:
                AppColors.blue, // Set the selection handle color
          ),
        ),
        onGenerateRoute: AppRoutes.onGenerateRoute,
        navigatorKey: navigatorKey,
      ),
    );
  }
}
