import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

class DefinedColorAdapter extends TypeAdapter<Color> {
  @override
  final typeId = 1;

  @override
  Color read(BinaryReader reader) {
    return Color(reader.readUint32());
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.writeUint32(obj.value);
  }
}
