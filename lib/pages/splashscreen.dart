import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
//  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Future.delayed(Duration(seconds: 2)).then((res){
    //   Navigator.of(context).pushReplacementNamed('boarding');
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  _init() async {
//    _fcm.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print("onMessage: $message");
//        showDialog(
//          context: context,
//          builder: (context) => AlertDialog(
//            content: ListTile(
//              title: Text(message['notification']['title']),
//              subtitle: Text(message['notification']['body']),
//            ),
//            actions: <Widget>[
//              FlatButton(
//                child: Text('Ok'),
//                onPressed: () => Navigator.of(context).pop(),
//              ),
//            ],
//          ),
//        );
//      },
//      onLaunch: (Map<String, dynamic> message) async {
//        print("onLaunch: $message");
//        // TODO optional
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print("onResume: $message");
//        // TODO optional
//      },
//    );

    await Future.delayed(Duration(seconds: 2)).then((res) {
      Navigator.of(context).pushReplacementNamed('boarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logo-splash.png',
          scale: MediaQuery.of(context).size.width*0.01,
        ),
      ),
    );
  }
}
