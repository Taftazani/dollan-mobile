import 'package:dollan/pages/categories.dart';
import 'package:dollan/pages/detail.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static final Helper helper = Helper._internal();

  final formatter = new NumberFormat('#,###', 'id_ID');

  Helper._internal();

  factory Helper() {
    return helper;
  }

  String dummyText =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum egestas mattis magna vitae imperdiet. In dignissim ac nulla in pretium. Etiam a pulvinar orci, nec imperdiet ex. Curabitur sollicitudin, orci quis aliquet pulvinar, leo nulla malesuada lectus, eu ullamcorper purus nulla vitae neque. \n\nSed viverra consequat neque, et aliquet lectus aliquam a. Vestibulum sodales commodo dolor, sit amet viverra felis rutrum quis. Aenean elementum massa dui, quis posuere lacus facilisis eget. Morbi in leo a dolor malesuada malesuada. Morbi convallis magna elit, vel mattis erat placerat ut.';

  String dummyTextShort =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum egestas mattis magna vitae imperdiet. In dignissim ac nulla in pretium.';

  createStars(BuildContext context, int count) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          return index < count
              ? SizedBox(
                  width: 12,
                  child: Icon(
                    Icons.star,
                    size: 15,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : SizedBox(
                  width: 12,
                  child: Icon(
                    Icons.star,
                    size: 15,
                    color: Colors.grey[300],
                  ),
                );
        }));
  }

  separator({bool isHorizontal, double height}) {
    return isHorizontal
        ? Container(
            color: Colors.grey,
            height: 1,
          )
        : Container(
            color: Colors.grey,
            width: 1,
            height: height,
          );
  }

  showProgressDialog(BuildContext context, String title) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        width: 10,
                      ),
                      Center(
                          child: Text(
                        title,
                        style: TextStyle(fontSize: 12),
                      ))
                    ]),
              ],
            ),
          );
        });
  }

  TextStyle formatText(int type) {
    switch (type) {
      case 1:
        return TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
      case 2:
        return TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
      case 3:
        return TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
      case 4:
        return TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
      case 5:
        return TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
      default:
        return TextStyle(fontSize: 12, fontWeight: FontWeight.normal);
    }
  }

  Widget spacer({bool isVertical = false, double dist = 10}) {
    if (isVertical) {
      return SizedBox(
        height: dist,
      );
    } else {
      return SizedBox(
        width: dist,
      );
    }
  }

  Future showAlert(BuildContext context, String msg) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
                child: Text('Tutup'),
                onPressed: () => Navigator.of(context).pop())
          ],
        );
      },
    );
  }

  Future showAlertCustom(
      {BuildContext context, String msg, String buttonLabel}) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
                child: Text(buttonLabel == null ? 'Tutup' : buttonLabel),
                onPressed: () => Navigator.of(context).pop())
          ],
        );
      },
    );
  }

  Future<bool> showAlertWithParams(BuildContext context, String msg) async {
    bool ok = false;
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop()),
            FlatButton(
                child: Text('Batal'),
                onPressed: () {
                  ok = true;
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
    return ok;
  }

  Future saveUserPrefs(String key, String value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, value);
  }

  Future<String> getUserPrefs(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  Future removeUserPrefs(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.remove(key);
  }

  goToPage({BuildContext context, String type, RouteArguments args}) {
    switch (type) {
      case 'category':
        print('ini kategori');
        Navigator.of(context).pushNamed('categories',
            arguments: RouteArguments(
                title: args.title, id: args.id, type: type, page: ''));
        break;
      case 'mood':
        Navigator.of(context).pushNamed('categories',
            arguments: RouteArguments(
                title: args.title, id: args.id, type: type, page: ''));
        break;
      default:
        Navigator.of(context)
            .pushNamed('detail', arguments: RouteArguments(id: args.id));
    }
  }

  Widget noImage({double h = 100}) {
    return Center(
      child: Container(
        height: h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.image,
              size: h / 3,
              color: Colors.grey[400],
            ),
            Text(
              'No Image',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500]),
            )
          ],
        ),
      ),
    );
  }

  Widget noData(Size size) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.not_interested,
            size: 50,
            color: Colors.grey[400],
          ),
          Text(
            'Data tidak ditemukan.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          )
        ],
      ),
    );
  }

  Widget busyIndicator(BuildContext context, Size size) {
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  String setCurrencyFormat(int price) {
    var s = 'Rp ${formatter.format(price)}';
    return s;
  }

  Widget noLoginData(BuildContext context, String msg) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            msg,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text('Login'),
              onPressed: () {
                Navigator.of(context).pushNamed('login');
              },
            ),
          )
        ],
      ),
    );
  }

  Widget backButton(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Image.asset(
          'assets/icons/back_bold.png',
          scale: 4.5,
        ));
  }
}
