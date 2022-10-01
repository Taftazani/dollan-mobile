import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dollan/models/viewmodels/login_model.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/styles.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  TextEditingController emailPhoneCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  /// Facebook
//  final facebookLogin = FacebookLogin();

  final _formKey = GlobalKey<FormState>();
  bool isBusy = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
    // emailPhoneCtrl.text = 'user@email.com';
    // passwordCtrl.text = '123456';
//    onCheckUser(context);
  }

  _init() {
    if (ScopedModel.of<MainModel>(context).devMode == true) {
      setState(() {
        emailPhoneCtrl.text = 'ucok2@email.com';
        passwordCtrl.text = '123';
      });
    }

    // ScopedModel.of<MainModel>(context).addListener(_listener);
    // ScopedModel.of<MainModel>(context).checkUser();
  }

  _listener() {
    if (ScopedModel.of<MainModel>(context).userLoggedIn) {
//      Navigator.of(context).pushNamed('homepage');
      Navigator.of(context)
          .pushNamedAndRemoveUntil('survey', (Route<dynamic> route) => false);
    }
  }

  /// Facebook

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

  ///

//  onCheckUser(context) async {
//    setState(() {
//      isBusy = true;
//    });
//    await _auth.currentUser().then((res) {
//      if (res != null) {
//        print("---> ada res");
//        Navigator.pushNamed(context, 'home');
//      } else {
//        setState(() {
//          isBusy = false;
//        });
//      }
//    }).catchError((e) {
//      setState(() {
//          isBusy = false;
//        });
//      print('---> error: $e');
//    });
//  }

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

      Helper().saveUserPrefs('photo', _pic);

//      print('login google : $_id - $_email - $_name - $_pic');
      print('login google dapet photoUrl : ');

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

    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: Helper().backButton(context),
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text('Dollan'),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: model.busy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                              'Enter your registered email address or phone number to login'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: emailPhoneCtrl,
                                  decoration: InputDecoration(
                                    labelText: 'Email atau Nomor Telpon',
                                    labelStyle: TextStyle(color: Colors.black),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please fill this field';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  obscureText: true,
                                  controller: passwordCtrl,
                                  decoration: InputDecoration(
                                    labelText: 'Kata Sandi',
                                    labelStyle: TextStyle(color: Colors.black),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Harap diisi';
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(
                                  height: 10,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FlatButton(
                                      child: Text('Forgot Password?'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed('forgot');
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(
                                        'Daftar Akun',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed('signUp');
                                      },
                                    )
                                  ],
                                ),

                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: size.width * 0.6,
                                  child: Styles()
                                      .defaultButton(context, 'Continue', () {
                                    if (_formKey.currentState.validate()) {
                                      model.loginNative(context, {
                                        'username': emailPhoneCtrl.text,
                                        'password': passwordCtrl.text
                                      });
                                    }
                                  }),
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _googleLoginButton(),
                                ),

                                // google button
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _facebookLoginButton(),
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
      },
    );
  }

  Widget _googleLoginButton() {
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
        // Navigator.of(context).pushReplacementNamed('survey');
      },
    );
  }

  Widget _facebookLoginButton() {
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
