import 'package:flutter/material.dart';

class Gaps {
  Gaps._();

  /// Returns a horizontal gap of specified [width].
  static SizedBox horizontalGapOf(double width) {
    return SizedBox(width: width);
  }

  /// Returns a vertical gap of specified [height].
  static SizedBox verticalGapOf(double height) {
    return SizedBox(height: height);
  }

  /// Returns a gap with both specified [height] and [width].
  static SizedBox bothGapOf(double height, double width) {
    return SizedBox(height: height, width: width);
  }
}
