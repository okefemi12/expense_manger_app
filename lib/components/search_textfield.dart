import 'package:expense_manager/widgets/scale_helper.dart';
import 'package:expense_manager/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Search extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const Search({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText; // Set initial state of obscureText
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
        controller: widget.controller,
        obscureText: _obscureText,
        cursorColor: Colors.blueAccent,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(
              color: Colors.blueAccent,
              style: BorderStyle.solid,
              width: 1.3,
            ),
          ),
          filled: true,
          fillColor: Color.fromARGB(255, 11, 12, 17),
          hintText: widget.hintText,
        ),
      ),
    );
  }
}
