import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle boldTextStyle() {
    return TextStyle(
        color: Colors.black, fontSize: 28.0, fontWeight: FontWeight.bold);
  }

  static TextStyle LightTextStyle() {
    return TextStyle(
        color: Colors.black54, fontSize: 18.0, fontWeight: FontWeight.bold);
  }

  static TextStyle semiboldTextStyle() {
    return TextStyle(
        color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold);
  }

  static TextStyle seeAllTextStyle() {
    return TextStyle(
        color: Color(0xFFfd6f3e), fontSize: 18.0, fontWeight: FontWeight.w500);
  }
}
