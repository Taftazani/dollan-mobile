import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dollan/models/boarding_response.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:dollan/pages/categories.dart';
import 'package:dollan/templates/DetailArguments.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:dollan/utilities/styles.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class MainGatePage extends StatefulWidget {
  @override
  _MainGatePageState createState() => _MainGatePageState();
}

class _MainGatePageState extends State<MainGatePage> {
  int currentSlide = 0;
  List<String> urlList = ['1', '2', '3'];
  BoardingResponse slider;
  List<BoardingData> sliders;
  bool _busy = false;
  PageController pgctrl;
  CarouselSlider _cs;

  _updateCurrentSlide(int index) {
    if(mounted){
      setState(() {
      currentSlide = index;
    });
    }
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initBoarding());

  }

//  _listener(){
//    if(ScopedModel.of<MainModel>(context).userLoggedIn){
//      Navigator.of(context).pushReplacementNamed('home');
//    }
//  }

  _initBoarding() async {
//    ScopedModel.of<MainModel>(context).addListener(_listener);

    bool adauser = await ScopedModel.of<MainModel>(context).checkUser(context);

    if(adauser){

      Navigator.of(context)
          .pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false, arguments: RouteArguments(tabIndex: 0));
    } else {
      Services().boarding().then((res) {
        if (res.statusCode == 200) {
          slider = boardingResponseFromJson(res.body);

          if (slider.success == 'true') {
            setState(() {
              sliders = slider.data;
            });
          }
        }
      });
    }


  }

  @override
  void deactivate(){
//    _cs.pageController.dispose();
    super.deactivate();
  }


  @override
  void dispose() { 
    print('dispose');

    super.dispose();

    
  }

  Widget _slider(List<BoardingData> data, Size _size) {
    _cs = CarouselSlider(
      height: _size.height * 0.7,
      viewportFraction: 1.0,
      items: map<Widget>(data, (index, i) {
        print('boarding: ${data[index]}');
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                print('detail id : ${data[index].dataId}');

                Helper().goToPage(
                    context: context,
                    type: data[index].linkType,
                    args: RouteArguments(page:'', id:data[index].dataId, title: data[index].title));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child:
                CachedNetworkImage(
                  imageUrl: data[index].image,
                  placeholder: (context, url) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),),
                    ),
                  ),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            );
          },
        );
      }).toList(),
      autoPlay: true,
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
          bottom: 5.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(data, (index, url) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                    currentSlide == index ? Colors.orange : Colors.white),
              );
            }),
          ))
    ]);
  }



  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;

    Widget _logo() {
      return Container(
        // color: Colors.green[100],
        width: _size.width*0.4,
//        height: 50,
        child: Center(
          child: Image.asset('assets/logo-dolan.png'),
        ),
      );
    }



    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _logo(),
                Container(
                  height: _size.height * 0.3,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // tombol opsi
                        SizedBox(
                            width: _size.width * 0.7,
                            child: Styles().defaultButton(context, 'Login',
                                () => Navigator.of(context).pushNamed('login'))),
                        // tombol opsi
                        SizedBox(
                          width: _size.width * 0.7,
                          child: Styles().defaultButton(context, 'Buat Akun',
                              () => Navigator.of(context).pushNamed('signUp')),
                        ),
                        SizedBox(
                          width: _size.width * 0.7,
                          child: RaisedButton(
                            color: Colors.white,
                            elevation: 0,
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('home', arguments: RouteArguments(tabIndex:0));
                            },
                            child: Text('Saya akan login nanti'),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

