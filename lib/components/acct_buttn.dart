import 'package:expense_manager/widgets/scale_helper.dart';
import 'package:expense_manager/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class acct_btn extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final bool isHighlighted;
  final String label;

  const acct_btn({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.isHighlighted,
  });

  @override
  State<acct_btn> createState() => _acct_btnState();
}

class _acct_btnState extends State<acct_btn> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.8,
      height: MediaQuery.of(context).size.height / 5,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: widget.isHighlighted ? Colors.white : Colors.black,
          backgroundColor: const Color.fromARGB(255, 11, 12, 17),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side:
              widget.isHighlighted
                  ? const BorderSide(
                    width: 1.3,
                    color: Color.fromARGB(255, 109, 108, 108),
                  )
                  : null,
        ),
        onPressed: widget.onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color:
                  widget.isHighlighted
                      ? Color.fromARGB(255, 109, 108, 108)
                      : Colors.black,
            ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 17,
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
