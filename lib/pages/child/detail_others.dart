import 'package:dollan/utilities/helper.dart';
import 'package:flutter/material.dart';

class DetailOthers extends StatefulWidget {
  @override
  _DetailOthersState createState() => _DetailOthersState();
}

class _DetailOthersState extends State<DetailOthers> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Container(
        height: 400,
        child: IgnorePointer(
          ignoring: false,
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, pos) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Nama Tempat',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Kategori Tempat',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${Helper().dummyText}',
                      style: TextStyle(fontSize: 14),
                      maxLines: 3,
                    ),
                    SizedBox(height: 18,)
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
