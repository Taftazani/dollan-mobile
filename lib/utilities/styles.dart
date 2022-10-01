import 'package:flutter/material.dart';

class Styles {
  static final Styles _styles = Styles._internal();

  Styles._internal();

  factory Styles() {
    return _styles;
  }

  TextStyle colorBlack() {
    return TextStyle(color: Colors.black);
  }

  TextStyle mainTitle() {
    return TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
  }

  TextStyle subTitle() {
    return TextStyle(
        color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold);
  }

  TextStyle button() {
    return TextStyle(color: Colors.black, fontSize: 12);
  }

  RaisedButton defaultButton(BuildContext context, String title, Function func) {
    return RaisedButton(
      elevation: 0,
      color: Theme.of(context).primaryColor,
      shape: StadiumBorder(),
      onPressed: () {
        func();
      },
      child: Text('$title'),
    );
  }
}
