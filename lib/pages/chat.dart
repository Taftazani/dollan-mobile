import 'dart:async';
import 'dart:io';

// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:dollan/models/detail/detail_product_model.dart';
import 'package:dollan/models/profile/profile_data_model.dart';
import 'package:dollan/models/profile/profile_model.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
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

class ChatPage extends StatefulWidget {
  ChatPage({this.map, this.title});
  final Map map;
  final String title;

  @override
  ChatPageState createState() {
    return new ChatPageState();
  }
}

class ChatPageState extends State<ChatPage> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  bool _isComposingMessage = false;
  DatabaseReference reference;
  DatabaseReference operatorRef =
      FirebaseDatabase.instance.reference().child('history');

  String userId;

  String _name, _image, _id;

  ProfileData profileData;
  var adadata;

  StreamSubscription<Event> onAddListener;
  var historyRef;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    reference = reference.child('messages').child('3').child(userId);

    // WidgetsBinding.instance.addPostFrameCallback((_) => _init());
    _init();
  }

  _init() async {
    userId = await Helper().getUserPrefs('userid');
    profileData = await ScopedModel.of<MainModel>(context).getProfile(userId);

    if (widget.map == null) {
      _id = '1';
      _name = 'Admin Dollan';
      _image = null;
    } else {
      _id = widget.map['id'];
      _name = widget.map['name'];
      _image = widget.map['image'];
    }

    reference = FirebaseDatabase.instance
        .reference()
        .child('messages')
        .child(_id)
        .child(userId);

    // print('reference: ${reference.once()}');

    // var data = await reference.once();

    // onAddListener = reference.onChildAdded.listen(onChildAdded);

    var data = await reference.once();
    setState(() {
      adadata = data.value;
    });

    historyRef = await operatorRef.child(userId).child(_id).once();
    operatorRef.child(userId).child(_id).update({'unread_messages': 0});
    // onAddListener = operatorRef.child(userId).child(_id).onValue.listen(onUpdateData);
  }

  // void onUpdateData(Event event) async{
  //   print('onUpdateData: ${event.snapshot.value['unread_messages']}');
  //   int total = event.snapshot.value['unread_messages'];
  //   if(total==null){
  //     total = 0;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: widget.map == null
          ? null
          : AppBar(
              title: Text(
                  widget.title == null ? 'Chat dengan Operator' : widget.title),
            ),
      body: Container(
        child: new Column(
          children: <Widget>[
            new Flexible(
              child: reference == null
                  ? Helper().busyIndicator(context, size)
                  : FirebaseAnimatedList(
                      query: reference,
                      padding: const EdgeInsets.all(8.0),
                      reverse: true,
                      sort: (a, b) => b.key.compareTo(a.key),
                      //comparing timestamp of messages to check which one would appear first
                      itemBuilder: (_, DataSnapshot messageSnapshot,
                          Animation<double> animation, int index) {
                        // Update read status to TRUE
                        String _key = messageSnapshot.key;
                        reference.child(_key).update({'read': true});

                        // if (historyRef.value != null) {
                        //   if (historyRef.value['unread_messages'] != null &&
                        //       historyRef.value['unread_messages'] > 0) {
                        //     int total = historyRef.value['unread_messages'];

                        //     operatorRef
                        //         .child(userId)
                        //         .child(_id)
                        //         .update({'unread_messages': total - 1});
                        //   }
                        // }

                        return ChatMessageListItem(
                          messageSnapshot: messageSnapshot,
                          animation: animation,
                        );
                      },
                    ),
            ),
            new Divider(height: 1.0),
            new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
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

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Send"),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
          color: _isComposingMessage
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              // new Container(
              //   margin: new EdgeInsets.symmetric(horizontal: 4.0),
              //   child: new IconButton(
              //       icon: new Icon(
              //         Icons.photo_camera,
              //         color: Theme.of(context).accentColor,
              //       ),
              //       onPressed: () async {
              //         await _ensureLoggedIn();
              //         File imageFile = await ImagePicker.pickImage();
              //         int timestamp = new DateTime.now().millisecondsSinceEpoch;
              //         StorageReference storageReference = FirebaseStorage
              //             .instance
              //             .ref()
              //             .child("img_" + timestamp.toString() + ".jpg");
              //         StorageUploadTask uploadTask =
              //             storageReference.putFile(imageFile);
              //         Uri downloadUrl = (await uploadTask.future).downloadUrl;
              //         _sendMessage(messageText: null, imageUrl: null);
              //       }),
              // ),
              new Flexible(
                child: new TextField(
                  controller: _textEditingController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isComposingMessage = messageText.length > 0;
                    });
                  },
                  onSubmitted: _textMessageSubmitted,
                  decoration: new InputDecoration.collapsed(
                      hintText: "Tulis pesan disini"),
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? getIOSSendButton()
                    : getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });

    if (_ensureLoggedIn()) {
      _sendMessage(messageText: text, imageUrl: null);
    }
  }

  void _sendMessage({String messageText, String imageUrl}) async {
    print('send message to: $_id');
    // Map _admin = {
    //   'admin_id': widget.detail.company,
    //   'admin_image': widget.detail.userimage,
    //   'admin_name': widget.detail.compname,
    // };

    FocusScope.of(context).requestFocus(new FocusNode());

    // int total = 0;
    // var ref = await operatorRef.child(userId).child(_id).once();
    // print('ref: ${ref.value}');
    // if (ref.value != null) {
    //   if (ref.value['unread_messages'] != null) {
    //     total = int.parse(ref.value['unread_messages']);
    //   }
    // }

    // if (_id != '1') {
    operatorRef.child(userId).child(_id).set({
      'admin_id': _id,
      'admin_image': _image,
      'admin_name': _name,
      // 'unread_messages': '${total + 1}'
    });
    // }

    String _key = reference.push().key;
    reference.push().set({
      // 'key':_key,
      'admin_id': _id,
      'admin_image': _image,
      'admin_name': _name,
      'msg': messageText,
      'client_id': userId,
      'client_name': profileData.firstname,
      'client_image': profileData.imageuser,
      'date_time': DateTime.now().toString(),
      'msg_from': '1',
      'read': false
    });

    // analytics.logEvent(name: 'send_message');
  }

  // Future<Null> _ensureLoggedIn() async {
  //   GoogleSignInAccount signedInUser = googleSignIn.currentUser;
  //   if (signedInUser == null)
  //     signedInUser = await googleSignIn.signInSilently();
  //   if (signedInUser == null) {
  //     await googleSignIn.signIn();
  //     analytics.logLogin();
  //   }

  //   currentUserEmail = googleSignIn.currentUser.email;

  //   if (await auth.currentUser() == null) {
  //     GoogleSignInAuthentication credentials =
  //         await googleSignIn.currentUser.authentication;
  //     await auth.signInWithGoogle(
  //         idToken: credentials.idToken, accessToken: credentials.accessToken);
  //   }
  // }

  bool _ensureLoggedIn() {
    return true;
  }

  // Future _signOut() async {
  //   await auth.signOut();
  //   googleSignIn.signOut();
  //   Scaffold.of(_scaffoldContext)
  //       .showSnackBar(new SnackBar(content: new Text('User logged out')));
  // }
}
