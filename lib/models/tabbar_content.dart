// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TabbarContent {
  String? title;
  Widget? screenContent;
  bool? showFloatingButton;
  TabbarContent(
      {this.title, this.screenContent, this.showFloatingButton = false});
}
