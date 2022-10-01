import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/detail/wisatasejenis_response.dart';
import 'package:dollan/models/home/rekomendasi_model.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ListItemAccomodation extends StatefulWidget {
  ListItemAccomodation(this.index, this.item, this.size);

  final int index;
  final WisataSejenisItem item;
  final Size size;

  @override
  _ListItemAccomodationState createState() => _ListItemAccomodationState();
}

class _ListItemAccomodationState extends State<ListItemAccomodation> {
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
      child: widget.item == null
          ? Container()
          : Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    child:

                        // Image.asset(
                        //   'assets/images/${widget.index + 1}.jpg',
                        //   fit: BoxFit.cover,
                        //   // height: 100,
                        // ),
                        widget.item.images == null || widget.item.images == ''
                            ? Helper().noImage()
                            : CachedNetworkImage(
                                imageUrl: '${widget.item.images}',
                                placeholder: (context, url) => Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),),
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
                      children: <Widget>[
                        Text(
                          '${widget.item.title}',
                          maxLines: 2,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text( widget.item.kabupaten==null?'':
                          '${widget.item.kabupaten}',
                          style: TextStyle(fontSize: widget.size.width*0.02),
                        ),
                        Text(widget.item.propinsi==null?'':
                          '${widget.item.propinsi}',
                          style: TextStyle(fontSize: widget.size.width*0.02),
                        ),
                        widget.item.contentType=='poi'?Container():
                        Text(
                          '${Helper().setCurrencyFormat(int.parse(widget.item.price))}',
                          style: Theme.of(context).textTheme.caption.apply(color: Colors.red),
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
