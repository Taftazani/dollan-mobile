import 'package:dollan/utilities/helper.dart';
import 'package:flutter/material.dart';

class DetailRoute extends StatefulWidget {
  @override
  _DetailRouteState createState() => _DetailRouteState();
}

class _DetailRouteState extends State<DetailRoute> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(Helper().dummyText),
      ),
    );
  }
}