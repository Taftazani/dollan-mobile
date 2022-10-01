import 'dart:async';
import 'dart:io';

// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:dollan/models/detail/detail_product_model.dart';
import 'package:dollan/models/profile/profile_data_model.dart';
import 'package:dollan/models/profile/profile_model.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dollan/templates/chat_message_list_item.dart';
import 'package:scoped_model/scoped_model.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:image_picker/image_picker.dart';

var _scaffoldContext;

class ChatListPage extends StatefulWidget {
  // ChatListPage({this.detail});
  // final DetailProductItem detail;

  @override
  ChatListPageState createState() {
    return new ChatListPageState();
  }
}

class ChatListPageState extends State<ChatListPage> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  bool _isComposingMessage = false;
  DatabaseReference reference;
  Query query;
  int userType = 1; // 0 = cs, 1 = user
  String username = 'User'; // CS , User
  Icon icon = Icon(Icons.person); // headset / person
  String userId;
  List<Map> operatorList = List();
  List<Map> list = List();

  ProfileData profileData;

  TextEditingController searchCtrl = TextEditingController();
  String filter = "";

  StreamSubscription<Event> onAddListener;
  StreamSubscription<Event> onChangeListener;

  @override
  void initState() {
    super.initState();

    searchCtrl.addListener(() {
      updateFilter(searchCtrl.text);
    });

    

    

    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  _init() async {
    userId = await Helper().getUserPrefs('userid');
    profileData = await ScopedModel.of<MainModel>(context).getProfile(userId);
    reference = FirebaseDatabase.instance.reference().child('history').child(userId);

    // checkMessages(false);
    // Query firebase
    query = reference.orderByChild('admin_name');
    onAddListener = query.onChildAdded.listen(onAddEntry);
  }

  checkMessages(bool isback){
    if(isback){
      print('is back');
      operatorList = [];
    }
    // Query firebase
    query = reference.orderByChild('admin_name');
    onAddListener = query.onChildAdded.listen(onAddEntry);
  }

  void onAddEntry(Event event) {
    // print('---- onAddEntry: ${event.snapshot}');
    if(event.snapshot.value['admin_id'] == '1') return;
    Map<String, dynamic> item = {
      'id': event.snapshot.value['admin_id'],
      'name': event.snapshot.value['admin_name'],
      'image': event.snapshot.value['admin_image'],
      'unread': event.snapshot.value['unread_messages']==null?0:event.snapshot.value['unread_messages'],
    };
    setState(() {
      operatorList.add(item);
      list = operatorList;
    });
  }

  updateUser(int type) {
    setState(() {
      userType = type;
      username = type == 0 ? 'CS' : 'User';
      icon = type == 0 ? Icon(Icons.headset) : Icon(Icons.person);
      print('--->> user type: $userType');
    });
  }

  updateFilter(String s) {
    list = operatorList;
    List<Map> _temp = [];
    if (s != "" || s.isNotEmpty) {
      for (var i = 0; i < operatorList.length; i++) {
        if (operatorList[i]['name'].toLowerCase().contains(s.toLowerCase())) {
          _temp.add(operatorList[i]);
        }
      }
      setState(() {
        list = _temp;
      });
    } else {
      setState(() {
        list = operatorList;
      });
    }
  }

  @override
  dispose() {
    super.dispose();
    searchCtrl.dispose();
    onAddListener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Daftar Chat'),
      // ),
      body: Container(
        child: new Column(
          children: <Widget>[
            // Filter Search
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  labelStyle: TextStyle(color: Colors.grey),
                  labelText: 'Cari Operator',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                ),
                controller: searchCtrl,
              ),
            ),
            new Flexible(
                child: operatorList == null
                    ? Container()
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, pos) {
                          return ListTile(
                            contentPadding: EdgeInsets.all(10),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: list[pos]['image']==null? null: DecorationImage(
                                    image: NetworkImage(list[pos]['image']),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            title: Text(list[pos]['name']),
                            trailing: 
                            list[pos]['unread']==null||list[pos]['unread']==0?Container(width: 1, height: 1,) :

                            Container(
                              width: 10,
                              height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            )
                          ),
                            
                            // Chip(
                            //   label: Text(list[pos]['unread']==null?'0':'${list[pos]['unread']}', style: TextStyle(color: Colors.white),),
                            //   backgroundColor: Colors.red,
                            // ),
                            onTap: () async{
                              Map par = {
                                'id': list[pos]['id'],
                                'name': list[pos]['name'],
                                'image': list[pos]['image']
                              };
                              await Navigator.of(context).pushNamed('chat',
                                  arguments: RouteArguments(
                                      map: par, title: list[pos]['name']));
                              checkMessages(true);
                            },
                          );
                        },
                      )

                // buildFirebaseAnimatedList(context),
                ),
            // new Divider(height: 1.0),
            // new Container(
            //   decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            //   child: _buildTextComposer(),
            // ),
            new Builder(builder: (BuildContext context) {
              _scaffoldContext = context;
              return new Container(width: 0.0, height: 0.0);
            })
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? new BoxDecoration(
                border: new Border(
                    top: new BorderSide(
                color: Colors.grey[200],
              )))
            : null,
      ),
    );
  }

  FirebaseAnimatedList buildFirebaseAnimatedList(BuildContext context) {
    return FirebaseAnimatedList(
      query: reference,
      padding: const EdgeInsets.all(8.0),
      // reverse: true,
      // sort: (a, b) => b.key.compareTo(a.key),
      //comparing timestamp of messages to check which one would appear first
      itemBuilder: (_, DataSnapshot messageSnapshot,
          Animation<double> animation, int index) {
        // DatabaseReference _ref = FirebaseDatabase.instance.reference().child(messageSnapshot.key);
        String _name = messageSnapshot.value['admin_name'];
        return _name.contains(searchCtrl.text)
            ? ListTile(
                contentPadding: EdgeInsets.all(10),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image:
                            NetworkImage(messageSnapshot.value['admin_image']),
                        fit: BoxFit.cover),
                  ),
                ),
                title: Text(_name),
                onTap: () {
                  DetailProductItem item = DetailProductItem();
                  item.company = messageSnapshot.value['admin_id'];
                  item.compname = messageSnapshot.value['admin_name'];
                  item.userimage = messageSnapshot.value['admin_image'];
                  Navigator.of(context).pushNamed('chat',
                      arguments:
                          RouteArguments(detail: item, title: item.compname));
                },
              )
            : Container();

        // ChatMessageListItem(
        //     messageSnapshot: messageSnapshot,
        //     animation: animation,
        //     username: username);
      },
    );
  }
}
