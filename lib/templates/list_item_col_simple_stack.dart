import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ListItemColSimpleStack extends StatefulWidget {
  ListItemColSimpleStack({this.index, this.title, this.center});

  final int index;
  final String title;
  final bool center;

  @override
  _ListItemColSimpleStackState createState() => _ListItemColSimpleStackState();
}

class _ListItemColSimpleStackState extends State<ListItemColSimpleStack> {
  @override
  Widget build(BuildContext context) {
    var rand = Random().nextInt(5);

    return Stack(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/images/${widget.index + 1}.jpg',
            fit: BoxFit.cover,
            height: 200,
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
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.7,
              child: Container(
                height: 30,
                color: Colors.white,
              ),
              // Row(children: <Widget>[
              //   Expanded(flex: 1, child: Container(),),
              //   Container(height: 20, color: Colors.white,)
              // ],)
            )),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Center(child: Text('${widget.title}', style: TextStyle(fontSize: 12),)),
        )
      ],
    );
  }
}
