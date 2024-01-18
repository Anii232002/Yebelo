import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:yebelo/module/Categories.dart';
import 'package:yebelo/module/testIem.dart';

class jsonParsing {
  List<Categories> userList(List<TestItem> list) {
    List<Categories> ans = [];
    for (int i = 0; i < list.length; i++) {
      Categories c = new Categories(name: list[i].category);
      if (!ans.contains(c)) {
        ans.add(c);
      }
    }
    return ans;
  }

  List<TestItem> currList(List<TestItem> list, List<Categories> choices) {
    return list
        .where(
            (item) => choices.any((category) => category.name == item.category))
        .toList();
  }

  List<TestItem> parsePhotos(String jsonString) {
    final List<dynamic> responseBody = jsonDecode(jsonString);
    return responseBody
        .map<TestItem>((json) => TestItem.fromJson(json))
        .toList();
  }
}
