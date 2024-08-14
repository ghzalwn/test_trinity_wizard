import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_trinity_wizard/controller/app_controller.dart';
import 'package:test_trinity_wizard/data/list_user.dart';
import 'package:test_trinity_wizard/models/user.dart';
import 'package:test_trinity_wizard/routes/app_routes.dart';
import 'package:test_trinity_wizard/utils/app_colors.dart';
import 'package:test_trinity_wizard/utils/app_icons.dart';
import 'package:test_trinity_wizard/utils/utils.dart';
import 'package:test_trinity_wizard/widgets/avatar_with_initial.dart';
import 'package:test_trinity_wizard/widgets/item_contact.dart';

class MyContactScreen extends StatefulWidget {
  const MyContactScreen({super.key});

  @override
  State<MyContactScreen> createState() => _MyContactScreenState();
}

class _MyContactScreenState extends State<MyContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _keyword = TextEditingController();

  late AppController appController;

  @override
  void initState() {
    super.initState();

    appController = Provider.of<AppController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appController.loadAllUsers();
    });
  }

  Future<void> _refreshData() async {
    appController.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    final appController = Provider.of<AppController>(context);

    return RefreshIndicator(
      color: AppColors.blue,
      onRefresh: _refreshData,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Form(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.grey, // border color
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                  ),
                  child: TextFormField(
                    controller: _keyword,
                    onChanged: (val) {
                      appController
                          .loadAllUsers(keyword: val)
                          .whenComplete(() {}); // Replace with the desired ID
                    },
                    cursorColor: AppColors.primary, // set the cursor color here
                    decoration: InputDecoration(
                      suffixIcon: SizedBox(
                        height: 5,
                        width: 5,
                        child: SvgPicture.asset(
                          AppIcons.searchIcon,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      hintText: 'Search your contact list...',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: AppColors.textGrey,
                      ),
                      border: InputBorder.none, // hide the default border
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            appController.isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: appController.headers?.length,
                      itemBuilder: (context, index) {
                        var header = appController.headers?[index];
                        var items = appController.groupedData?[header]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors
                                        .grey, // Set the color of the border
                                    width: 0.5, // Set the width of the border
                                  ),
                                ),
                              ),
                              child: Text(
                                header ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.blue,
                                ),
                              ),
                            ),
                            if (items != null && items.isNotEmpty)
                              ...items.map((item) => ItemContact(
                                    onPressFunction: (data) {
                                      appController.setSelectedUser(data);
                                      Navigator.pushNamed(context,
                                          AppRoutes.detailContactScreen);
                                    },
                                    item: item,
                                    isYou: item.id == appController.user!.id,
                                  ))
                            else
                              const SizedBox(), // Empty widget if no items are available
                          ],
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
