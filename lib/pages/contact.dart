import 'dart:convert';
import 'dart:developer';

import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  var data;
  bool busy = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  init() async {
    setState(() {
      busy = true;
    });

    http.Response res = await Services().getContact();

    setState(() {
      busy = false;
    });

    var body = json.decode(res.body);
    if (body['success'] == 'true') {
      print('ok');
      setState(() {
        data = body['data'];
      });
      print(data[0]['phone']);
    } else {
      print('not ok');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Contact Us'),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.close),
          //   onPressed: () => Navigator.of(context).pop(),
          // )
          GestureDetector(
            child: Image.asset('assets/icons/new/cancel.png', scale: 2.5,),
            onTap: (){
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: SafeArea(
        child: busy ? Helper().busyIndicator(context, size) : bodyWidget(),
      ),
    );
  }

  Widget bodyWidget() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.phone),
            title: Align(
                alignment: Alignment.centerLeft,
                child: FlatButton(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      data[0]['phone'],
                      style: Theme.of(context).textTheme.title.apply(color: Colors.blue),
                    ),
                    onPressed: () => launch("tel:${data[0]['phone']}"))),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Align(
                alignment: Alignment.centerLeft,
                child: FlatButton(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      data[0]['email'],
                      style: Theme.of(context).textTheme.title.apply(color: Colors.blue),
                    ),
                    onPressed: () => launch("mailto:${data[0]['email']}"))),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(
              data[0]['address'],
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ],
      ),
    );
  }
}
