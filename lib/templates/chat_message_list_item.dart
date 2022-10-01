import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

var currentUserEmail;

class ChatMessageListItem extends StatelessWidget {
  final DataSnapshot messageSnapshot;
  final Animation animation;
  final String msgFrom;

  ChatMessageListItem({this.messageSnapshot, this.animation, this.msgFrom});

  @override
  Widget build(BuildContext context) {
    
    return new SizeTransition(
      sizeFactor:
          new CurvedAnimation(parent: animation, curve: Curves.decelerate),
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          children:
//          currentUserEmail == messageSnapshot.value['email']

              messageSnapshot.value['msg_from'] == '1'
                  ? getSentMessageLayout()
                  : getReceivedMessageLayout(),
        ),
      ),
    );
  }

  List<Widget> getSentMessageLayout() {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(messageSnapshot.value['client_name'],
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(messageSnapshot.value['msg']),
            ),
          ],
        ),
      ),
      new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Container(
              margin: const EdgeInsets.only(left: 8.0),
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                              child: messageSnapshot.value['msg_from'] == "1"
                    ? Image.network(messageSnapshot.value['client_image'], fit: BoxFit.cover,)

//                              Icon(
//                        Icons.headset,
//                        color: Colors.blue,
//                      )
                    : Image.asset('assets/profile.png',width: 50,),
              ))
//              new CircleAvatar(
//                backgroundImage:
//                    new NetworkImage(messageSnapshot.value['senderPhotoUrl']),
//              )),
        ],
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[
      new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
              margin: const EdgeInsets.only(right: 8.0),
              width: 40,
              height: 40,
              child: messageSnapshot.value['msg_from'] == "0"
                  ? Image.network(messageSnapshot.value['admin_image'], fit: BoxFit.cover,)
                  : Icon(Icons.person))
//              new CircleAvatar(
//                backgroundImage:
//                    new NetworkImage(messageSnapshot.value['senderPhotoUrl']),
//              )),
        ],
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(messageSnapshot.value['admin_name'],
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(messageSnapshot.value['msg']),
            ),
          ],
        ),
      ),
    ];
  }
}
