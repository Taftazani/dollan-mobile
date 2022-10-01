import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ListItemRow extends StatefulWidget {
  ListItemRow(this.path);

  final path;

  @override
  _ListItemRowState createState() => _ListItemRowState();
}

class _ListItemRowState extends State<ListItemRow> {
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

  @override
  Widget build(BuildContext context) {
    var rand = Random().nextInt(5);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/${rand + 1}.jpg',
              fit: BoxFit.cover,
              height: 80,
              width: 100,
            ),
            // CachedNetworkImage(
            //   imageUrl: 'https://picsum.photos/id/${widget.path}/100/70',
            //   placeholder: (context, url) => Center(
            //         child: CircularProgressIndicator(),
            //       ),
            //   height: 80,
            //   fit: BoxFit.fill,
            // ),
          ),
          SizedBox(
            width: 10,
          ),
          // Flexible(
          //             child: Text(
          //           Helper().dummyTextShort, textAlign: TextAlign.left, maxLines: 4,
          //           style: Theme.of(context).textTheme.body1,
          //         ),
          // ),

          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Arcanopolis',
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.55,
                child: Text(
                  Helper().dummyTextShort,
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                children: <Widget>[
                  createStars(3),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '53 Users',
                    style: TextStyle(fontSize: 10),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
