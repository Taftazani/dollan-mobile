import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/home/rekomendasi_model.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ListItemDetail extends StatefulWidget {
  ListItemDetail(this.index, this.item, this.size);

  final int index;
  final RekomendasiItem item;
  final Size size;

  @override
  _ListItemDetailState createState() => _ListItemDetailState();
}

class _ListItemDetailState extends State<ListItemDetail> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

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
                  widget.item == null ? Container() :

                  CachedNetworkImage(
                imageUrl: '${widget.item.image}',
                placeholder: (context, url) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),),
                  ),
                ),
//                height: 100,
                  width: double.infinity,
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
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: widget.size.width*0.03),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  Text(widget.item.kabupaten==null?'':
                    '${widget.item.kabupaten}',
                    style: TextStyle(fontSize: widget.size.width*0.02),
                  ),
                  Text(widget.item.kabupaten==null?'':
                    '${widget.item.propinsi}',
                    style: TextStyle(fontSize: widget.size.width*0.02),
                  ),
                  widget.item.contentType == "poi" || widget.item.price == null ? Container() : Text(
                    Helper().setCurrencyFormat(int.parse(widget.item.price)) ,
                    style: TextStyle(fontSize: widget.size.width*0.03, color: Colors.red),
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
