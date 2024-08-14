import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_trinity_wizard/models/user.dart';

class ApiService {
  Future<List<User>> getAllContacts() async {
    try {
      // Load the JSON file from the assets
      final String response =
          await rootBundle.loadString('assets/data/data.json');
      final List<User> data = parseCustomers(response);
      return data;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<User?> getUserById(String id) async {
    try {
      final users = await getAllContacts();
      return users.firstWhere((user) => user.id == id,
          orElse: () => null as User);
    } catch (e) {
      throw Exception('Failed to find customer: $e');
    }
  }

  Future<void> updateData({String? id, required User newData}) async {
    var pref = await SharedPreferences.getInstance();
    var dataListUser = pref.getString("listUser");
    List<dynamic> jsonListDynamic = jsonDecode(dataListUser!);
    List<User> data = jsonListDynamic
        .map((json) => User.fromJson(json as Map<String, dynamic>))
        .toList();

    // Update or add the entry
    if (id != null && id.isNotEmpty) {
      final index = data.indexWhere((item) => item.id == id);
      if (index != -1) {
        data[index] = newData;
      } else {
        data.add(newData);
      }
    } else {
      data.add(newData);
    }

    List<Map<String, dynamic>> jsonList =
        data.map((user) => user.toJson()).toList();

    String jsonString = jsonEncode(jsonList);

    await pref.setString("listUser", jsonString);
  }
}
