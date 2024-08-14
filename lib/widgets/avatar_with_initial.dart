import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_trinity_wizard/utils/app_colors.dart';

class AvatarWithInitial extends StatelessWidget {
  final String name;
  final double width;
  final double height;
  final double textSize;

  const AvatarWithInitial(
      {super.key,
      required this.name,
      this.width = 100.0,
      this.height = 100.0,
      this.textSize = 40});

  String _getInitials() {
    List<String> names = name.split(' ');
    String initials = '';
    if (names.isNotEmpty) {
      initials = names[0][0].toUpperCase();
      if (names.length > 1) {
        initials += names[1][0].toUpperCase();
      }
    }
    return initials;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: CircleAvatar(
        radius: 30.0,
        backgroundColor: AppColors.blue,
        child: Text(
          _getInitials(),
          style: GoogleFonts.poppins(
            fontSize: textSize,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
