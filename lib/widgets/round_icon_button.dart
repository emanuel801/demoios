import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const RoundIconButton({this.icon, this.onTap, key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        focusColor: Colors.black87,
        customBorder: new CircleBorder(),
        onTap: onTap,
        splashColor: Colors.grey,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black54,
          ),
          padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
          child: new Icon(
            this.icon,
            size: 23,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
