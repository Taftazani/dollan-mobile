import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ListItemColSimple extends StatefulWidget {
  ListItemColSimple({this.index, this.title, this.center});

  final int index;
  final String title;
  final bool center;

  @override
  _ListItemColSimpleState createState() => _ListItemColSimpleState();
}

class _ListItemColSimpleState extends State<ListItemColSimple> {
  @override
  Widget build(BuildContext context) {
    var rand = Random().nextInt(5);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
    ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        'assets/images/${widget.index + 1}.jpg',
        fit: BoxFit.cover,
        height: 100,
      ),
      // CachedNetworkImage(
      //   imageUrl: 'https://picsum.photos/id/${widget.path}/100/70',
      //   placeholder: (context, url) => Center(
      //         child: CircularProgressIndicator(),
      //       ),
      //   height: 100,
      //   fit: BoxFit.fill,
      // ),
    ),
    SizedBox(
      height: 3,
    ),
    widget.center ? Center(
      child: Text(
        '${widget.title}',
        style: Theme.of(context).textTheme.body1,
      ),
    ) : Text(
        '${widget.title}',
        style: Theme.of(context).textTheme.body1,
      ),
    
        ],
      );
  }
}
