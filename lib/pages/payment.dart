import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({this.url});

  final String url;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
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
          title: Text('Pembayaran', style: Theme.of(context).textTheme.title.apply(fontWeightDelta: 4),),
          automaticallyImplyLeading: false,
          actions: <Widget>[
//            IconButton(
//                icon: Icon(Icons.arrow_back),
//                onPressed: () {
//                  _back();
//                }),
//            IconButton(
//                icon: Icon(Icons.cancel),
//                onPressed: () {
//                  _cancel();
//                }),
            GestureDetector(
              child: Image.asset('assets/icons/back_bold.png', scale: 5.5,),
              onTap: (){
                _back();
              },
            ),
            GestureDetector(
              child: Image.asset('assets/icons/new/cancel.png', scale: 4,),
              onTap: (){
                _cancel();
              },
            )
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
      initialUrl: widget.url,
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
