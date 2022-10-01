import 'package:dollan/templates/list_item.dart';
import 'package:flutter/material.dart';

class Section1 extends StatefulWidget {
  Section1({Key key, this.title}) : super(key:key);

  final String title;

  @override
  _Section1State createState() => _Section1State();
}

class _Section1State extends State<Section1> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '${widget.title}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 450,
            child: IgnorePointer(
              child: GridView.count(
                childAspectRatio: 0.75,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                crossAxisCount: 2,
                children: List.generate(4, (_index) {
                  return Container(
                    color: Colors.white,
                    child: ListItem(_index, null),
                  );
                }),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text(
                  'Lainnya',
                  style: TextStyle(
                      color: Color(0xffffcc00),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {},
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).primaryColor,
              ),
            ],
          )
        ],
      ),
    );;
  }
}