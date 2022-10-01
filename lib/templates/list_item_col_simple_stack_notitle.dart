import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ListItemColSimpleStackNoTitle extends StatefulWidget {
  ListItemColSimpleStackNoTitle({this.index, this.title, this.image});

  final int index;
  final String title;
  final String image;
  // final bool center;

  @override
  _ListItemColSimpleStackNoTitleState createState() => _ListItemColSimpleStackNoTitleState();
}

class _ListItemColSimpleStackNoTitleState extends State<ListItemColSimpleStackNoTitle> {
  @override
  Widget build(BuildContext context) {
    var rand = Random().nextInt(5);

    return Stack(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: 
          
          // Image.network(
          //   // 'assets/images/${widget.index + 1}.jpg',
          //   '${widget.image}',
          //   fit: BoxFit.cover,
          //   height: 200,
          // ),


          CachedNetworkImage(
            imageUrl: '${widget.image}',
            placeholder: (context, url) => Center(
                  child: Helper().noImage()
                  
                ),
            height: 200,
            fit: BoxFit.cover,
          ),


        ),
        // Positioned(
        //     bottom: 0,
        //     left: 0,
        //     right: 0,
        //     child: Opacity(
        //       opacity: 0.7,
        //       child: Container(
        //         height: 30,
        //         color: Colors.white,
        //       ),
        //       // Row(children: <Widget>[
        //       //   Expanded(flex: 1, child: Container(),),
        //       //   Container(height: 20, color: Colors.white,)
        //       // ],)
        //     )),
        // Positioned(
        //   bottom: 10,
        //   left: 0,
        //   right: 0,
        //   child: Center(child: Text('${widget.title}', style: TextStyle(fontSize: 12),)),
        // )
      ],
    );
  }
}
