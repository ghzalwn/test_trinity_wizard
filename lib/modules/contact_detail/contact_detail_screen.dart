import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:test_trinity_wizard/controller/app_controller.dart';
import 'package:test_trinity_wizard/models/user.dart';
import 'package:test_trinity_wizard/utils/app_colors.dart';
import 'package:test_trinity_wizard/utils/app_icons.dart';
import 'package:test_trinity_wizard/widgets/avatar_with_initial.dart';
import 'package:test_trinity_wizard/widgets/custom_app_bar.dart';
import 'package:uuid/uuid.dart';

class ContactDetailScren extends StatefulWidget {
  const ContactDetailScren({super.key});

  @override
  State<ContactDetailScren> createState() => ContactDetailScrenState();
}

class ContactDetailScrenState extends State<ContactDetailScren> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late TextEditingController _email;
  late AppController appController;

  bool isEdit = false;

  DateTime _selectedDate = DateTime.now(); // Default to current date

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1945),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            hintColor: Colors.blue, // Selected date color
            colorScheme: ColorScheme.light(primary: AppColors.blue),
            dialogBackgroundColor:
                Colors.white, // Background color of the dialog
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              dayStyle: TextStyle(color: Colors.black), // Day text color
              dividerColor: Colors.blueAccent, // Divider color
              confirmButtonStyle: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(AppColors.blue),
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
              ),
              cancelButtonStyle: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.grey),
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    appController = Provider.of<AppController>(context, listen: false);
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _email = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      appController = Provider.of<AppController>(context, listen: false);
      if (appController.selectedUser != null) {
        _firstName.text = appController.selectedUser!.firstName ?? '';
        _lastName.text = appController.selectedUser!.lastName ?? '';
        _email.text = appController.selectedUser!.email ?? '';

        DateTime dateTime =
            DateFormat('d/M/yyyy').parse(appController.selectedUser!.dob ?? '');
        setState(() {
          _selectedDate = dateTime;
          isEdit = true;
        });
      }
    });
  }

  String? _validateEmail(String? value) {
    final emailPattern = RegExp(r'^[^@]+@[^@]+\.[a-zA-Z]{2,}$');
    if (value == null || value.isEmpty) {
      return null; // Email is optional
    } else if (!emailPattern.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    if (mounted) {
      appController.clearSelectedUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(200.0),
          child: CustomAppBar(
            titleBar: 'Contacts Details',
            showButtonBack: true,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const AvatarWithInitial(name: "Ameria Suirya"),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Main Information",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blue,
                      textStyle: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                const Divider(
                  color: AppColors.darkGray,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'First Name',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '*',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.red,
                            textStyle:
                                const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.blue, // border color
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: TextFormField(
                      controller: _firstName,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'field required';
                        }

                        return null;
                      },
                      cursorColor:
                          AppColors.primary, // set the cursor color here
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: AppColors.blue,
                        ),
                        hintText: 'Enter First Name',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textGrey,
                        ),
                        border: InputBorder.none, // hide the default border
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                        ), // Adjust this as needed
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Last Name',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '*',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.red,
                            textStyle: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.blue, // border color
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _lastName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'field required';
                        }

                        return null;
                      },
                      cursorColor:
                          AppColors.primary, // set the cursor color here
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: AppColors.blue,
                        ),
                        hintText: 'Enter Last Name',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textGrey,
                        ),
                        border: InputBorder.none, // hide the default border
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                        ), // Adjust this as needed
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Sub Information",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blue,
                      textStyle: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                const Divider(
                  color: AppColors.darkGray,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Email',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.red,
                            textStyle:
                                const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.blue, // border color
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _email,
                      validator: _validateEmail,
                      cursorColor:
                          AppColors.primary, // set the cursor color here
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.blue,
                        ),
                        hintText: 'Enter Email',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textGrey,
                        ),
                        border: InputBorder.none, // hide the default border
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                        ), // Adjust this as needed
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Date of Birth',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.red,
                            textStyle:
                                const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.blue, // border color
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.blue,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            DateFormat('d/M/yyyy')
                                .format(_selectedDate)
                                .toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 120,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (appController.selectedUser != null) {
                          User newData = User(
                              id: appController.selectedUser!.id,
                              firstName: _firstName.text,
                              lastName: _lastName.text,
                              email: _email.text,
                              dob: DateFormat('d/M/yyyy')
                                  .format(_selectedDate)
                                  .toString());
                          appController
                              .updateDataUser(
                                  appController.selectedUser!.id!, newData)
                              .whenComplete(() {
                            if (mounted) {
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            }
                          });
                        } else {
                          User newData = User(
                              id: const Uuid().v4(),
                              firstName: _firstName.text,
                              lastName: _lastName.text,
                              email: _email.text,
                              dob: DateFormat('d/M/yyyy')
                                  .format(_selectedDate)
                                  .toString());
                          appController.addDataUser(newData).whenComplete(() {
                            if (mounted) {
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            }
                          });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 120),
                      backgroundColor: const Color.fromRGBO(150, 211, 242, 0.8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Border radius
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        isEdit ? 'Update' : 'Save',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.boldBlue,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.red, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        appController
                            .removeData(appController.selectedUser!.id!)
                            .whenComplete(() {
                          if (mounted) {
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 120),
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Remove',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
