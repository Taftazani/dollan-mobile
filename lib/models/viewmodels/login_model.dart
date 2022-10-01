import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dollan/utilities/services.dart';
import 'package:dollan/utilities/apis.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class LoginModel extends Model {
  bool _userLoggedIn = false;
  bool _busy = false;
  String _username = 'belum ada';

  bool get userLoggedIn => _userLoggedIn;
  bool get busy => _busy;
  String get username => _username;

  checkUser() async {
    _busy = true;
    notifyListeners();

    SharedPreferences sp = await SharedPreferences.getInstance();
    _busy = false;
    notifyListeners();

    var user = sp.getString("userid");
    if (user != null) {
      _userLoggedIn = true;
      notifyListeners();
    }
  }

  Future saveUserPrefs(String value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('userid', value);
  }

  loginNative(BuildContext context, Map authData) async {
    _busy = true;
    notifyListeners();

    await Services().loginNative(authData).then((res) {
      _busy = false;
      notifyListeners();

      if (res.statusCode == 200) {
        
        // success
        // var data = json.decode(res.body);
        // Helper().saveUserPrefs('username', value)
        // Navigator.of(context).pushReplacementNamed('survey');
      } else {
        // show alert
      }
    }).catchError((err) {
      _busy = false;
      notifyListeners();

      print('login native error: $err');
    });
  }

  loginGoogle(BuildContext context, Map authData) async {
    _busy = true;
    notifyListeners();

    await Services().loginGoogle(authData).then((res) {
      

      if (res.statusCode == 200) {
        // success
        var data = json.decode(res.body);
        saveUserPrefs(data['UserId']).then((res) {
          _busy = false;
          notifyListeners();
          Navigator.of(context).pushNamed('home', arguments: RouteArguments(viewCart:false));
        });

        print('---------------------------');
        print('login google success : ${data['UserId']}');
        print('---------------------------');
      } else {
        // show alert
        _busy = false;
        notifyListeners();
        Helper().showAlert(context, 'Gagal otentikasi user. Coba beberapa saat lagi.');
      }
    }).catchError((err) {
      _busy = false;
      notifyListeners();

      print('login native error: $err');
    });
  }

  loginFb(BuildContext context, Map authData) async {
    _busy = true;
    notifyListeners();

    await Services().loginFb(authData).then((res) {
      if (res.statusCode == 200) {
        // success
        var data = json.decode(res.body);
        saveUserPrefs(data['UserId']).then((res) {
          _busy = false;
          notifyListeners();
          Navigator.of(context).pushNamed('home', arguments: RouteArguments(viewCart:false));
        });

        print('---------------------------');
        print('login fb success : ${data['UserId']}');
        print('---------------------------');
      } else {
        // show alert
        _busy = false;
        notifyListeners();
        Helper().showAlert(
            context, 'Gagal otentikasi user. Coba beberapa saat lagi.');
      }
    }).catchError((err) {
      _busy = false;
      notifyListeners();

      print('login native error: $err');
    });
  }
}
