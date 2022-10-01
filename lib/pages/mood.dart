import 'package:dollan/utilities/helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MoodPage extends StatefulWidget {
  @override
  _MoodPageState createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  var options = [0, 0, 1, 1, 0, 1];
  List<SurveyItem> items = [
    SurveyItem(icon: FontAwesomeIcons.anchor, title: 'Anchor', id: 1),
    SurveyItem(icon: FontAwesomeIcons.tree, title: 'Tree', id: 2),
    SurveyItem(icon: FontAwesomeIcons.image, title: 'Photo', id: 3),
    SurveyItem(icon: FontAwesomeIcons.bookmark, title: 'Photo', id: 3),
    SurveyItem(icon: FontAwesomeIcons.book, title: 'Photo', id: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
          child: Column(
            children: <Widget>[
              Center(
                  child: Text(
                'Travel Preference Kamu',
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
                  print('item.icon : ${item.id}');

                  return Card(
                    elevation: 3,
                    color: options[pos] == 0
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(items[pos].icon)),
                          Spacer(),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              '${items[pos].title}',
                              style: Helper().formatText(4),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
              Helper().spacer(isVertical: true, dist: 20),
              
            ],
          ),
        ),
      ),
      bottomNavigationBar: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: double.infinity),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: RaisedButton(
                      child: Text('SUBMIT'),
                      onPressed: () {},
                    ),
                  )),
    );
  }
}

class SurveyItem{
  IconData icon;
  String title;
  int id;

  SurveyItem({IconData icon, String title, int id}){
    this.icon = icon;
    this.title = title;
    this.id = id;
  }
}