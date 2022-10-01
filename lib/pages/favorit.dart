import 'dart:convert';
import 'dart:math';

import 'package:dollan/models/list_favorit_response.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/templates/list_item_favorit.dart';
import 'package:dollan/templates/list_item_row.dart';
import 'package:dollan/templates/list_item_row_delete.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  bool busy = false;

  bool loadmore = false;
  ScrollController scrollController = ScrollController();

  int totalItems;
  List<FavoritItem> favorites = [];
  bool belumLogin = false;

  showLoadMore(bool show){
    setState(() {
      loadmore = show;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_)=>_init());
  }

  _delete(String id)async{
    print('delete favorite id: $id');
    var userid = await Helper().getUserPrefs('userid');
    if(userid==null) return;

//    await Services().sendFavorite({'iduser':userid, 'postid':_id, 'action':'$_isFavorite'}).then((res){
//      print('set fav: ${res.body}');
//      if(res.statusCode == 200){
//
//      }
//    });

    await Services().sendFavorite({'iduser':userid,'postid':id, 'action':'false'}).then((res){
      print(res.body);
      if(res.statusCode==200){
          var data = json.decode(res.body);
          if(data['success']=='true'){
            _init();
          }
      }
    });
  }

  _init() async{


    var userid = await Helper().getUserPrefs('userid');
    print(userid);

    if(userid==null) {
      setState(() {
        belumLogin = true;
      });
      return;
    }

    setState(() {
      favorites = [];
      busy = true;
    });

    Services().getListFavorit(userid).then((res) {
      setState(() {
        busy = false;
      });
      if (res.statusCode == 200) {
        ListFavoritResponse response =
        listFavoritResponseFromJson(res.body);
        if (response.success == 'true') {
          setState(() {
            favorites = response.data;
          });
          print(favorites[0].title);
        } else {

        }
      }
    });
  }

  scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        loadmore = true;
        totalItems += 10;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                
              ),
              child: Image.asset('assets/icons/heart.png', scale: 2.5, color: Theme.of(context).primaryColor,)),
          SizedBox(
            width: 10,
          ),
          Text('Favorite', style: Theme.of(context).textTheme.title.apply(fontWeightDelta: 4),)
        ]),
      ),
      body: busy ? Helper().busyIndicator(context, size) : belumLogin ?

      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Tidak ada data favorit.\nLogin terlebih dahulu untuk memilih produk sebagai favorit.', textAlign: TextAlign.center,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text('Login'),
                onPressed: (){
                  Navigator.of(context).pushReplacementNamed('login');
                },
              ),
            )
          ],
        ),
      )

          : favorites==null || favorites.length==0 ?
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Anda belum memiliki item favorit.', textAlign: TextAlign.center,),
          ],
        ),
      )
          : SingleChildScrollView(
              child: Column(
          children: <Widget>[
            ListView.builder(
              controller: scrollController,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: favorites.length,
              itemBuilder: (context, pos) {
                FavoritItem item = favorites[pos];
                return InkWell(
                  onTap: (){
                    Navigator.of(context).pushNamed('detail', arguments:RouteArguments(id: item.id));
                  },
                  child: Card(child: ListItemFavorit(item, _delete)));
              },
            ),
            loadmore ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor,),),)
            ) : Container()
          ],
        ),
      ),
    );
  }
}
