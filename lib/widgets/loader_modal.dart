import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoaderModal extends StatelessWidget {
  const LoaderModal({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.white54,
        child: CupertinoActivityIndicator(
          radius: 20,
        ),
      ),
    );
  }
}
