import 'package:dollan/models/profile/profile_model.dart';
import 'package:dollan/models/viewmodels/cart_model.dart';
import 'package:dollan/models/viewmodels/home_model.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:dollan/pages/cart.dart';
import 'package:dollan/pages/favorit.dart';
import 'package:dollan/pages/home.dart';
import 'package:dollan/pages/profile.dart';
import 'package:dollan/pages/tour_map.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:dollan/models/viewmodels/map_model.dart';

/*
class Parent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.white,
          body:


          TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              ScopedModel<HomePageModel>(
                child: HomePage(),
                model: HomePageModel(),
              ),
              FavoritePage(),
              ScopedModel<CartModel>(
                child: CartPage(),
                model: CartModel(),
              ),
              ProfilePage(),
            ],
          ),

          bottomNavigationBar: TabBar(
//            controller: tabController,
            onTap: (index) {
//              updateTabIndex(index);
            },
            tabs: <Widget>[
              Tab(
                child: Image.asset('assets/icons/home.png',
                    width: 50,
                    scale: 2.5,
                    ),
              ),
              // Tab(
              //   child:Image.asset('assets/icons/map.png', width: 50, scale:2.5, color: tabIndex == 1 ? Theme.of(context).primaryColor : Colors.grey[400]),
              // ),
              Tab(
                child: Image.asset('assets/icons/heart.png',
                    width: 50,
                    scale: 2.5,
                ),
              ),

              Tab(
                  child: Image.asset('assets/icons/cart.png',
                      width: 50,
                      scale: 2.5,
                      ),),
              Tab(
                child: Image.asset('assets/icons/user.png',
                    width: 50,
                    scale: 2.5,
                )
              ),
            ],
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey[400],
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Theme.of(context).primaryColor,
          ),
        ),
      );
    });

  }
}
*/



class Parent extends StatefulWidget {
  Parent({this.viewCart=false, this.tabIndex});
  bool viewCart;
  int tabIndex;

  @override
  _ParentState createState() => _ParentState();
}

class _ParentState extends State<Parent> with AutomaticKeepAliveClientMixin{
  TabController tabController;
  int tabIndex = 0;

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_)=>_init());
  }

  @override
  void didChangeDependencies(){

  }

  _init(){
    updateTabIndex(widget.tabIndex);
//    tabController.animateTo(widget.tabIndex);
  }

  updateTabIndex(index) {
    setState(() {
      tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
    ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.white,
          body:

          tabIndex == 0
              ? ScopedModel<HomePageModel>(
                  child: HomePage(),
                  model: HomePageModel(),
                )
              : tabIndex == 1
                  ? FavoritePage()
                  : tabIndex == 2
                      ? ScopedModel<CartModel>(
                          child: CartPage(),
                          model: CartModel(),
                        )
                      : ScopedModel<ProfileModel>(
            model: ProfileModel(),
            child: ProfilePage(),
          ),


//          TabBarView(
//            physics: NeverScrollableScrollPhysics(),
//            children: <Widget>[
//              ScopedModel<HomePageModel>(
//                child: HomePage(),
//                model: HomePageModel(),
//              ),
//              FavoritePage(),
//              ScopedModel<CartModel>(
//                child: CartPage(),
//                model: CartModel(),
//              ),
//              ProfilePage(),
//            ],
//          ),

          bottomNavigationBar: TabBar(
            controller: tabController,
            onTap: (index) {
              updateTabIndex(index);
            },

            tabs: <Widget>[
              Tab(
                child: Image.asset('assets/icons/home.png',
                    width: 50,
                    scale: 2.5,
                    color: tabIndex == 0
                        ? Colors.black
                        : Colors.grey[400]),
              ),
              // Tab(
              //   child:Image.asset('assets/icons/map.png', width: 50, scale:2.5, color: tabIndex == 1 ? Theme.of(context).primaryColor : Colors.grey[400]),
              // ),
              Tab(
                child: Image.asset('assets/icons/heart.png',
                    width: 50,
                    scale: 2.5,
                    color: tabIndex == 1
                        ? Colors.black
                        : Colors.grey[400]),
              ),

              Tab(
                  child: Image.asset('assets/icons/new/cart.png',
                      width: 50,
                      scale: 2.5,
                      color: tabIndex == 2
                          ? Colors.black
                          : Colors.grey[400])),
              Tab(
                child: Image.asset('assets/icons/user.png',
                    width: 50,
                    scale: 2.5,
                    color: tabIndex == 3
                        ? Colors.black
                        : Colors.grey[400]),
              ),
            ],
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey[400],
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
//            indicatorColor: Theme.of(context).primaryColor,
            indicatorColor: Colors.white,
          ),
        ),
      );
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


