import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/prefs_response.dart';
import 'package:dollan/models/user_prefs_response.dart';
import 'package:dollan/templates/profile_template.dart';
import 'package:dollan/utilities/font_awesome.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePrefsPage extends StatefulWidget {
  ProfilePrefsPage({this.firstShow = true});

  final bool firstShow;

  @override
  _ProfilePrefsPageState createState() => _ProfilePrefsPageState();
}

class _ProfilePrefsPageState extends State<ProfilePrefsPage> {
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
  UserPrefsData userPrefsData;
  List userAnswers = [];
  String userid;

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

  _submit() async {
    print(items.length);

    answers = [];

    for (int i = 0; i < items.length; i++) {
      if (items[i].selected) {
        answers.add(items[i].title);
      }
    }

    if (answers.length == 0) {
      return;
    }

    var paramAnswer = answers.join(',');

    var userid = await Helper().getUserPrefs('userid');

    Map params = {
      'iduser': userid,
      'question': _question,
      'answer': paramAnswer
    };

    print(params);

    setState(() {
      _busy = true;
    });

    await Services().savePrefs(params).then((res) {
      // print(res.statusCode);
      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        print(body["success"]);
        if (body["success"] == "true") {
          print('sukses update prefs');
//          Navigator.of(context).pushReplacementNamed('home');
        } else {
          print('gagal update prefs');
          print(res.body);
        }
      }
    }).catchError((err) {
      print('error update prefs: $err');
    });

    setState(() {
      _busy = false;
    });
  }

  _init() async {
    // Cek apakah user sudah login atau belum
    userid = await Helper().getUserPrefs('userid');
    setState(() {
      userid = userid;
    });

    _getPrefs();
    // return;

    setState(() {
      _busy = true;
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
          items = [];
          PrefsData data = body.data;
          List<ItemAnswer> itemAnswers = data.itemAnswer;
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
          _userPrefs();
        }
      }
    }).catchError((err) => print(err));
  }

  _userPrefs() async {
    print('userprefs');
    var userid = await Helper().getUserPrefs('userid');
    if (userid == null) return;
    await Services().getUserPrefs(userid).then((res) {
      if (res.statusCode == 200) {
        UserPrefsResponse userPrefsResponse =
            userPrefsResponseFromJson(res.body);
        setState(() {
          userPrefsData = userPrefsResponse.data;
          userAnswers = userPrefsData.answer.split(',');
        });
        cekAdaPrefs();
      }
    });
  }

  cekAdaPrefs() {
    print('cekAdaPrefs');
    bool ada = false;
    for (int i = 0; i < items.length; i++) {
      for (int j = 0; j < userAnswers.length; j++) {
        print(
            '${items[i]}==${userAnswers[j]} ==> ${items[i] == userAnswers[j]}');
        if (items[i].title == userAnswers[j]) {
          print('ada');
          ada = true;
          items[i].selected = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ProfileBackground(
          top: 0.88,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: Helper().backButton(context),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('My Preference', style: Theme.of(context).textTheme.title.apply(fontWeightDelta: 4),),
          ),
          body: _busy
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : userid == null
                  ? Helper().noLoginData(context,
                      'Login terlebih dahulu untuk mengakses data ini.')
                  : SingleChildScrollView(
                      child: Padding(
                        padding: widget.firstShow
                            ? EdgeInsets.only(top: 40.0, left: 20, right: 20)
                            : EdgeInsets.only(top: 20.0, left: 20, right: 20),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Preferensi Kamu',
                              style: Helper().formatText(1),
                            ),
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
                                    color: item.selected == false
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(5)),
                                              child:

                                                  // Image.network(
                                                  //   item.image,
                                                  //   fit: BoxFit.cover,
                                                  //   width: double.infinity,
                                                  // )),

                                                  CachedNetworkImage(
                                                errorWidget:
                                                    (context, string, obj) {
                                                  return Icon(Icons.image);
                                                },
                                                imageUrl: '${item.image}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child:
                                                          CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation(
                                                                Theme.of(
                                                                        context)
                                                                    .primaryColor),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                              )),
                                        ),
                                        // Spacer(),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                              constraints:
                                  BoxConstraints(minWidth: double.infinity),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: RaisedButton(
                                  shape: StadiumBorder(),
                                  child: Text('SUBMIT'),
                                  onPressed: () {
                                    _submit();
                                    //  Navigator.of(context).pushReplacementNamed('home');
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
        ),
      ],
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
