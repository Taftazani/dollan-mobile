import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/detail/kamusuka_response.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/utilities/apis.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ListItemKamuSuka extends StatefulWidget {
  ListItemKamuSuka({this.index, this.item});

  final int index;
  final KamuSukaItem item;

  @override
  _ListItemKamuSukaState createState() => _ListItemKamuSukaState();
}

class _ListItemKamuSukaState extends State<ListItemKamuSuka> {
  @override
  Widget build(BuildContext context) {
    var rand = Random().nextInt(5);

    return GestureDetector(
      onTap: (){
        print('kamusuka => ${widget.item.id}');
        Navigator.of(context).pushNamed('detail',
        arguments: RouteArguments(id: widget.item.id));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
      Container(
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child:
          widget.item.images == '' ?
              Helper().noImage() :

          Image.network(
            '${widget.item.images}',
            fit: BoxFit.cover,
            height: 100,
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
      ),
      SizedBox(
        height: 3,
      ),

      Center(
        child: Text(

          '${widget.item.title}',
          maxLines: 2,
          style: Theme.of(context).textTheme.caption,
        ),
      )

          ],
        ),
    );
  }
}
