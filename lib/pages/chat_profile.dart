import 'package:dollan/pages/chat.dart';
import 'package:dollan/pages/chat_list.dart';
import 'package:dollan/templates/profile_template.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:flutter/material.dart';

class ChatProfilePage extends StatefulWidget {
  @override
  _ChatProfilePageState createState() => _ChatProfilePageState();
}

class _ChatProfilePageState extends State<ChatProfilePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ProfileBackground(
          top: 0.88,
        ),
        buildScaffold()
      ],
    );
  }

  Scaffold buildScaffold() {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: Helper().backButton(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Chat'),
        ),
        body: Column(
          children: <Widget>[
            TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(color: Colors.black),
              controller: tabController,
              tabs: <Widget>[
                Tab(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 5,),
                      Image.asset('assets/icons/new/chat-admin.png', scale: 3.5,),
                      Text('Admin Dollan', style: Theme.of(context).textTheme.caption,),

                    ],
                  ),
//                  icon: Icon(Icons.person),

                ),
                Tab(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 5,),
                        Image.asset('assets/icons/new/chat-operator.png', scale: 3.5,),
                        Text('Daftar Chat Operator', style: Theme.of(context).textTheme.caption,),
                      ],
                    ),
                )

              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: <Widget>[ChatPage(), ChatListPage()],
              ),
            )
          ],
        ));
  }
}
