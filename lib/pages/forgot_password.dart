import 'dart:convert';

import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  bool busy = false;
  int state = 0;
  String successMessage;

  sendEmail() async {
    setState(() {
      busy = true;
    });

    await Services()
        .sendEmailForgotPassword({'email': emailController.text}).then((res) {
      setState(() {
        busy = false;
      });

      print(res.body);
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        if (data["success"] == "true") {
          setState(() {
            state = 1;
            successMessage = data["message"];
          });
        } else {
          setState(() {
            state = 2;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Forgot Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: busy ? Helper().busyIndicator(context, size) :
          state == 0 ? body() : state == 1 ? bodyState1() : bodyState2(),
        ));
  }

  Widget body() {
    return Column(
      children: <Widget>[
        Text(
            'Silahkan masukkan email Anda untuk mendapatkan petunjuk pemulihan password.'),
        SizedBox(
          height: 10,
        ),
        TextField(
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          decoration: InputDecoration(
              labelText: 'email',
              labelStyle: Theme.of(context).textTheme.caption),
        ),
        SizedBox(
          height: 10,
        ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text('Kirim'),
          onPressed: () {
            if (emailController.text.isEmpty) return;
            sendEmail();
          },
        )
      ],
    );
  }

  Widget bodyState1() {
    return Column(
      children: <Widget>[
        Text(successMessage),
        SizedBox(
          height: 10,
        ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text('Kembali'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  Widget bodyState2() {
    return Column(
      children: <Widget>[
        Text('Gagal mengirim data. Silahkan coba beberapa saat lagi.'),
        SizedBox(
          height: 10,
        ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text('Kembali'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
