import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dollan/models/home/articles_model.dart';
import 'package:dollan/models/home/bestseller_model.dart';
import 'package:dollan/models/home/mood_model.dart';
import 'package:dollan/models/home/popular_model.dart';
import 'package:dollan/models/home/rekomendasi_model.dart';
import 'package:dollan/models/home/slider_model.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:dollan/pages/cat_lainnya.dart';
import 'package:dollan/pages/articles.dart';
import 'package:dollan/templates/DetailArguments.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/templates/list_item.dart';
import 'package:dollan/templates/list_item_col_simple.dart';
import 'package:dollan/templates/list_item_col_simple_card.dart';
import 'package:dollan/templates/list_item_col_simple_stack.dart';
import 'package:dollan/templates/list_item_col_simple_stack_notitle.dart';
import 'package:dollan/templates/list_item_detail.dart';
import 'package:dollan/templates/list_item_image_only.dart';
import 'package:dollan/templates/list_item_row.dart';
import 'package:dollan/templates/list_item_row_desc.dart';
import 'package:dollan/templates/section1.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math';

import 'package:dollan/models/viewmodels/home_model.dart';

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  List<String> urlList = [
    'https://picsum.photos/id/1015/300/150',
    'https://picsum.photos/id/1015/300/150',
    'https://picsum.photos/id/1015/300/150',
    // 'https://picsum.photos/id/867/300/150',
    // 'https://picsum.photos/id/1039/300/150'
  ];

  // List<String> thumbList = ['1015', '1039', '867', '1043'];
  List<String> thumbList = ['1039', '1039', '1039', '1039'];
  List<String> thumbListHits = [
    '1039',
    '1039',
    '1039',
    '1039',
    '1039',
    '1039',
    '1039',
    '1039'
  ];
  int currentSlide = 0;
  int currentSlideInfoGrafis = 0;
  int currentSlidePilihanOperator = 0;
  ScrollController scrollController = ScrollController();
  bool showRest = false;
  String selectedCat = 'Jakarta';
  String username = '';

  //
  List<SliderItem> _sliders = [];
  List<PopularItem> _populars = [];
  List<RekomendasiItem> _rekomendasi = [];
  List<ArticleItem> _articles = [];
  List<BestSellerItem> _bestseller = [];
  List<MoodItem> _moods = [];

  String _versionName = '';

  @override
  void initState() {
    super.initState();

    scrollController.addListener(scrollListener);

//    _init();

    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//    ScopedModel.of<MainModel>(context).initSearch();
  }

  _init() {
    // ScopedModel.of<MainModel>(context).onGetVersionInfo();

    if (mounted) {
      ScopedModel.of<MainModel>(context).getMoods().then((moods) {
        setState(() {
          _moods = moods;
        });
      });
    }

    _getVersion();

    _getSliders();

    _getPopular();

    _getRecommendation();

    _getArticle();

    _getBestSeller();

//   ScopedModel.of<MainModel>(context).addListener(_listener);
    // ScopedModel.of<MainModel>(context).getPopulars();

    Helper().getUserPrefs('username').then((val) {
      if (val != null) {
        if (mounted) {
          setState(() {
            username = ', $val';
          });
        }
      }
    });
  }

  _getVersion() {
    ScopedModel.of<MainModel>(context).onGetVersionInfo().then((version) {
      if (mounted) {
        setState(() {
          _versionName = version;
        });
      }
    });
  }

  _getSliders() {
    ScopedModel.of<MainModel>(context).getSliders().then((items) {
      if (mounted) {
        setState(() {
          _sliders = items;
        });
      }
    });
  }

  _getPopular() {
    ScopedModel.of<MainModel>(context).getPopulars().then((items) {
      if (mounted) {
        setState(() {
          _populars = items;
        });
      }
    });
  }

  _getRecommendation() {
    ScopedModel.of<MainModel>(context).getRekomendasi().then((items) {
      if (mounted) {
        setState(() {
          _rekomendasi = items;
        });
      }
    });
  }

  _getArticle() {
    ScopedModel.of<MainModel>(context).getArticles().then((items) {
      if (mounted) {
        setState(() {
          _articles = items;
        });
      }
    });
  }

  _getBestSeller() {
    ScopedModel.of<MainModel>(context).getBestSeller().then((items) {
      if (mounted) {
        setState(() {
          _bestseller = items;
        });
      }
    });
  }

