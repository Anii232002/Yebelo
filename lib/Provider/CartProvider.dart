import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  Map<int, int> itemCountMap = {};

  void updateItemCount(int id, int count) {
    itemCountMap[id] = count;
    notifyListeners();
  }

  Map<int, int> getItemCountMap() {
    return itemCountMap;
  }
}
