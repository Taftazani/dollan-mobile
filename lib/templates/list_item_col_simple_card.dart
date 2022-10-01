import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ListItemColSimpleCard extends StatefulWidget {
  ListItemColSimpleCard({this.index, this.width, this.height});

  final int index;
  final double width;
  final double height;

  @override
  _ListItemColSimpleCardState createState() => _ListItemColSimpleCardState();
}

class _ListItemColSimpleCardState extends State<ListItemColSimpleCard> {
  @override
  Widget build(BuildContext context) {
    var rand = Random().nextInt(5);

    return Container(
      width: widget.width,
      child: Card(
        child: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              child: Image.asset(
                'assets/images/${widget.index + 1}.jpg',
                fit: BoxFit.cover,
                height: widget.height,
                
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    Helper().dummyText, maxLines: 2,
                    style: Theme.of(context).textTheme.body1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
