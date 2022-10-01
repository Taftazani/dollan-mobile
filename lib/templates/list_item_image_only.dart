import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ListItemImageOnly extends StatefulWidget {
  ListItemImageOnly(this.index);

  final int index;

  @override
  _ListItemImageOnlyState createState() => _ListItemImageOnlyState();
}

class _ListItemImageOnlyState extends State<ListItemImageOnly> {
  @override
  Widget build(BuildContext context) {
    var rand = Random().nextInt(5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(0),
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
      ],
    );
  }
}
