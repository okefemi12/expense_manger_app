import 'package:expense_manager/widgets/scale_helper.dart';
import 'package:expense_manager/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Mytext extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  TextInputType type;
  final int maxlines;

  Mytext({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.type,
    required this.maxlines,
  });

  @override
  _MytextState createState() => _MytextState();
}

class _MytextState extends State<Mytext> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        style: GoogleFonts.inter(
          fontSize: SizeConfig.scaledFont(19),
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        maxLines: widget.maxlines,
        controller: widget.controller,
        obscureText: _obscureText,
        cursorColor: Colors.blueAccent,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Color.fromARGB(255, 11, 12, 17)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 11, 12, 17),
              style: BorderStyle.solid,
              width: 1.3,
            ),
          ),
          filled: true,
          fillColor: Color.fromARGB(255, 11, 12, 17),
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Color.fromARGB(255, 11, 12, 17)),
          ),
        ),
        keyboardType: widget.type,
      ),
    );
  }
}
