import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VoucherViewer extends StatefulWidget {
  VoucherViewer({this.url});

  final String url;

  @override
  _VoucherViewerState createState() => _VoucherViewerState();
}

class _VoucherViewerState extends State<VoucherViewer> {
  WebViewController ctrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Voucher'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  _back();
                }),
            IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  _cancel();
                }),
          ],
        ),
        body: bodyWidget());
    ;
  }

  Widget bodyWidget() {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      onPageFinished: (s){
        print('onPageFinished: $s');
      },
      onWebViewCreated: (c) {
        ctrl = c;
      },
      initialUrl: 'http://baidu.com',
    );
  }

  void _back() {
    ctrl.goBack();
  }

  void _cancel() async {
    Navigator.of(context).pop();
    /*
    bool keluar = false;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content:
                Text('Anda akan membatalkan pembayaran. Lanjutkan keluar?'),
            actions: <Widget>[
              FlatButton(
                child: Text('BATAL'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                  child: Text('YA'),
                  onPressed: () {
                    keluar = true;
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
    if(keluar){
      Navigator.of(context).pop();
    }*/
  }
}
