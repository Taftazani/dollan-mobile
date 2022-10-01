import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/profile/profile_data_model.dart';
import 'package:dollan/models/profile/profile_model.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:dollan/pages/chat.dart';
import 'package:dollan/pages/chat_list.dart';
import 'package:dollan/pages/chat_profile.dart';
import 'package:dollan/pages/contact.dart';
import 'package:dollan/pages/profile_profile.dart';
import 'package:dollan/pages/mood.dart';
import 'package:dollan/pages/profile_prefs.dart';
import 'package:dollan/pages/survey.dart';
import 'package:dollan/pages/profile_transaction_history.dart';
import 'package:dollan/pages/profile_vouchers.dart';
import 'package:dollan/pages/tos.dart';
import 'package:dollan/templates/profile_template.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dollan/models/viewmodels/trans_history_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';
import 'package:firebase_database/firebase_database.dart';

import 'CustomSlideRoute.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  int tabIndex = 0;
  String userid;
  ProfileData profileData;
  String photo;
  String currentPhoto;
  int index = 0;
  TabController tabController;
  DatabaseReference query;

  StreamSubscription<Event> onAddListener;
  StreamSubscription<Event> onChangeListener;

  int totalMessages = 0;

  _logout() async {
    await _googleSignIn.signOut();
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('userid');
    sp.remove('username');

    await Helper().removeUserPrefs('userid');
    Navigator.of(context).pushReplacementNamed('maingate');
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  _init() async {
//    tabController = TabController(vsync: this, length: 2);

    ScopedModel.of<MainModel>(context).onGetVersionInfo();

    userid = await Helper().getUserPrefs('userid');
    if (userid == null) {
      return;
    }

    profileData =
        await ScopedModel.of<ProfileModel>(context).getProfile(userid);

    if (profileData == null) return;

    print('profile : $profileData');

    photo = await Helper().getUserPrefs('photo');

    setState(() {
      currentPhoto = '${profileData.imageuser}';
    });

    // firebase
    // onAddListener = operatorRef.onChildAdded.listen(onChildAdded);
    // checkMessages();
    query =
        FirebaseDatabase.instance.reference().child('history').child(userid);
    onAddListener = query.onChildAdded.listen(onAddEntry);
    // onChangeListener = query.onChildChanged.listen(onChangeEntry);
  }

  checkMessages() {
    print('check messages');
    setState(() {
      totalMessages = 0;
    });
    query =
        FirebaseDatabase.instance.reference().child('history').child(userid);
    onAddListener = query.onChildAdded.listen(onAddEntry);
  }

  @override
  void dispose() {
    onAddListener.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // checkMessages();
  }

  void onAddEntry(Event event) {
    // print('---- onAddEntry: ${event.snapshot}');
    int total = event.snapshot.value['unread_messages'];
    if (total == null) {
      total = 0;
    }
    setState(() {
      totalMessages += total;
    });
  }

  void onChangeEntry(Event event) {
    print('---- onChangeEntry');
    int total = event.snapshot.value['unread_messages'];
    if (total == null) {
      total = 0;
    }
    setState(() {
      totalMessages += total;
    });
  }

  _updateTab(int pos) {
    setState(() {
      index = pos;
    });
    tabController.animateTo(pos);
  }

  _showVersion() async {
    var versi = await ScopedModel.of<MainModel>(context).onGetVersionInfo();
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  'assets/icon_dollan.png',
                  scale: 4,
                ),
                Center(child: Text('Versi : $versi')),
              ],
            ),
          );
        });
  }

  _confirmLogout() async {
    bool logout = false;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(child: Text('Anda Yakin Akan Keluar?')),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Keluar'),
                  onPressed: () {
                    logout = true;
                    Navigator.of(context).pop();
                  }),
              FlatButton(
                  child: Text('Batal'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
    if (logout) {
      _logout();
    }
  }

  _chat() async {
    String userid = await Helper().getUserPrefs('userid');
    print('userid: $userid');
    if (userid == null) {
      await Helper()
          .showAlert(context, 'Anda harus login terlebih dahulu')
          .then((_) {
        Navigator.of(context).pushNamed('login');
      });
    } else {
      await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ChatProfilePage()));
      checkMessages();
    }
  }

  // _getNewMessages() async {
  //   DatabaseReference ref = FirebaseDatabase.instance.reference();

  //   ref.child('messages').
  //   if (fcmToken != null) {
  //     ref.child('users').child(userid).set({
  //       'token': fcmToken,
  //     });
  //   }
  // }

  void onChildAdded(Event event) async {
    // var data = await operatorRef.once();
    print('onChildAdded: ${event.snapshot.value}');
  }

  // @override
  // void dispose() {

  //   super.dispose();

  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ScopedModelDescendant<ProfileModel>(
        builder: (context, child, model) {
      return Stack(
        children: <Widget>[
          ProfileBackground(
            top: 0.7,
          ),
//          Positioned(
//              child: IconButton(
//                icon: Icon(
//                  Icons.settings,
//                  color: Colors.black,
//                ),
//              ),
//              top: 30,
//              left: 0),
          Positioned(
              child: Stack(
                children: <Widget>[
//                  IconButton(
//                    icon: Icon(
//                      Icons.chat,
//                      color: Colors.black,
//                    ),
//                    onPressed: () {
//                      _chat();
//                    },
//                  ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(right:16.0, top: 12),
                    child: Image.asset('assets/icons/new/chat.png', scale: 2,),
                  ),
                  onTap: () {
                    _chat();
                  },
                ),
                  totalMessages == null || totalMessages == 0
                      ? Container()
                      : SizedBox(
                          width: 20,
                          height: 20,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: Center(
                              child: Text(
                                '$totalMessages',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ),
                          ),
                        )
                ],
              ),
              top: 30,
              right: 0),
          Positioned(
              child: Text(
                '',
                style: Theme.of(context).textTheme.title,
              ),
              top: 120,
              left: 160),
          Positioned(
            top: 100,
            left: 25,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: model.file != null
                    ? Image.file(
                        File(model.file.path),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                    : currentPhoto != null
                        ? CachedNetworkImage(
                            imageUrl:
                                currentPhoto == null ? photo : currentPhoto,
                            placeholder: (context, url) => Image.asset(
                              'assets/profile.png',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                            errorWidget: (context, string, obj) {
                              return Image.asset(
                                'assets/profile.png',
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            'assets/profile.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
              ),
            ),
          ),

          // ***************************************************************** //

          Positioned(
            top:220,
            child: Container(
              width: size.width,
              child: DefaultTabController(
                length: 2,
                child: TabBar(
                  controller: tabController,
                  indicatorColor: Theme.of(context).primaryColor,
                  tabs: <Widget>[
                    Tab(
                        text: 'Aktifitas'
                    ),
                    Tab(
                      text: 'Lainnya',
                    )

                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 40,
            top: 280,
            child: SizedBox(
              height: size.height * 0.6,
              width: size.width * 0.8,
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: tabController,
                children: <Widget>[
                  Container(
                    height: 400,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        buildMenu(1, 'Daftar Transaksi', 'daftar-transaksi', null),
                        buildMenu(2, 'My Voucher', 'voucher', null),
                        buildMenu(3, 'My Preference', 'prefs', null),
                        buildMenu(4, 'Ubah Profile', 'ubah-profile', null),
                        buildMenu(5, 'Bagi ke Teman', 'ajak-teman', null),
                      ],
                    ),
                  ),
                  Container(
                    height: 400,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        buildMenu(6, 'Dollan Term & Condition',
                            'term', null),
                        buildMenu(7, 'Contact Us', 'contact-us', null),
                        userid == null
                            ? Container()
                            : buildMenu(8, 'Log Out', 'logout', null),
                        buildMenu(9, 'Version', 'version', null),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /*

          Positioned(
              top: 220,
              child: SizedBox(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'Aktifitas',
                        style: TextStyle(
                            fontSize: 18,
                            color: index == 0
                                ? Theme.of(context).primaryColor
                                : Colors.black),
                      ),
                      onPressed: () => _updateTab(0),
                    ),
                    FlatButton(
                      child: Text(
                        'Lainnya',
                        style: TextStyle(
                            fontSize: 18,
                            color: index == 1
                                ? Theme.of(context).primaryColor
                                : Colors.black),
                      ),
                      onPressed: () => _updateTab(1),
                    ),
                  ],
                ),
              )),
          Positioned(
            left: 40,
            top: 280,
            child: SizedBox(
              height: size.height * 0.6,
              width: size.width * 0.8,
              child: DefaultTabController(
                length: 2,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: <Widget>[
                    Container(
                      height: 400,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          buildMenu(1, 'Daftar Transaksi', 'daftar-transaksi', null),
                          buildMenu(2, 'My Voucher', 'voucher', null),
                          buildMenu(3, 'My Preference', 'prefs', null),
                          buildMenu(4, 'Ubah Profile', 'ubah-profile', null),
                          buildMenu(5, 'Bagi ke Teman', 'ajak-teman', null),
                        ],
                      ),
                    ),
                    Container(
                      height: 400,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          buildMenu(6, 'Dollan Term & Condition',
                              'term', null),
                          buildMenu(7, 'Contact Us', 'contact-us', null),
                          userid == null
                              ? Container()
                              : buildMenu(8, 'Log Out', 'logout', null),
                          buildMenu(9, 'Version', 'version', null),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
*/
          // ***************************************************************** //

        ],
      );
    });
  }

  Widget buildMenu(int index, String title, String file, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: () {
          switch (index) {
            case 1:
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TransactionHistoryPage()));
              break;
            case 2:
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => VouchersPage()));
              break;
            case 3:
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProfilePrefsPage()));
              break;
            case 4:
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ScopedModel<ProfileModel>(
                        model: ProfileModel(),
                        child: ProfileProfilePage(),
                      )));
              break;
            case 5:
              Share.share('Check out this website : http://www.dollan.id');
              break;
            case 6:
              Navigator.push(context, CustomSlideRoute(page: TosPage()));
              break;
            case 7:
              Navigator.push(context, CustomSlideRoute(page: ContactPage()));
              break;
            case 8:
              _confirmLogout();
              break;
            case 9:
              _showVersion();
              break;
          }
        },
        child: Row(
          children: <Widget>[
            icon!=null? Icon(icon) :
          Image.asset('assets/icons/new/$file.png', scale: 2.5,),
            SizedBox(
              width: 15,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.subtitle,
            )
          ],
        ),
      ),
    );
  }
}
