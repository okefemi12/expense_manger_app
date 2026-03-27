import 'package:expense_manager/widgets/scale_helper.dart';
import 'package:expense_manager/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class BudgetBttn extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final bool isHighlighted;

  const BudgetBttn({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.isHighlighted,
  });

  @override
  State<BudgetBttn> createState() => _BudgetBttnState();
}

class _BudgetBttnState extends State<BudgetBttn> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      height: MediaQuery.of(context).size.height / 3,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: widget.isHighlighted ? Colors.white : Colors.black,
          backgroundColor: const Color.fromARGB(255, 11, 12, 17),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
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
        child: Icon(
          size: 25,
          widget.icon,
          color:
              widget.isHighlighted
                  ? Color.fromARGB(255, 109, 108, 108)
                  : Colors.black,
        ),
      ),
    );
  }
}
