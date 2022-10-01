import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/profile/profile_data_model.dart';
import 'package:dollan/models/profile/profile_model.dart';
import 'package:dollan/pages/chat.dart';
import 'package:dollan/pages/profile_profile.dart';
import 'package:dollan/pages/mood.dart';
import 'package:dollan/pages/profile_prefs.dart';
import 'package:dollan/pages/survey.dart';
import 'package:dollan/pages/profile_transaction_history.dart';
import 'package:dollan/pages/profile_vouchers.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dollan/models/viewmodels/trans_history_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileBackground extends StatelessWidget {
  ProfileBackground({this.top});
  double top;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Container(
          width: size.width,
          height: size.height,
          color: Theme.of(context).primaryColor,
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: size.width,
            height: size.height * top,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(30))),
          ),
        ),
//        Positioned(
//            child: IconButton(
//              icon: Icon(
//                Icons.settings,
//                color: Colors.black,
//              ),
//            ),
//            top: 30,
//            left: 0),
//        Positioned(
//            child: IconButton(
//              icon: Icon(
//                Icons.chat,
//                color: Colors.black,
//              ),
//            ),
//            top: 30,
//            right: 0),

      ],
    );
  }
}

