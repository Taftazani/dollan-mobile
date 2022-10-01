import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/home/articles_model.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ListItemRowDesc extends StatefulWidget {
  ListItemRowDesc(this.index, this.item);

  final int index;
  final ArticleItem item;

  @override
  _ListItemRowDescState createState() => _ListItemRowDescState();
}

class _ListItemRowDescState extends State<ListItemRowDesc> {
  

  @override
  Widget build(BuildContext context) {
    var rand = Random().nextInt(5);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: 
      Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: 
            
            // Image.asset(
            //   'assets/images/${widget.index + 1}.jpg',
            //   fit: BoxFit.cover,
            //   height: 80,
            //   width: 100,
            // ),
            
            CachedNetworkImage(
              imageUrl: '${widget.item.image}',
              placeholder: (context, url) => Center(
                    child:   Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),),
                    ),
                  ),
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(child: Text('${widget.item.title}', textAlign: TextAlign.left, maxLines: 4,))
        ],
      ),
    );
  }
}
