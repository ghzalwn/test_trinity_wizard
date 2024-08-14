import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_trinity_wizard/controller/app_controller.dart';
import 'package:test_trinity_wizard/routes/app_routes.dart';
import 'package:test_trinity_wizard/utils/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_trinity_wizard/utils/app_icons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appController = Provider.of<AppController>(context);

    return Form(
      key: _formKey,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi There!",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blue,
                ),
              ),
              Text(
                "Please login to see your contact list",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.darkGray, // border color
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: TextFormField(
                    controller: _userId,
                    cursorColor: AppColors.blue, // set the cursor color here
                    decoration: InputDecoration(
                      prefixIcon: SizedBox(
                        height: 10,
                        width: 10,
                        child: SvgPicture.asset(
                          AppIcons.peopleIcon,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      hintText: 'Enter User ID',
                      hintStyle: const TextStyle(
                        color: AppColors.darkGray,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none, // hide the default border
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15.0,
                      ), // Adjust this as needed
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    appController.loadUserById(_userId.text).whenComplete(() {
                      if (appController.user != null) {
                        Navigator.pushNamed(context, AppRoutes.homeScreen);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 120),
                    backgroundColor: const Color.fromRGBO(150, 211, 242, 0.9),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Border radius
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Login',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.boldBlue,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
