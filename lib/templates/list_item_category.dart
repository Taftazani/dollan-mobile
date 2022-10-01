import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/catmood/cat_mood_response.dart';
import 'package:dollan/models/home/rekomendasi_model.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ListItemCategory extends StatefulWidget {
  ListItemCategory(this.item, this.size);

  // final int index;
  final CatMoodItem item;
  final Size size;

  @override
  _ListItemCategoryState createState() => _ListItemCategoryState();
}

class _ListItemCategoryState extends State<ListItemCategory> {
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

                  //  Image.asset(
                  //    'assets/images/${widget.index + 1}.jpg',
                  //    fit: BoxFit.cover,
                  //     height: 100,
                  //  ),

                  widget.item == null
                      ? Container()
                      : CachedNetworkImage(
                          imageUrl: '${widget.item.images}',
                          placeholder: (context, url) => Center(
                            child: Center(
                              child: Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.grey[200],
                              ),
                            ),
                          ),
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Align(alignment: Alignment.centerLeft,
                                      child: Text(
                      widget.item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .apply(fontSizeDelta: 3, color: Color(0xff221f1f)),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(widget.item.kabupaten==null?'':
                  '${widget.item.kabupaten}',
                    style: TextStyle(fontSize: widget.size.width*0.02),
                  ),
                  Text(widget.item.kabupaten==null?'':
                  '${widget.item.propinsi}',
                    style: TextStyle(fontSize: widget.size.width*0.02),
                  ),
                  widget.item.contentType == 'poi'
                      ? Container()
                      : Text(
                          widget.item.price==null?'':Helper()
                              .setCurrencyFormat(int.parse(widget.item.price)),
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .apply(fontWeightDelta: 2, color: Colors.red),
                        ),

                  SizedBox(
                    height: 5,
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
