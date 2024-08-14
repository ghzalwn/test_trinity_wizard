import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:test_trinity_wizard/models/user.dart';
import 'package:test_trinity_wizard/service/api_service.dart';
import 'package:test_trinity_wizard/utils/utils.dart';

class AppController extends ChangeNotifier {
  final ApiService _apiService;
  AppController(this._apiService);

  List<User>? _listUser;
  User? _user;
  User? _selectedUser;
  String? _errorMessage;
  bool _isLoading = false;
  List<String>? _headers;
  Map<String, List<User>>? _groupedData;

  List<User>? get listUser => _listUser;
  User? get user => _user;
  User? get selectedUser => _selectedUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  List<String>? get headers => _headers;
  Map<String, List<User>>? get groupedData => _groupedData;

  Future<void> loadAllUsers({String? keyword}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    log("keyword: $keyword");

    try {
      final pref = await SharedPreferences.getInstance();
      var dataListUser = pref.getString("listUser");

      List<User> users = [];
      if (dataListUser == null) {
        users = await _apiService.getAllContacts();
        List<dynamic> jsonList = users.map((user) => user.toJson()).toList();

        String jsonString = jsonEncode(jsonList);

        pref.setString("listUser", jsonString);
      } else {
        List<dynamic> jsonListDynamic = jsonDecode(dataListUser);
        users = jsonListDynamic
            .map((json) => User.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      if (keyword != null && keyword.isNotEmpty) {
        log("Filtering users with keyword: $keyword");

        users = users.where((user) {
          final userFirstName = user.firstName?.trim().toLowerCase() ?? '';
          final filterKeyword = keyword.trim().toLowerCase();

          log('Checking if userFirstName="$userFirstName" contains filterKeyword="$filterKeyword"');

          return userFirstName.contains(filterKeyword);
        }).toList();

        log("Number of users after filtering: ${users.length}");
      }

      if (dataListUser == null || dataListUser.isEmpty) {}

      var dataGrouping = Util().groupByAlphabet(users);

      _headers = [];
      _groupedData = {};
      _listUser = [];

      _groupedData = dataGrouping;
      _headers = dataGrouping.keys.toList()..sort();
      _listUser?.addAll(users);
    } catch (e) {
      log(e.toString());
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkLoginStatus() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final pref = await SharedPreferences.getInstance();
      var loginId = pref.getString("userId");
      log(loginId.toString());

      if (loginId != null && loginId.isNotEmpty) {
        final user = await _apiService.getUserById(loginId);
        if (user != null) {
          final pref = await SharedPreferences.getInstance();
          pref.setString("userId", user.id!);
          _user = user;
        } else {
          _errorMessage = 'User not found';
        }
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserById(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _apiService.getUserById(id);

      if (user != null) {
        final pref = await SharedPreferences.getInstance();
        pref.setString("userId", user.id!);
        _user = user;
      } else {
        _errorMessage = 'User not found';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedUser(User user) {
    _selectedUser = user;
    notifyListeners();
  }

  void clearSelectedUser() {
    _selectedUser = null;
  }

  Future<void> updateDataUser(String id, User newData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.updateData(id: id, newData: newData);
      _selectedUser = null;
      loadAllUsers();
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final pref = await SharedPreferences.getInstance();
      pref.remove("listUser");

      loadAllUsers();
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addDataUser(User newData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.updateData(newData: newData);
      loadAllUsers();
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeData(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var pref = await SharedPreferences.getInstance();
      var dataListUser = pref.getString("listUser");
      List<dynamic> jsonListDynamic = jsonDecode(dataListUser!);
      List<User> data = jsonListDynamic
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();

      if (id.isNotEmpty) {
        final index = data.indexWhere((item) => item.id == id);
        if (index != -1) {
          data.removeAt(index);
        }
      }

      List<Map<String, dynamic>> jsonList =
          data.map((user) => user.toJson()).toList();

      String jsonString = jsonEncode(jsonList);

      await pref.setString("listUser", jsonString);

      loadAllUsers();
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final pref = await SharedPreferences.getInstance();
      pref.clear();
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
