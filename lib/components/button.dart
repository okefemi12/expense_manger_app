import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function()? onTap;
  final String text;
  Button({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(35),
      radius: 60,
      onTap: onTap,
      highlightColor: Colors.grey[400],
      splashColor: const Color.fromARGB(255, 44, 120, 235),
      child: Container(
        width: MediaQuery.of(context).size.width / 0.1,
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
          right: 12,
          left: 12,
        ),
        margin: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 41, 110, 236),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}
