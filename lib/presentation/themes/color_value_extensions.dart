import 'package:flutter/material.dart';
import 'package:time_walker/domain/value_objects/color_value.dart';

extension ColorValueExtensions on ColorValue {
  Color toColor() => Color(value);
}
