import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dollan/models/boarding_response.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:dollan/pages/categories.dart';
import 'package:dollan/pages/maingate.dart';
import 'package:dollan/templates/DetailArguments.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:dollan/utilities/styles.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class BoardingPage extends StatefulWidget {
  @override
  _BoardingPageState createState() => _BoardingPageState();
}

class _BoardingPageState extends State<BoardingPage> {
  int currentSlide = 0;
  List<String> urlList = ['1', '2', '3'];
  BoardingResponse slider;
  List<BoardingData> sliders;
  bool _busy = false;
  PageController pgctrl;
  CarouselSlider _cs;
  int totalSlide = 0;
  bool seeAll = false;

  // final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_) => _initBoarding());
  }

  _initBoarding() async {
//    ScopedModel.of<MainModel>(context).addListener(_listener);
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );


    var userid = await Helper().getUserPrefs('userid');
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool visitbefore = sp.getBool('visitbefore');
    print('visitbefore: $visitbefore');
    
    if(userid!=null){

      await _saveDeviceToken(userid);
      Navigator.of(context).pushNamedAndRemoveUntil(
          'home', (Route<dynamic> route) => false,
          arguments: RouteArguments(tabIndex: 0));
      // return;
    } else if (visitbefore==null || visitbefore==false) {
      print('baru install');
      Services().boarding().then((res) {
        print('buka slider response: $res');
        if (res.statusCode == 200) {
          slider = boardingResponseFromJson(res.body);

          if (slider.success == 'true') {
            setState(() {
              sliders = slider.data;
              totalSlide = sliders.length;
            });
          }
        }
      });
    } else {
      print('pernah buka sebelumnya');
      sp.setBool('visitbefore', true);
      Navigator.of(context)
          .pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
    }
  }

  _saveDeviceToken(String userid) async {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    String fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      ref.child('users').child(userid).set({
        'token': fcmToken,
      });
    }
  }

  _updateCurrentSlide(int index) {
    if (currentSlide == totalSlide - 1) {
      seeAll = true;
    }

    setState(() {
      currentSlide = index;
    });
  }

  @override
  void deactivate() {
//    _cs.pageController.dispose();
    super.deactivate();
  }

  @override
  void dispose() {
    print('dispose');

    super.dispose();
  }

//  @override
//  void deactivate(){
//    print('deactivate');
//    super.deactivate();
//    _cs.pageController.dispose();
//  }

  Widget _slider(List<BoardingData> data, Size _size) {
    _cs = CarouselSlider(
      enableInfiniteScroll: false,
      height: _size.height,
      viewportFraction: 1.0,
      items: map<Widget>(data, (index, i) {
        print('boarding: ${data[index]}');
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CachedNetworkImage(
                imageUrl: data[index].image,
                placeholder: (context, url) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            );
          },
        );
      }).toList(),
      autoPlay: false,
      aspectRatio: 2.0,
      onPageChanged: (index) {
        _updateCurrentSlide(index);
      },
    );

    return Stack(children: [
      _cs,
      Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 20.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(data, (index, url) {
              return Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        currentSlide == index ? Colors.orange : Colors.white),
              );
            }),
          )),
      Positioned(
        right: 22,
        bottom: 22,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MainGatePage()));
          },
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: currentSlide < totalSlide - 1 && seeAll == false
                  ? Colors.blue
                  : Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              currentSlide < totalSlide - 1 && seeAll == false
                  ? 'Skip'
                  : 'Next',
              style: currentSlide < totalSlide - 1 && seeAll == false
                  ? Theme.of(context).textTheme.title.apply(color: Colors.white)
                  : Theme.of(context)
                      .textTheme
                      .title
                      .apply(color: Colors.black),
            ),
          ),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;

    Widget _logo() {
      return Container(
        // color: Colors.green[100],
        width: 100,
        height: 50,
        child: Center(
          child: Image.asset('assets/logo-dolan.png'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: sliders == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : mounted ? _slider(sliders, _size) : Container()),
            ],
          ),
          Positioned(right: 20, top: 42, child: _logo())
        ],
      ),
    );
  }
}
