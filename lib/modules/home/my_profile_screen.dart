import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_trinity_wizard/controller/app_controller.dart';
import 'package:test_trinity_wizard/utils/app_colors.dart';
import 'package:test_trinity_wizard/widgets/avatar_with_initial.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Provider.of<AppController>(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          AvatarWithInitial(
            name:
                "${appController.user?.firstName} ${appController.user?.lastName}",
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${appController.user?.firstName} ${appController.user?.lastName}",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${appController.user?.email}",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${appController.user?.dob}",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(150, 211, 242, 1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Border radius
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Update My Detail',
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
    );
  }
}
