import 'package:flutter/material.dart';

class AdvTextFieldClear extends StatelessWidget {
  final VoidCallback callback;

  AdvTextFieldClear(this.callback);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        margin: EdgeInsets.all(6.0),
        padding: EdgeInsets.all(2.0),
        child: Icon(Icons.close, size: 14.0, color: Colors.white),
        decoration: BoxDecoration(
            color: Color.lerp(Colors.black, Colors.grey, 0.5),
            borderRadius: BorderRadius.circular(100.0)),
      ),
    );
  }
}
