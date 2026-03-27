import 'package:expense_manager/widgets/scale_helper.dart';
import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle bigboldText() {
    return TextStyle(
      fontSize: SizeConfig.scaledFont(32),
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  static TextStyle mediumboldText() {
    return TextStyle(
      fontSize: SizeConfig.scaledFont(22),
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  static TextStyle smallboldtext() {
    return TextStyle(
      fontSize: SizeConfig.scaledFont(14),
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  static TextStyle normalText() {
    return TextStyle(
      fontSize: SizeConfig.scaledFont(18),
      fontWeight: FontWeight.w400,
      color: Colors.white,
    );
  }

  static TextStyle bignormalText() {
    return TextStyle(
      fontSize: SizeConfig.scaledFont(22),
      fontWeight: FontWeight.w400,
      color: Colors.white,
    );
  }

  static TextStyle dashText() {
    return TextStyle(
      fontSize: SizeConfig.scaledFont(3),
      fontWeight: FontWeight.w500,
      color: Color.fromARGB(255, 109, 108, 108),
    );
  }

  static TextStyle lighttext() {
    return TextStyle(
      fontSize: SizeConfig.scaledFont(20),
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle semibold8TextFieldStyle() {
    return TextStyle(
      fontSize: SizeConfig.scaledFont(16),
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
  }

  static TextStyle semibold7TextFieldStyle() {
    return TextStyle(
      fontSize: SizeConfig.scaledFont(18),
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
  }

  static TextStyle semibold9TextFieldStyle() {
    return TextStyle(
      fontSize: SizeConfig.scaledFont(22),
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );
  }

  static TextStyle kindaboldTextFieldStyle() {
    return TextStyle(
      fontSize: SizeConfig.scaledFont(15),
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle orangeTextFieldStyle() {
    return TextStyle(
      color: Colors.deepOrange,
      fontSize: SizeConfig.scaledFont(20),
      fontWeight: FontWeight.bold,
    );
  }
}
