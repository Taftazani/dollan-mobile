import 'dart:convert';
import 'dart:developer';

import 'package:dollan/utilities/apis.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class KetentuanPage extends StatefulWidget {
  @override
  _KetentuanPageState createState() => _KetentuanPageState();
}

class _KetentuanPageState extends State<KetentuanPage> {
  String content;
  bool busy;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  init() async {
    setState(() {
      busy = true;
    });

    http.Response res = await Services().getKetentuan();

    setState(() {
      busy = false;
    });

    var body = json.decode(res.body);
    if(body['success']=='true'){
      print('ok');
      setState(() {
        content = body['data']['content'];
        print('content: $content');
      });
    }else{
      print('not ok');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(child: bodyWidget(),),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top:120.0),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Image.asset('assets/icons/new/cancel.png', scale: 2.8,),
          onPressed: ()=>Navigator.of(context).pop(),
        ),
      ),
        );
  }

  Widget bodyWidget() {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      onPageFinished: (s){
        print('onPageFinished: $s');
      },
      initialUrl: 'http://dollan.id/applicable-provision',
    );
//    return Container(child: Padding(
//      padding: const EdgeInsets.all(8.0),
//      child: Html(data:content),
//    ));
  }
}
