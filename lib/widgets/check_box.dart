
import 'package:flutter/material.dart';

class ChecksBox extends StatefulWidget {
  const ChecksBox({Key? key}) : super(key: key);

  @override
  _ChecksBoxState createState() => _ChecksBoxState();
}

class _ChecksBoxState extends State<ChecksBox> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: (val) {
        setState(() {
          value = !value;
        });
      },
      activeColor: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    );
  }
}