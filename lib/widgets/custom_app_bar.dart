import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_trinity_wizard/controller/app_controller.dart';
import 'package:test_trinity_wizard/routes/app_routes.dart';
import 'package:test_trinity_wizard/utils/app_colors.dart';

class CustomAppBar extends StatelessWidget {
  final String titleBar;
  final bool showButtonBack;
  final bool isProfile;

  const CustomAppBar({
    super.key,
    required this.titleBar,
    this.showButtonBack = true,
    this.isProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    final appController = Provider.of<AppController>(context);

    return Container(
      color: Colors.white,
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.lightGray,
              blurRadius: 10,
              spreadRadius: -2,
              blurStyle: BlurStyle.outer,
              offset: Offset(0, 0),
            ),
          ],
          // borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
        ),
        padding:
            const EdgeInsets.only(left: 20.0, right: 20.0, top: 60, bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: isProfile
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
          children: [
            if (showButtonBack)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            Text(
              titleBar,
              style: GoogleFonts.poppins(
                fontSize: 23,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            if (isProfile)
              InkWell(
                onTap: () {
                  appController.logout();
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.loginScreen);
                },
                child: Text(
                  'Logout',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.blue,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
