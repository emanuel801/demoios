import 'package:flutter/material.dart';

class OptionMenu {
  final String label;
  final int value;
  OptionMenu({this.label, this.value});
}

class PopupMenu extends StatelessWidget {
  final List<OptionMenu> options;
  final Function(int) onSelected;
  const PopupMenu({this.options, Key key, this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 23.0,
      width: 36.0,
      child: PopupMenuButton(
        padding: EdgeInsets.only(right: 20, top: 0, bottom: 5),
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onSelected: onSelected,
        itemBuilder: (context) => options.map((e) {
          return PopupMenuItem(
            value: e.value,
            child: Row(
              children: <Widget>[Text(e.label)],
            ),
          );
        }).toList(),
      ),
    );
  }
}
