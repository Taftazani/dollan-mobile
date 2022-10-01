import 'dart:convert';

import 'package:dollan/utilities/apis.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class TosPage extends StatefulWidget {
  @override
  _TosPageState createState() => _TosPageState();
}

class _TosPageState extends State<TosPage> {
  String content;
  bool busy;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    WidgetsBinding.instance.addPostFrameCallback((_)=>init());
  }

  init() async {
    setState(() {
      busy = true;
    });
    http.Response res = await Services().getTos();

    setState(() {
      busy = false;
    });

    var body = json.decode(res.body);
    if (body['success'] == 'true') {
      print('ok');
      setState(() {
        content = body['data']['content'];
        print('content: $content');
      });
    } else {
      print('not ok');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
//        appBar: AppBar(
//          backgroundColor: Colors.transparent,
//          elevation: 0,
//          automaticallyImplyLeading: false,
//        ),
        body: SafeArea(child: bodyWidget(),),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top:120.0),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Image.asset('assets/icons/new/cancel.png', scale: 4,),
          onPressed: ()=>Navigator.of(context).pop(),
        ),
      ),
    );
  }

  Widget bodyWidget() {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      onPageFinished: (s) {
        print('onPageFinished: $s');
      },
      initialUrl: 'http://dollan.id/kebijakan-privasi',
    );
  }
}
