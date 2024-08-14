import 'package:flutter/material.dart';
import 'package:test_trinity_wizard/models/tabbar_content.dart';
import 'package:test_trinity_wizard/modules/home/my_contact_screen.dart';
import 'package:test_trinity_wizard/modules/home/my_profile_screen.dart';
import 'package:test_trinity_wizard/routes/app_routes.dart';
import 'package:test_trinity_wizard/utils/app_colors.dart';
import 'package:test_trinity_wizard/widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<TabbarContent> _listTabbarContent = [
    TabbarContent(
      title: 'My Contacts',
      screenContent: MyContactScreen(),
      showFloatingButton: true,
    ),
    TabbarContent(
        title: 'My Profile', screenContent: MyProfileScreen(), isProfile: true)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200.0),
        child: CustomAppBar(
          titleBar: _listTabbarContent[_selectedIndex].title ?? '-',
          showButtonBack: false,
          isProfile: _listTabbarContent[_selectedIndex].isProfile ?? false,
        ),
      ),
      body: _listTabbarContent[_selectedIndex].screenContent,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.dashboard,
              color: _selectedIndex == 0 ? AppColors.blue : AppColors.darkGray,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _selectedIndex == 1 ? AppColors.blue : AppColors.darkGray,
            ),
            label: 'Search',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false, // Hide the selected label
        showUnselectedLabels: false, // Hide the unselected label
      ),
      floatingActionButton:
          _listTabbarContent[_selectedIndex].showFloatingButton != null &&
                  _listTabbarContent[_selectedIndex].showFloatingButton == true
              ? FloatingActionButton(
                  elevation: 0,
                  shape: const CircleBorder(),
                  backgroundColor: AppColors.blue,
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.detailContactScreen);
                  },
                  child: const Icon(Icons.add),
                )
              : null,
    );
  }
}
