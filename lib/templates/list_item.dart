import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/home/rekomendasi_model.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ListItem extends StatefulWidget {
  ListItem(this.index, this.item);

  final int index;
  final RekomendasiItem item;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    var rand = Random().nextInt(5);

    Widget createStars(int count) {
      return Row(
          children: List.generate(5, (index) {
        return index < count
            ? SizedBox(
                width: 12,
                child: Icon(
                  Icons.star,
                  size: 15,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : SizedBox(
                width: 12,
                child: Icon(
                  Icons.star,
                  size: 15,
                  color: Colors.grey[300],
                ),
              );
      }));
    }

    return Card(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              child:

                  // Image.asset(
                  //   'assets/images/${widget.index + 1}.jpg',
                  //   fit: BoxFit.cover,
                  //   // height: 100,
                  // ),

                  widget.item == null ? Container() :

                  CachedNetworkImage(
                imageUrl: '${widget.item.image}',
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex:1,
                      child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${widget.item.title}',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Text(
                  //   'Lorem ipsum dolor sit amet',
                  //   style: Theme.of(context).textTheme.caption.apply(fontWeightDelta: 2),
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Text(
                  //   'IDR ${widget.item}',
                  //   style: Theme.of(context).textTheme.caption,
                  // ),
                  // SizedBox(
                  //   height: 3,
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     createStars(3),
                  //     SizedBox(width: 5,),
                  //     Text('53 Users', style: TextStyle(fontSize: 10),)
                  //   ],
                  // )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
