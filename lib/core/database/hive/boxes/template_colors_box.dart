import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TemplateColorsBox {
  static Box boxInstance = Hive.box("TemplateColorsBox");
  static const int _cacheLimit = 100;

  static void writeColors(num id, List<Color> colorsToWrite) {
    if (boxInstance.length > _cacheLimit) {
      _clearOldestItem();
    }
    boxInstance.put(id, colorsToWrite);
  }

  static List<Color>? readListOfColors(num id) {
    var result = boxInstance.get(id)?.cast<Color>();
    return result;
  }
}

void _clearOldestItem() {
  final oldestKey = TemplateColorsBox.boxInstance.keys.first;
  TemplateColorsBox.boxInstance.delete(oldestKey);
}
