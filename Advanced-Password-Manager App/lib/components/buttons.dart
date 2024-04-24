import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backGroundColor;
  final Color borderColor;
  final VoidCallback callBack;
  const MyElevatedButton(
      {super.key,
      required this.text,
      required this.textColor,
      required this.backGroundColor,
      required this.borderColor,
      required this.callBack});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callBack,
      style: ElevatedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          backgroundColor: backGroundColor),
      child: Text(text,
          style: TextStyle(fontWeight: FontWeight.w700, color: textColor)),
    );
  }
}

class MyOutlinedButton extends StatelessWidget {
  final Color textColor;
  final String text;
  final VoidCallback? callback;
  const MyOutlinedButton(
      {super.key,
      required this.text,
      required this.textColor,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: callback,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final VoidCallback? callback;
  final String text;
  final Color borderColor;
  const MyButton(
      {super.key,
      this.callback,
      required this.text,
      required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width * .9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: borderColor),
      child: TextButton(
        onPressed: callback,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
