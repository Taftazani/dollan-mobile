import 'package:dollan/models/catmood/cat_mood_response.dart';
import 'package:dollan/models/home/mood_model.dart';
import 'package:dollan/models/viewmodels/categories_model.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:dollan/models/viewmodels/search_model.dart';
import 'package:dollan/pages/search.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/templates/list_item.dart';
import 'package:dollan/templates/list_item_category.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CategoriesPage extends StatefulWidget {
  CategoriesPage(this.args);

  // CategoriesPage({this.title, this.id, this.type, this.search, this.adventure, this.price, this.kota, this.page, this.catmod});

  // final String title;
  // final String id;
  // final String type;
  // final String search;
  // final String adventure;
  // final String price;
  // final String kota;
  // final int page;
  // final String catmod;
  final RouteArguments args;

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  ScrollController scrollController = ScrollController();
  int totalItems = 10;
  int scrollLimitCounter = 0;
  bool showBackToTop = false;
  bool loadmore = false;
  List<MoodItem> moods = [];
  bool filterResult = false;

  String currentId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(scrollListener);
//     WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
     _init();
  }

  _init() async {
    print('**** INIT *****');
    print('arguments: ${widget.args}');

    currentId = widget.args.id;

    // await ScopedModel.of<MainModel>(context).initCategories();
    await ScopedModel.of<MainModel>(context).getContent();
  }

  scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        totalItems += 10;
        scrollLimitCounter += 1;
      });
    }

    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        scrollLimitCounter -= 1;
      });
    }

    if (scrollLimitCounter > 2) {
      setState(() {
        showBackToTop = true;
      });
    } else {
      setState(() {
        showBackToTop = false;
      });
    }
  }

  _sortContent(String sort) async {
    // await ScopedModel.of<MainModel>(context).getContent(
    //   RouteArguments(id: currentId, page: '', sort: sort)
    // );
    await ScopedModel.of<MainModel>(context).sortContent(sort);
  }

  _onBack()async{
    print('on back');
    await ScopedModel.of<MainModel>(context).resetSearch();
    await ScopedModel.of<MainModel>(context).initCategories();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return WillPopScope(
        onWillPop: (){
          _onBack();
        },
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  leading: Helper().backButton(context),
                  title: model.categories==null?Text('') : Text('${widget.args.title} (${model.categories.length})', style: TextStyle(color: Color(0xff221f1f)),),
                ),
                body:
                model.busy
                    ? Helper().busyIndicator(context, size)
                    :  model.categories == null || model.categories.length == 0
                    ? Helper().noData(size)
                    : 
                    
                    SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            // _categories(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: GridView.count(
                                controller: scrollController,
                                padding: EdgeInsets.only(top: 10),
                                childAspectRatio: 0.5,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                                crossAxisCount: 2,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: List.generate(model.categories.length,
                                    (_index) {
                                  CatMoodItem item = model.categories[_index];
                                  return Container(
                                    color: Colors.white,
                                    child: GestureDetector(
                                        onTap: () {
                                          print('kat item id : ${item.id}');
                                          Navigator.of(context).pushNamed(
                                              'detail',
                                              arguments:
                                                  RouteArguments(id: item.id));
                                          // Navigator.of(context)
                                          //     .pushNamed('detail', arguments: false);

                                          // Helper().goToPage(context: context, type: item., id: item.dataId);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          // child: Text('ok')
                                          child: ListItemCategory(item, size),
                                        )),
                                  );
                                }),
                              ),
                            ),
                            loadmore
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),

                // floatingActionButton: showBackToTop
                //     ? FloatingActionButton(
                //       backgroundColor: Theme.of(context).primaryColor,
                //         onPressed: () {},
                //         child: Icon(Icons.arrow_upward, color: Colors.black,),
                //       )
                //     : Container(),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton:
                    // model.categories.length == 0
                    //     ? Container()
                    //     :

                    // filterResult == false && model.categories.length == 0
                    //     ? Container()
                    //     : 
                        // filterResult == true && model.categories.length == 0
                        //     ? Container()
                        //     : 
                            Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    // _filter(context, model),
                                    GestureDetector(
                                      onTap: () async {
                                        // await 
                                        // Navigator.of(context).pushNamed(
                                        //     'search',
                                        //     arguments: RouteArguments(
                                        //         title: widget.args.title));
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context)=>SearchPage())
                                        );
                                        setState(() {
                                          filterResult = true;
                                        });
                                        model.useFilter(context, widget.args.title);
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.only(left: 20, right: 20),
                                        height: 35,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color(0x33000000),
                                                  spreadRadius: 1,
                                                  blurRadius: 3,
                                                  offset: Offset(0, 3)),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color:
                                                Theme.of(context).primaryColor),
                                        child: Center(
                                            child: Row(
                                          children: <Widget>[
                                            Icon(Icons.filter_list),
                                            Text('Filter',
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                                          ],
                                        )),
                                      ),
                                    ),
                                    _sort(context)
                                  ],
                                ),
                              ),
              ),
      );
    });
  }

  _showSortOptions() async {
    var sort;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 100,
                  width: 300,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: <Widget>[
                      // Text('ooo')
                      InkWell(
                          onTap: () {
                            sort = 'price';
                            Navigator.pop(context);
                          },
                          child: ListTile(
                            title: Text(
                              'Harga',
                              style: Helper().formatText(3),
                            ),
                          )),
                      InkWell(
                        onTap: () {
                          sort = 'star';
                          Navigator.pop(context);
                        },
                        child: ListTile(
                            title: Text(
                          'Rating',
                          style: Helper().formatText(3),
                        )),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
    _sortContent(sort);
  }

  

  Widget _sort(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showSortOptions();
      },
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        height: 35,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color(0x33000000),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 3)),
            ],
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(context).primaryColor),
        child: Center(
            child: Row(
          children: <Widget>[
            Icon(Icons.sort, ),
            Text('Sort', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
          ],
        )),
      ),
    );
  }
}