//  _listener(){
//    if(ScopedModel.of<MainModel>(context).isdone){
//
//      setState(() {
//        _sliders = ScopedModel.of<MainModel>(context).sliders;
//      });
//
//      ScopedModel.of<MainModel>(context).removeListener(_listener);
//      ScopedModel.of<MainModel>(context).init();
//    }
//  }

  _clearSearch() {
    setState(() {
      _searchController.text = "";
    });
  }

  _onSearch(String s) {
    if (s == '') return;

    ScopedModel.of<MainModel>(context).setSearchSearch(_searchController.text);

    Navigator.of(context).pushNamed('categories',
        arguments:
            RouteArguments(search: _searchController.text, page: '', title: s));
  }

  _updateCurrentSlide(int index) {
    setState(() {
      currentSlide = index;
    });
  }

  _updateCurrentSlideInfoGrafis(int index) {
    setState(() {
      currentSlideInfoGrafis = index;
    });
  }

  _updateCurrentSlidePilihanOperator(int index) {
    setState(() {
      currentSlidePilihanOperator = index;
    });
  }

  scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        showRest = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              centerTitle: false,
              titleSpacing: 0,
              title: _top()),
          body:

              // Center(child: Text('ok'),

              CustomScrollView(
            controller: scrollController,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  // _top(),
                  // _version(model),
                  _welcomeText(),
                  _moods != null && _moods.length > 0
                      ? _categories(context, model)
                      : Container(),

                  _sliders != null && _sliders.length > 0
                      ? _slider(context, model)
                      : Container(),
                  _populars != null && _populars.length > 0
                      ? _popular(context, model)
                      : Container(),
                  _rekomendasi != null && _rekomendasi.length > 0
                      ? _recommendation(
                          context, model, 'Rekomendasi Dollan', size)
                      : Container(),
                  showRest
                      ? Column(
                          children: <Widget>[
                            _articles != null && _articles.length > 0
                                ? _community(
                                    context, model, 'Voice of Community')
                                : Container(),
                            _bestseller != null &&
                                    _bestseller.length > 0 != null
                                ? _bestSeller(context, model)
                                : Container(),
                          ],
                        )
                      : Container(),
                  Container(height: 40, color: Colors.white)
                ]),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _top() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Container(
            child: Image.asset('assets/logo-dolan.png'),
            width: 100,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
          ),
          Helper().spacer(),
          Expanded(
            flex: 1,
            child: Card(
              margin: EdgeInsets.all(0),
              child: TextField(
                textInputAction: TextInputAction.done,
                onSubmitted: (s) {
                  print('search submitted: $s');

                  _onSearch(s);
                },
                controller: _searchController,
                onChanged: (d) => print(d),
                decoration: InputDecoration(
                    hintText: 'cari',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _onSearch(_searchController.text);
                      },
                    ),
                    contentPadding: EdgeInsets.only(top: 10, left: 15),
                    // labelText: 'search',
                    border: InputBorder.none),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _version(MainModel model) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Text(
        'ver. $_versionName',
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  Widget _welcomeText() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 10.0, left: 20, right: 20, top: 10),
          child: Text(
            'Apa mood kamu hari ini $username?',
            style: TextStyle(fontSize: 22),
          ),
        ));
  }

  Widget _categories(BuildContext context, MainModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 12),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(7, (pos) {
              MoodItem item = _moods[pos];
              return GestureDetector(
                  onTap: () {
                    if (pos == 6) {
                      model.setSearchCatmod('');
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OtherCatPage()));
                    } else {
                      model.setSearchCatmod(item.dataId);

                      Helper().goToPage(
                          context: context,
                          type: item.linkType,
                          args: RouteArguments(
                              page: '',
                              linkType: item.linkType,
                              id: item.dataId,
                              title: item.title));
                    }

//                    Helper().goToPage(
//                        context: context,
//                        type: item.linkType,
//                        args: RouteArguments(
//                            page: '',
//                            linkType: item.linkType,
//                            id: pos == 6 ? '' : item.dataId,
//                            title: pos == 6 ? 'Lainnya' : item.title));
                  },
                  child:
                      _circle(pos == 6 ? 'Lainnya' : item.title, item.image));
            }),
          )),
    );
  }

  Widget _popular(BuildContext context, MainModel model) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 0, top: 30),
          child: Row(
            children: <Widget>[
              Text(
                'Popular Destination',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: List.generate(_populars.length, (index) {
              PopularItem item = _populars[index];
              return Padding(
                padding: const EdgeInsets.only(left: 6.0, right: 6),
                child: Container(
                  width: 100,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: GestureDetector(
                      onTap: () {
                        // model.setPopularCity(item.dataId);

                        model.setSearchCatmod(item.dataId);

                        Navigator.of(context).pushNamed('categories',
                            arguments: RouteArguments(
                                title: item.title,
                                id: null,
                                type: item.linkType,
                                page: ''));

                        // Helper().goToPage(
                        //     context: context,
                        //     type: item.linkType,
                        //     args: RouteArguments(
                        //         page: '',
                        //         linkType: item.linkType,
                        //         id: item.dataId,
                        //         title: item.title));
                        //  Navigator.of(context).pushNamed('detail', arguments: DetailArguments(false, item.l));
                      },
                      child: ListItemColSimpleStackNoTitle(
                        index: index,
                        image: '${item.image}',
                      ),
                    ),
                  ),
                ),
              );
            })),
          ),
        ),
      ],
    );
  }

  Widget _circle(String title, String img) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[850],
                    offset: Offset(1, 1),
                    blurRadius: 2)
              ],
            ),
            width: 80,
            height: 80,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: title == 'Lainnya'
                    ? Container(
                        child: Center(
                          child: Text('Lainnya'),
                        ),
                        color: Theme.of(context).primaryColor)
                    : img == ''
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.all(0),
                            child: CachedNetworkImage(
                              imageUrl: '$img',
                              fit: BoxFit.cover,
                              placeholder: (context, string) {
                                return Container(
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Image.asset(
                                            'assets/logo-dolan-icon.png'),
                                      ),
                                    ));
                              },
                            ),

                            // Image.network(
                            //   '$img',
                            //   fit: BoxFit.cover,
                            // ),
                          )),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 12,
                color: title == 'Lainnya' ? Colors.white : Colors.grey[600]),
          )
        ],
      ),
    );
  }

  Widget _slider(BuildContext context, MainModel model) {
    return Stack(children: [
      CarouselSlider(
        height: 200,
        viewportFraction: 1.0,
        items: _sliders == null
            ? Container()
            : map<Widget>(_sliders, (index, i) {
                SliderItem item = _sliders[index];
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        Helper().goToPage(
                            context: context,
                            type: item.linkType,
                            args: RouteArguments(
                                page: '',
                                linkType: item.linkType,
                                id: item.dataId,
                                title: item.title));
//                  Navigator.of(context).pushNamed('detail', arguments: DetailArguments(false, item.dataId));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child:

                            // Image.network(
                            //   '${item.image}',
                            //   fit: BoxFit.cover,
                            //   width: MediaQuery.of(context).size.width,
                            // ),

                            CachedNetworkImage(
                          imageUrl: '${item.image}',
                          placeholder: (context, url) => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                    Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
        autoPlay: true,
        aspectRatio: 2.0,
        onPageChanged: (index) {
          _updateCurrentSlide(index);
        },
      ),
      // Positioned(
      //   left: 10,
      //   top: 10,
      //   child: _sliders != null && _sliders.length > 0
      //       ? Text(
      //           '${currentSlide + 1}/${_sliders.length}',
      //           style: Helper().formatText(4),
      //         )
      //       : Container(),
      // ),
      Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 5.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(_sliders, (index, url) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        currentSlide == index ? Colors.orange : Colors.white),
              );
            }),
          ))
    ]);
  }

  Widget _bestSeller(BuildContext context, MainModel model) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 8.0, top: 20),
          child: Row(
            children: <Widget>[
              Text(
                'Best Seller',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        Stack(children: [
          CarouselSlider(
            height: 250,
            viewportFraction: 1.0,
            items: map<Widget>(_bestseller, (index, i) {
              BestSellerItem item = _bestseller[index];
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      Helper().goToPage(
                          context: context,
                          type: item.linkType,
                          args: RouteArguments(
                              page: '',
                              linkType: item.linkType,
                              id: item.dataId,
                              title: item.title));
//                      Navigator.of(context).pushNamed('detail', arguments: DetailArguments(false, item.dataId));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child:

                          // Image.asset(
                          //   '${item.image}',
                          //   fit: BoxFit.cover,
                          //   width: MediaQuery.of(context).size.width,
                          // ),

                          CachedNetworkImage(
                        imageUrl: '${item.image}',
                        placeholder: (context, url) => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
            autoPlay: false,
            aspectRatio: 2.0,
            onPageChanged: (index) {
              _updateCurrentSlideInfoGrafis(index);
            },
          ),
          // Positioned(
          //   left: 10,
          //   top: 10,
          //   child: Text(
          //     '${currentSlideInfoGrafis + 1}/${_bestseller.length}',
          //     style: Helper().formatText(4),
          //   ),
          // ),
          Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 5.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(_bestseller, (index, url) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentSlideInfoGrafis == index
                            ? Colors.orange
                            : Colors.white),
                  );
                }),
              ))
        ]),
      ],
    );
  }

  Widget _recommendation(
      BuildContext context, MainModel model, String title, Size size) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '$title',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10),
            childAspectRatio: 0.5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: 2,
            children: List.generate(_rekomendasi.length, (_index) {
              RekomendasiItem item = _rekomendasi[_index];
              return InkWell(
                onTap: () {
                  Helper().goToPage(
                      context: context,
                      type: item.linkType,
                      args: RouteArguments(
                          page: '',
                          linkType: item.linkType,
                          id: item.dataId,
                          title: item.title));
//                  Navigator.of(context).pushNamed('detail', arguments: DetailArguments(false, item.dataId));
                },
                child: Container(
                  color: Colors.white,
                  child: ListItemDetail(_index, item, size),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _community(BuildContext context, MainModel model, String title) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '$title',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.start,
              ),
              Spacer(),
              // Row(
              //   children: <Widget>[
              //     Text('Lihat Lainnya'),
              //     IconButton(
              //       icon: Icon(
              //         Icons.chevron_right,
              //         size: 30,
              //       ),
              //       onPressed: () {

              //       },
              //       color: Theme.of(context).primaryColor,
              //     ),
              //   ],
              // )
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 10),
              itemCount: _articles.length,
              itemBuilder: (context, pos) {
                ArticleItem item = _articles[pos];
                print('article type: ${item.linkType}');
                return InkWell(
                    onTap: () => Helper().goToPage(
                        context: context,
                        type: item.linkType,
                        args: RouteArguments(
                            page: '',
                            linkType: item.linkType,
                            id: item.dataId,
                            title: item.title)),
                    child: ListItemRowDesc(pos, item));
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context)=>ArticlesPage()
                    )
                  );
                },
                child: Row(
                  children: <Widget>[
                    Text(
                      'Lihat Lainnya',
                      style: Theme.of(context).textTheme.subtitle.apply(fontWeightDelta: 8),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _info(Size size) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: Center(
          child: Container(
            width: size.width - 40,
            height: size.width - 40,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(10)),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/2.jpg',
                      width: size.width - 40,
                      height: size.width - 40,
                      fit: BoxFit.cover,
                    )
                    // CachedNetworkImage(
                    //   imageUrl: 'https://picsum.photos/id/1015/150/150',
                    //   fit: BoxFit.cover,
                    //   width: size.width - 40,
                    // ),
                    ),
                Positioned(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Pilih Paket\nMenakjubkan',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        shadows: <Shadow>[
                          Shadow(offset: Offset(3, 3), blurRadius: 5.0)
                        ]),
                  ),
                )),
                Positioned(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Theme.of(context).primaryColor,
                    elevation: 0,
                    onPressed: () {},
                    child: Text(
                      'Lihat',
                    ),
                  ),
                  bottom: 10,
                  right: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
