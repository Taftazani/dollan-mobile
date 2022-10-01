import 'package:dollan/models/auth_model.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:dollan/utilities/helper.dart';

//import 'package:dollan/utilities/helper.dart';
//import 'package:dollan/utilities/helper.dart' as prefix0;
import 'package:dollan/utilities/services.dart';
import 'package:dollan/utilities/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:scoped_model/scoped_model.dart';

class SignUp extends StatefulWidget {
  SignUp({this.update = false});

  final bool update;

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  TextEditingController firstNameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController genderCtrl = TextEditingController();
  TextEditingController dobCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController _rePasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool busy = false;

  // dob
  String selectedDob;
  DateFormat dateFormatDisplay = DateFormat("dd-MM-yyyy");
  DateFormat dateFormatCode = DateFormat("yyyy-MM-dd");

  // genders
  String genderSelected = '';
  var genders = ['laki-laki', 'perempuan'];

  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init);
  }

  _init() {
    if (widget.update) {
      // load user profile
    }
  }

  // show material calendar
  _showCalendar() async {
    DateTime datePicked = await showDatePicker(
        context: context,
        initialDate: DateTime(1995, 1),
        firstDate: DateTime(1950, 1),
        lastDate: DateTime(2015));

    if (datePicked != null) {
      var _result = dateFormatDisplay.format(datePicked);
      selectedDob = dateFormatCode.format(datePicked);

      setState(() {
        dobCtrl.text = '$_result';
      });
    }
  }

  _register() async {
    bool checkPw = false;
    if (passwordCtrl.text != _rePasswordController.text) {
      await Helper().showAlert(context, 'Kedua password harus sama');
      return null;
    }

//    if(!checkPw) return;
    if (!_formKey.currentState.validate()) return null;

    Map<String, String> _data = {
      'username': usernameCtrl.text,
      'password': passwordCtrl.text,
      'firstname': firstNameCtrl.text,
      'lastname': lastNameCtrl.text,
      'mobilephone': phoneCtrl.text,
      'gender': genderSelected,
      'birth_date': dobCtrl.text,
      'address': addressCtrl.text,
      'email': emailCtrl.text,
    };

    if (widget.update) {
      //
    } else {
      // Register baru
      setState(() => busy = true);
      Services().register(_data).then((res) {
        print('register status code: ${res.statusCode}');
        if (res.statusCode == 200) {
          setState(() => busy = false);
//          print(res.body);
          var data = authResponseFromJson(res.body);
          print('$data');
          if (data.success == 'true') {
            Helper().saveUserPrefs('password', passwordCtrl.text);
            Helper().showAlert(context, 'Akun berhasil dibuat.').then((res) {
              Navigator.of(context).pop();
            });
          } else {
            Helper().showAlert(context, '${data.message}');
          }
        } else {
          setState(() => busy = false);
          Helper().showAlert(
              context, 'Gagal menyimpan data. Coba beberapa saat lagi.');
        }
      }).catchError((err) {
        setState(() => busy = false);
        print('register error: $err');
        Helper().showAlert(context, '$err');
      });
    }
  }

  //show genders
  _showGenderOptions() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Laki-laki'),
                onTap: () {
                  setState(() {
                    genderCtrl.text = genderSelected = genders[0];
                    // genderSelected = genders[0];
                    // genderCtrl.text = genders[0];
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Perempuan'),
                onTap: () {
                  setState(() {
                    genderCtrl.text = genderSelected = genders[1];
                    // genderCtrl.text = genders[1];
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
        });
  }

  _authFb() async {
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final result = await facebookLogin.logInWithReadPermissions(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        // _sendTokenToServer(result.accessToken.token);
        var token = result.accessToken.token;

        // get profile
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${token}');
        final profile = json.decode(graphResponse.body);

        var _id = result.accessToken.userId;
        var _email = profile['email'];
        var _name = profile['name'];
        var _pic = profile['picture']['data']['url'];

        print('$_id - $_email - $_name - $_pic');

        Map<String, String> _data = {
          'email': _email,
          'idfacebook': _id,
          'name': _name,
          'photo': _pic
        };

        ScopedModel.of<MainModel>(context).loginFb(context, _data);
        break;
      case FacebookLoginStatus.cancelledByUser:
        // _showCancelledMessage();
        print('FacebookLoginStatus.cancelledByUser');
        break;
      case FacebookLoginStatus.error:
        // _showErrorOnUI(result.errorMessage);
        print(result.errorMessage);
        break;
    }
  }

  Future<FirebaseUser> _handleSignIn(BuildContext context) async {
    setState(() {
      isBusy = true;
    });
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // final FirebaseUser user = await _auth.signInWithCredential(credential);
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    // print("signed in " + authResult.user.displayName);
    // Navigator.pushNamed(context, 'home');
    return authResult.user;
  }

  onGoogleSignIn(BuildContext context) async {
    print('onGoogleSignIn');
    await _handleSignIn(context).then((res) {
      print(res);

      var _id = res.uid;
      var _email = res.email;
      var _name = res.displayName;
      var _pic = res.photoUrl;

//      print('login google : $_id - $_email - $_name - $_pic');
      print('login google dapet photoUrl : ');
      print('$_pic');
      Helper().saveUserPrefs('photo', _pic);

      Map<String, String> _data = {
        'email': _email,
        'idgoogle': _id,
        'name': _name,
        'photo': _pic
      };

      ScopedModel.of<MainModel>(context).loginGoogle(context, _data);
      // Navigator.pushNamed(context, 'home');
    }).catchError((e) => print('---> error onGoogleSignIn : $e'));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: Helper().backButton(context),
        title:
            widget.update ? Text('Update Profile') : Text('Daftar Akun Baru'),
      ),
      body: busy
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    widget.update
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Text(
                              'Isikan data Anda untuk membuat akun baru',
                              style: Theme.of(context).textTheme.subtitle,
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              controller: firstNameCtrl,
                              decoration: InputDecoration(
                                labelText: 'Nama Depan',
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Harap diisi';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              controller: lastNameCtrl,
                              decoration:
                                  InputDecoration(labelText: 'Nama Belakang',
                                    labelStyle: TextStyle(color: Colors.black),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Harap diisi';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: phoneCtrl,
                              decoration: InputDecoration(labelText: 'No Telp',
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Harap diisi';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailCtrl,
                              decoration: InputDecoration(labelText: 'Email',labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Harap diisi';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: passwordCtrl,
                              decoration:
                                  InputDecoration(labelText: 'Password',labelStyle: TextStyle(color: Colors.black),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Harap diisi';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _rePasswordController,
                              decoration: InputDecoration(
                                  labelText: 'Konfirmasi Password',labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Harap diisi';
                                }
                                return null;
                              },
                            ),

                            widget.update
                                ? TextFormField(
                                    controller: addressCtrl,
                                    maxLines: 3,
                                    decoration:
                                        InputDecoration(labelText: 'alamat',labelStyle: TextStyle(color: Colors.black),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black),
                                          ),),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Harap diisi';
                                      }
                                      return null;
                                    },
                                  )
                                : Container(),

                            // // username dan passwords
                            // TextFormField(
                            //   controller: usernameCtrl,
                            //   decoration: InputDecoration(labelText: 'username'),
                            //   validator: (value) {
                            //     if (value.isEmpty) {
                            //       return 'Harap diisi';
                            //     }
                            //     return null;
                            //   },
                            // ),

                            // dob
                            widget.update
                                ? GestureDetector(
                                    onTap: () {
                                      print('show calendar');
                                      _showCalendar();
                                    },
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        controller: dobCtrl,
                                        decoration: InputDecoration(
                                            labelText: 'tgl lahir'),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Harap diisi';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  )
                                : Container(),

                            // gender
                            widget.update
                                ? GestureDetector(
                                    onTap: () {
                                      _showGenderOptions();
                                    },
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        controller: genderCtrl,
                                        decoration: InputDecoration(
                                            labelText: 'jenis kelamin'),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Harap diisi';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  )
                                : Container(),

                            SizedBox(
                              height: 20,
                            ),

                            // Buttons
                            SizedBox(
                              width: size.width * 0.6,
                              child: Styles().defaultButton(
                                  context, 'Continue', () => _register()),
                            ),

                            // -- or --
                            SizedBox(
                              height: 80,
                              child: Center(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Divider(),
                                    ),
                                    Text('or'),
                                    Expanded(
                                      flex: 1,
                                      child: Divider(),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // google button
                            widget.update
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _googleSignUpButton(),
                                  ),

                            // google button
                            widget.update
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _facebookSignUpButton(),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _googleSignUpButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/logo_google_g.png',
            width: 20,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Google',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      onPressed: () {
        onGoogleSignIn(context);
      },
    );
  }

  Widget _facebookSignUpButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      color: Colors.blue[700],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/logo_fb_f.png',
            width: 20,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Facebook',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      onPressed: () {
        _authFb();
      },
    );
  }
}
