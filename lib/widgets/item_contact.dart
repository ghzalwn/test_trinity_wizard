import 'package:flutter/material.dart';
import 'package:test_trinity_wizard/models/user.dart';
import 'package:test_trinity_wizard/utils/app_colors.dart';
import 'package:test_trinity_wizard/widgets/avatar_with_initial.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemContact extends StatelessWidget {
  final User item;
  final bool isYou;
  final Function(User data) onPressFunction;
  const ItemContact({
    super.key,
    required this.item,
    this.isYou = false,
    required this.onPressFunction,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressFunction(item),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            AvatarWithInitial(
              height: 50,
              width: 50,
              textSize: 24,
              name: "${item.firstName!} ${item.lastName}",
            ),
            const SizedBox(
              width: 10,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${item.firstName!} ${item.lastName}",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const TextSpan(
                    text: ' ',
                  ),
                  TextSpan(
                    text: isYou ? '(you)' : '',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkGray,
                      textStyle: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
