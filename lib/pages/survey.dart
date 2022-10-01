import 'dart:convert';

import 'package:dollan/models/prefs_response.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/utilities/font_awesome.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SurveyPage extends StatefulWidget {
  SurveyPage({this.firstShow = true});
  final bool firstShow;

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  var options = [0, 0, 1, 1, 0, 1];
//   List<SurveyItem> items = [
// //    SurveyItem(icon: FontAwesomeIcons.anchor, title: 'Anchor', id: 1),
// //    SurveyItem(icon: FontAwesomeIcons.tree, title: 'Tree', id: 2),
// //    SurveyItem(icon: FontAwesomeIcons.image, title: 'Photo', id: 3),
// //    SurveyItem(icon: FontAwesomeIcons.bookmark, title: 'Photo', id: 3),
// //    SurveyItem(icon: FontAwesomeIcons.book, title: 'Photo', id: 3),
//   ];

  List<SurveyItem> items = [];

  List answers = [];
  List labels = [];
  List icons = [];
  String _question = '';
  bool _busy = false;

  selectItem(int pos) {
    setState(() {
      items[pos].selected = !items[pos].selected;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  _submit(bool skip) async {

    answers = [];

    for (int i = 0; i < items.length; i++) {
      if (items[i].selected) {
        answers.add(items[i].title);
      }
    }

//    if (answers.length == 0) {
//      return;
//    }

    var paramAnswer = answers.join(',');

    var userid = await Helper().getUserPrefs('userid');

    Map params;

    if(skip){
      params = {
        'iduser': '',
        'question': '',
        'answer': ''
      };
    } else {
      params = {
        'iduser': userid,
        'question': _question,
        'answer': paramAnswer
      };
    }

    setState(() {
      _busy = true;
    });

    await Services().savePrefs(params).then((res) {
      // print(res.statusCode);
      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        print(body["success"]);
        if (body["success"] == "true") {
          print('sukses');
          Navigator.of(context).pushReplacementNamed('home', arguments: RouteArguments(tabIndex: 0));
        } else {
          print(res.body);
        }
      }
    }).catchError((err) {
      print('error: $err');
    });

    setState(() {
      _busy = false;
    });
  }

  _init() async {
    // Cek apakah user sudah pernah ke page ini sebelumnya
    // _getPrefs();
    // return;

    setState(() {
      _busy = true;
    });

    var userid = await Helper().getUserPrefs('userid');

    await Services().getPrefsUser(userid).then((res) {
      // print(res.body);

      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        if (body["success"] == "true") {
          print('--->>> user sudah pernah');

          setState(() {
            _busy = false;
          });

          Navigator.of(context).pushReplacementNamed('home', arguments: RouteArguments(tabIndex: 0));
        } else {
          print('--->>> user belum pernah');
          _getPrefs();
        }
      }
    });
  }

  _getPrefs() async {
    print('get new prefs');
    setState(() {
      _busy = true;
    });

    await Services().getPrefsQuestion().then((res) {
      setState(() {
        _busy = false;
      });

      print(res);

      if (res.statusCode == 200) {
        PrefsResponse body = prefsResponseFromJson(res.body);

        print(body);
        if (body.success == "true") {
          PrefsData data = body.data;
          List<ItemAnswer> itemAnswers = data.itemAnswer;

          // var answer = data[0].answer;
          // var icon = data[0].icon;

          // labels = answer.split(',');
          // icons = icon.split(',');
          setState(() {
            _question = data.question;
            print(_question);

            for (int i = 0; i < itemAnswers.length; i++) {
              SurveyItem surveyItem = SurveyItem(
                  image: itemAnswers[i].image,
                  title: itemAnswers[i].answer,
                  id: i);
              items.add(surveyItem);
            }
          });
        }
      }
    }).catchError((err) => print(err));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.firstShow
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/logo-dolan.png'),
              ),
            )
          : null,
      body: _busy
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: widget.firstShow
                    ? EdgeInsets.only(top: 40.0, left: 20, right: 20)
                    : EdgeInsets.only(top: 20.0, left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    Center(
                        child: Text(
                      _question,
                      style: Helper().formatText(1),
                    )),
                    Helper().spacer(isVertical: true, dist: 40),
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.7,
                      children: List.generate(items.length, (pos) {
                        SurveyItem item = items[pos];
//                  print('item.icon : ${item.id}');

                        return GestureDetector(
                          onTap: () {
                            selectItem(pos);
                          },
                          child: Card(
                            elevation: 3,
                            color: items[pos].selected == false
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(5)),
                                      child: Image.network(
                                        item.image,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                // Spacer(),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${items[pos].title}',
                                        style: Helper().formatText(4),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    Helper().spacer(isVertical: true, dist: 20),
                    ConstrainedBox(
                      constraints: BoxConstraints(minWidth: double.infinity),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                              shape: StadiumBorder(),
                              child: Text('SKIP', style: TextStyle(color:Colors.red),),
                              onPressed: () {
                                _submit(false);
                                //  Navigator.of(context).pushReplacementNamed('home');
                              },
                            ),
                            RaisedButton(
                              shape: StadiumBorder(),
                              child: Text('SUBMIT'),
                              onPressed: () {
                                _submit(true);
                                //  Navigator.of(context).pushReplacementNamed('home');
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class SurveyItem {
  String image;
  String title;
  int id;
  bool selected;

  SurveyItem({String image, String title, int id, bool selected = false}) {
    this.image = image;
    this.title = title;
    this.id = id;
    this.selected = selected;
  }
}
