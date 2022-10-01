//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:dollan/pages/favorit.dart';
//import 'package:dollan/templates/list_item_row.dart';
//import 'package:dollan/utilities/helper.dart';
//import 'package:flutter/material.dart';
//import 'dart:math';
//
//class ListItemRowDelete extends StatefulWidget {
//  ListItemRowDelete(this.item);
//
//  final FavoriteItem item;
//
//  @override
//  _ListItemRowDeleteState createState() => _ListItemRowDeleteState();
//}
//
//class _ListItemRowDeleteState extends State<ListItemRowDelete> {
//  Widget createStars(int count) {
//    return Row(
//        children: List.generate(5, (index) {
//      return index < count
//          ? SizedBox(
//              width: 12,
//              child: Icon(
//                Icons.star,
//                size: 15,
//                color: Theme.of(context).primaryColor,
//              ),
//            )
//          : SizedBox(
//              width: 12,
//              child: Icon(
//                Icons.star,
//                size: 15,
//                color: Colors.grey[300],
//              ),
//            );
//    }));
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    var rand = Random().nextInt(5);
//    return Padding(
//      padding: const EdgeInsets.all(10.0),
//      child: Row(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          ClipRRect(
//            borderRadius: BorderRadius.circular(10),
//            child: Image.asset(
//              '${widget.item.img}.jpg',
//              fit: BoxFit.cover,
//              height: 85,
//              width: 100,
//            ),
//          ),
//          SizedBox(
//            width: 10,
//          ),
//          // Flexible(
//          //             child: Text(
//          //           Helper().dummyTextShort, textAlign: TextAlign.left, maxLines: 4,
//          //           style: Theme.of(context).textTheme.body1,
//          //         ),
//          // ),
//
//          Expanded(
//            child: Column(
//              mainAxisSize: MainAxisSize.min,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                // Text(
//                //   'Arcanopolis',
//                //   style: Theme.of(context).textTheme.caption,
//                // ),
//                // SizedBox(
//                //   height: 3,
//                // ),
//                // Container(
//                //   width: MediaQuery.of(context).size.width * 0.55,
//                //   child: Text(
//                //     Helper().dummyTextShort,
//                //     textAlign: TextAlign.left,
//                //     maxLines: 2,
//                //     style: Theme.of(context).textTheme.body1,
//                //   ),
//                // ),
//                SizedBox(
//                  height: 3,
//                ),
//                Text('${widget.item.title}'),
//                SizedBox(
//                  height: 3,
//                ),
//                Text('${widget.item.subTitle}'),
//                SizedBox(
//                  height: 3,
//                ),
//                Text('${widget.item.location}'),
//                SizedBox(
//                  height: 10,
//                ),
//                Text('${widget.item.price}')
//                // Row(
//                //   children: <Widget>[
//                //     createStars(3),
//                //     SizedBox(
//                //       width: 5,
//                //     ),
//                //     Text(
//                //       '53 Users',
//                //       style: TextStyle(fontSize: 10),
//                //     )
//                //   ],
//                // )
//              ],
//            ),
//          ),
//          Align(
//              alignment: Alignment.topCenter,
//              child: IconButton(
//                padding: EdgeInsets.all(0),
//                icon: Icon(
//                  Icons.delete,
//                  color: Colors.grey,
//                ),
//                onPressed: () {},
//              ))
//        ],
//      ),
//    );
//  }
//}
