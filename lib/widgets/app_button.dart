import 'package:flutter/material.dart';
import 'package:tv_streaming/constants.dart';

class AppButton extends StatelessWidget {
  final String label;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const AppButton(
      {Key key, this.label, this.width, this.height = 50, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
      ),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          onTap: onPressed != null ? onPressed : () {},
          child: Center(
            child: Text(
              this.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
