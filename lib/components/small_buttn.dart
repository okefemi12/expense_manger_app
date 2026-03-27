import 'package:expense_manager/widgets/scale_helper.dart';
import 'package:expense_manager/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class Small_bttn extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;

  const Small_bttn({super.key, required this.label, required this.onPressed});

  @override
  State<Small_bttn> createState() => _Small_bttnState();
}

class _Small_bttnState extends State<Small_bttn> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: widget.onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Color.fromARGB(255, 109, 108, 108),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
