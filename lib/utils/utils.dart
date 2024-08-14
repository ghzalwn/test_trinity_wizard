import 'package:test_trinity_wizard/models/user.dart';

class Util {
  Map<String, List<User>> groupByAlphabet(List<User> items) {
    final Map<String, List<User>> groupedItems = {};

    for (var item in items) {
      final String firstLetter = item.firstName!.substring(0, 1).toUpperCase();
      if (groupedItems[firstLetter] == null) {
        groupedItems[firstLetter] = [];
      }
      groupedItems[firstLetter]!.add(item);
    }

    return groupedItems;
  }
}
