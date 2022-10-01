import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/list_favorit_response.dart';
import 'package:dollan/pages/favorit.dart';
import 'package:dollan/templates/list_item_row.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ListItemFavorit extends StatefulWidget {
  ListItemFavorit(this.item, this.func);

  final FavoritItem item;
  final Function(String) func;

  @override
  _ListItemFavoritState createState() => _ListItemFavoritState();
}

class _ListItemFavoritState extends State<ListItemFavorit> {


  _delete()async{
    widget.func(widget.item.id);
//    var userid = Helper().getUserPrefs('userid');
//    if(userid==null) return;
//    await Services().deleteFavorit({'iduser':userid,'postid':widget.item.id}).then((res){
//      if(res.statusCode==200){
//
//      }
//    });
  }


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
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child:


//            Image.network(
//              '${widget.item.images}',
//              fit: BoxFit.cover,
//              height: 85,
//              width: 100,
//            ),

            CachedNetworkImage(
              imageUrl: '${widget.item.images}',
              placeholder: (context, url) => Center(
                child: Container(
                  width: 100,
                    height: 85,
                    child: Helper().noImage()),
              ),
              fit: BoxFit.cover,
              width: 100,
              height: 85,
            ),

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

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Text(
                //   'Arcanopolis',
                //   style: Theme.of(context).textTheme.caption,
                // ),
                // SizedBox(
                //   height: 3,
                // ),
                // Container(
                //   width: MediaQuery.of(context).size.width * 0.55,
                //   child: Text(
                //     Helper().dummyTextShort,
                //     textAlign: TextAlign.left,
                //     maxLines: 2,
                //     style: Theme.of(context).textTheme.body1,
                //   ),
                // ),
                SizedBox(
                  height: 3,
                ),
                Text('${widget.item.title}', maxLines: 3, overflow: TextOverflow.ellipsis,),
//                SizedBox(
//                  height: 3,
//                ),
//                Text('${widget.item.description}'),
//                SizedBox(
//                  height: 3,
//                ),
//                Text('${widget.item.location}'),
                SizedBox(
                  height: 10,
                ),
//                Text('${widget.item.price}')
                // Row(
                //   children: <Widget>[
                //     createStars(3),
                //     SizedBox(
                //       width: 5,
                //     ),
                //     Text(
                //       '53 Users',
                //       style: TextStyle(fontSize: 10),
                //     )
                //   ],
                // )
              ],
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                onPressed: () {
                  _delete();
                },
              ))
        ],
      ),
    );
  }
}
