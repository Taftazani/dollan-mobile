import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/detail/detail_product_model.dart';
import 'package:dollan/models/detail/detail_slider_model.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:dollan/pages/child/detail_accomodation.dart';
import 'package:dollan/pages/child/detail_gallery.dart';
import 'package:dollan/pages/child/detail_nearby.dart';
import 'package:dollan/pages/child/detail_others.dart';
import 'package:dollan/pages/child/detail_review.dart';
import 'package:dollan/pages/child/detail_rute.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/utilities/services.dart';
import 'package:dollan/utilities/styles.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/painting.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dollan/models/viewmodels/detail_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class DetailPage extends StatefulWidget {
  DetailPage({this.id});

  final String id;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool showMore = false;
  String showMoreText = 'lebih banyak...';
  bool locationRetrieved = false;
  double lat = 0.0;
  double lng = 0.0;
  double latitude = 0.0;
  double longitude = 0.0;
  ImageConfiguration configuration = ImageConfiguration(devicePixelRatio: 1);
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  double _descHeight = 40;
  String policy = '';
  ScrollController csController = ScrollController();

  TabController tabController;
  int tabIndex = 0;
  int currentSlide = 0;
  int totalSlide = 0;

  List<String> urlList = [];

  List<DetailSliderItem> _sliders = [];

  DetailProductItem _detail;
  String userid;
  String _formattedPrice = '';

  bool _isFavorite;

  List<DetailSliderItem> _detailSliders;

  bool _sliderDone;

  List<dynamic> _importantInfoList;

  var _additionalInfo;

  bool _busy = false;

  bool _infoShowMore = false;

  int _importantInfoLength;

  String _days, _hours;
  List<String> _daysList = [];
  List<String> _hoursList = [];
  String jadwalHariIni = '';
  var namahari = [
    'Minggu',
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu'
  ];
  var indexhari = [6, 0, 1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  _init() async {
    print('page detail');
    // ScopedModel.of<MainModel>(context).initDetail(context, widget.id);
    // ScopedModel.of<MainModel>(context).addListener(_listener);

    initDetail(widget.id);

    String u = await Helper().getUserPrefs('userid');
    if (u != null) {
      setState(() {
        userid = u;
      });
    }

    await Services().getCancellationPolicy().then((res) {
      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        if (body['success'] == 'true') {
          setState(() {
            policy = body['data']['content'];
          });
        }
      }
    });
  }

// Detail
  initDetail(String id) {
    // context = context;
    getFavorite(id);
  }

  getFavorite(String productId) async {
    print('get favorite');

    var userid = await Helper().getUserPrefs('userid');

    print('userid: $userid');

    if (userid == null) {
      _isFavorite = false;
      // notifyListeners();

      getDetailSlider(productId);
      return;
    }

    http.Response res = await Services().getFavorite(userid, productId);
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      print('fav: $body');
      if (body["success"] == "true") {
        var fav = body["data"];
        if (fav == '1') {
          setState(() {
            _isFavorite = true;
          });

          print('is favorite');
        } else {
          setState(() {
            _isFavorite = false;
          });

          print('is NOT favorite');
        }

        // notifyListeners();

        getDetailSlider(productId);
      }
    }
  }

  getDetailSlider(String id) async {
    setState(() {
      _busy = true;
    });

    // notifyListeners();

    http.Response res = await Services().getDetailSlider(id);
    setState(() {
      _busy = false;
    });
    // _busy = false;
    // notifyListeners();

    if (res.statusCode == 200) {
      DetailSliderResponse items = detailSliderResponseFromJson(res.body);
      if (items.success == 'true') {
        setState(() {
          _detailSliders = items.data;
          _sliderDone = true;
        });

        // notifyListeners();

        getDetailProduct(id);
      }
    } else {
      Helper().showAlert(context, 'Gagal mengambil data slider');
    }
  }

  getDetailProduct(String id) async {
    // _busy = true;
    // notifyListeners();
    setState(() {
      _busy = true;
    });

    http.Response res = await Services().getDetailProduct(id);
    // _busy = false;
    // notifyListeners();
    setState(() {
      _busy = false;
    });

    if (res.statusCode == 200) {
//        print('get detail : ${res.body}');

      DetailProductResponse _json = detailProductResponseFromJson(res.body);

      if (_json.success == 'true') {
        setState(() {
          _detail = _json.data;
          print('===> catId: ${_detail.catid}');
        });

        // _detailDone = true;
        // notifyListeners();
        getImportantInfo(id);
      } else {
        Helper().showAlert(context, 'Gagal mengambil data');
      }
    } else {
      // _busy = false;
      // notifyListeners();
      setState(() {
        _busy = false;
      });
      Helper().showAlert(context, 'Gagal mengambil data');
    }
  }

  String convertToDayName(String day){
    switch(day){
      case 'Monday': return 'Senin';
      break;
      case 'Tuesday': return 'Selasa';
      break;
      case 'Wednesday': return 'Rabu';
      break;
      case 'Thursday': return 'Kamis';
      break;
      case 'Friday': return 'Jumat';
      break;
      case 'Saturday': return 'Sabtu';
      break;
      default: return 'Minggu';
      break;
    }
  }

  getImportantInfo(String id) async {
    http.Response res = await Services().getImportantInfo(id);
    print('===================================');
    print('important info: ${res.statusCode}');
    print('===================================');
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      if (body['success'] == 'true') {
        setState(() {
          _importantInfoList = body['data'];
          _importantInfoLength =
              _importantInfoList.length < 8 ? _importantInfoList.length : 8;
        });

        _days = _importantInfoList[0]['hari'];
        _hours = _importantInfoList[0]['jam'];

        _daysList = _days.split(',');
        _hoursList = _hours.split(',');

        // get time
        var today = DateTime.now();
        var dow = today.weekday;
        print('=== today : $dow');
        print('=== today : ${DateFormat('EEEE').format(today)}');
        var namaHari = DateFormat('EEEE').format(today);
        print('=== indexhari : $indexhari');
        var indexDiApi = indexhari[dow];
        print('=== index di api : $indexDiApi');
        var hariDiApi = namahari[indexDiApi];
        // print('=== today : $hariDiApi');

        jadwalHariIni = '${convertToDayName(namaHari)} : ${_hoursList[indexDiApi]}';
        print('jadwalHariIni: $jadwalHariIni');

        getOtherInfo(id);
      }
    } else {
      Helper().showAlert(context, 'Gagal mengambil data slider');
    }
  }

  _showSemuaJadwal() async {
    await showDialog(
        context: context,
        builder: (context) {
          // return Text('ok');

          return Column(
            children: <Widget>[
              AlertDialog(
                content:
                    // Text('ok')
                    SingleChildScrollView(
                        child: Column(
                  children: List.generate(_daysList.length, (pos){
                    return ListTile(
                      title: Row(
                        children: <Widget>[
                          Expanded(child: Text('${_daysList[pos]}')),
                          Text(':'),
                          Expanded(
                            child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('${_hoursList[pos]}'))),
                        ],
                      ),
                    );
                  })
                )

                        //               Container(
                        //                 child: ListView.builder(
                        //   physics: NeverScrollableScrollPhysics(),
                        //   shrinkWrap: true,
                        //   itemCount: _daysList.length,
                        //   itemBuilder: (context,pos){
                        //     return ListTile(
                        //       title: Text('${_daysList[pos]} : ${_hoursList[pos]}'),
                        //     );
                        //   },
                        // ),
                        //               ),
                        ),
              ),
            ],
          );
        });
  }

  getOtherInfo(String id) async {
    http.Response res = await Services().getOtherInfo(id);
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      if (body['success'] == 'true') {
        setState(() {
          _additionalInfo = body['data'][0]['descriptions'];
        });

        // notifyListeners();
      }
    } else {
      Helper().showAlert(context, 'Gagal mengambil data slider');
    }
  }

  //

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // _listener() {
  //   if (ScopedModel.of<MainModel>(context).detailDone) {
  //     setState(() {
  //       _detail = ScopedModel.of<MainModel>(context).detail;
  //       if (_detail.price != null)
  //         _formattedPrice =
  //             Helper().setCurrencyFormat(int.parse(_detail.price));
  //     });
  //   }
  // }

  _addMarker({double lat, double lng}) async {
    MarkerId markerId = MarkerId('01');
    Marker marker = Marker(
        markerId: markerId,
        position: LatLng(lat, lng),
        icon: await BitmapDescriptor.fromAssetImage(
            configuration, 'assets/marker_style_48.png'),
        onTap: null);

    setState(() {
      markers[markerId] = marker;
    });
  }

  updateTabIndex(index) {
    setState(() {
      tabIndex = index;
    });
  }

  _showMoreText() {
    setState(() {
      showMore = !showMore;
      if (showMore) {
        _descHeight = null;
      } else {
        _descHeight = 50;
      }
    });
  }

  updateNearbyStatus({double lat, double lng}) {
    setState(() {
      locationRetrieved = true;
      lat = lat;
      lng = lng;
    });
  }

  _booking(String companyId) async {
    String userid = await Helper().getUserPrefs('userid');
    print('userid: $userid');
    if (userid == null) {
      await Helper()
          .showAlert(context, 'Anda harus login terlebih dahulu')
          .then((_) {
        Navigator.of(context).pushReplacementNamed('login');
      });
    } else {
      Navigator.of(context).pushNamed('booking',
          arguments: RouteArguments(id: widget.id, companyId: companyId));
    }
  }

  scrollToTop() {
    print('====================== scroll to top');
    // csController.jumpTo(0.0);
    setState(() {
      csController.jumpTo(0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return _busy
          ? Container(
              width: size.width,
              height: size.height,
              color: Colors.white,
              child: Center(
                child: Helper().busyIndicator(context, size),
              ),
            )
          : _detail == null
              ? Container()
              : Scaffold(
                  backgroundColor: Colors.white,
                  body: Stack(
                    children: <Widget>[
                      CustomScrollView(
                        controller: csController,
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildListDelegate([
                              Container(
                                  color: Colors.grey[200],
                                  height: size.height * 0.5,
                                  child: _detailSliders != null &&
                                          _detailSliders.length > 0
                                      ? _slider(size, model)
                                      : Container()
                                  // Image.asset(
                                  //   'assets/images/3.jpg',
                                  //   fit: BoxFit.cover,
                                  // ),
                                  ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                            '${_detail.title}',
                                            // '${_detail.title}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        _detail.kabname == null &&
                                                _detail.provname == null
                                            ? Container()
                                            : _detail.kabname != null &&
                                                    _detail.provname == null
                                                ? Text(
                                                    _detail.kabname,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption,
                                                    maxLines: 2,
                                                  )
                                                : _detail.kabname == null &&
                                                        _detail.provname != null
                                                    ? Text(_detail.provname,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption,
                                                        maxLines: 2)
                                                    : Flexible(
                                                        child: Text(
                                                          '${_detail.kabname}, ${_detail.provname}',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .caption,
                                                          maxLines: 2,
                                                        ),
                                                      )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(_detail.price == null
                                            ? ''
                                            : _detail.compname == null
                                                ? ''
                                                : _detail.compname),
                                      ],
                                    ),
                                    Helper().spacer(isVertical: true),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Helper().createStars(
                                          context,
                                          _detail.rating == null ||
                                                  _detail.rating == ''
                                              ? 0
                                              : double.parse(_detail.rating)
                                                  .round()),
                                    ),
                                    Helper().spacer(isVertical: true),
                                    _detail.contentType == 'poi'
                                        ? Container()
                                        : Row(
                                            children: <Widget>[
                                              Text(
                                                Helper().setCurrencyFormat(
                                                    int.parse(_detail.price)),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                              ),
                                            ],
                                          )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                color: Colors.white,
                                // height: 150,
                                child: Column(
                                  children: <Widget>[
                                    ClipRect(
                                      child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Html(
                                            data: showMore
                                                ? _detail.content
                                                : _detail.description,
                                          )),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: FlatButton(
                                        padding: EdgeInsets.all(0),
                                        child: Text(
                                          showMore
                                              ? 'lebih sedikit...'
                                              : 'lebih banyak...',
                                          style: TextStyle(
                                              color: Color(0xff5764fc)),
                                        ),
                                        onPressed: () => _showMoreText(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              _importantInfoList == null ||
                                      _importantInfoList[0]['descriptions'] ==
                                          ''
                                  ? Container()
                                  : _infoPenting(model),

                              _additionalInfo == null || _additionalInfo == ''
                                  ? Container()
                                  : _infoLain(model),

                              // _infoTambahan(),
                              kDebugMode ? Container() : _map(model),
//                              _map(model),
                              DetailAccomodation(
                                id: widget.id,
                                item: _detail,
                                func: scrollToTop,
                              ),
                              // DetailReview(),
                              _detail.contentType == 'poi'
                                  ? Container()
                                  : _cancellation(),
                              // _tabbar(),
                              Container(
                                color: Colors.white,
                                height: 100,
                              )
                            ]),
                          )
                        ],
                      ),
                      Positioned(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: BoxShape.circle),
                                  padding: EdgeInsets.all(8),
                                  child: Image.asset(
                                    'assets/icons/back_bold.png',
                                    scale: 5,
                                  )
//                                  Icon(Icons.arrow_back)
                                  ),
                            ],
                          ),
                        ),
                        left: 10,
                        top: 32,
                      ),
                      Positioned(
                        right: 10,
                        top: 32,
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                if (userid != null) {
                                  if (_isFavorite) {
                                    _isFavorite = false;
                                  } else {
                                    _isFavorite = true;
                                  }
                                  model.setFavorite(widget.id);
                                  setState(() {});
                                }
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: BoxShape.circle),
                                  padding: EdgeInsets.all(8),
                                  child: Image.asset(
                                    _isFavorite
                                        ? 'assets/icons/new/fav-1.png'
                                        : 'assets/icons/new/fav-0.png',
                                    scale: 3,
                                  )

//                                  Icon(
//                                    Icons.favorite,
//                                    size: 20,
//                                    color: _isFavorite
//                                        ? Colors.red
//                                        : Colors.grey,
//                                  )
                                  ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            // GestureDetector(
                            //   onTap: () {},
                            //   child: Container(
                            //       decoration: BoxDecoration(
                            //           color: Theme.of(context).primaryColor,
                            //           shape: BoxShape.circle),
                            //       padding: EdgeInsets.all(8),
                            //       child: Icon(
                            //         Icons.share,
                            //         size: 20,
                            //       )),
                            // ),
                          ],
                        ),
                      ),
                      _detail.contentType == 'poi'
                          ? Container()
                          : Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    border: Border(
                                        top: BorderSide(
                                            color: Colors.grey[300]))),
                                height: 60,
                                child: Row(
                                  children: <Widget>[
                                    Helper().spacer(dist: 30),
                                    Expanded(
                                      flex: 1,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        color: Theme.of(context).primaryColor,
                                        onPressed: () {
                                          _booking(_detail.company);
                                          // Navigator.of(context)
                                          //     .pushNamed('booking', arguments: RouteArguments(id: widget.id, companyId :_detail.company));
                                        },
                                        child: Text('BOOK',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subhead
                                                .apply(fontWeightDelta: 10)),
                                      ),
                                    ),
                                    Helper().spacer(dist: 30),
                                    GestureDetector(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Image.asset(
                                          'assets/icons/new/chat.png',
                                          scale: 2.5,
                                        ),
                                      ),
                                      onTap: () {
                                        _chat(model);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            )
                    ],
                  ));
    });
  }

  _chat(MainModel model) async {
    String userid = await Helper().getUserPrefs('userid');
    print('userid: $userid');
    if (userid == null) {
      await Helper()
          .showAlert(context, 'Anda harus login terlebih dahulu')
          .then((_) {
        Navigator.of(context).pushNamed('login');
      });
    } else {
      Map par = {
        'id': _detail.company,
        'name': _detail.compname,
        'image': _detail.userimage,
      };

      Navigator.of(context)
          .pushNamed('chat', arguments: RouteArguments(map: par));
    }
  }

  Widget _infoPenting(MainModel model) {
    // print('info penting: ${_importantInfoList}');
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: Column(
          children: <Widget>[
            Divider(
              thickness: 0.5,
              color: Colors.grey[700],
            ),
            Row(
              children: <Widget>[
                Text(
                  'Informasi Penting',
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ],
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, top: 8),
                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _importantInfoList[0]['descriptions'] == ''
                        ? Container()
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, top: 0, bottom: 15),
                                child: CachedNetworkImage(
                                  imageUrl: _importantInfoList[0]['icon'],
                                  width: 15,
                                ),
                              ),
                              SizedBox(width: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 0.0, right: 10),
                                child: Container(
                                    // width:
                                    //     MediaQuery.of(context).size.width * 0.6,
                                    child: Text('$jadwalHariIni')
                                    // Html(
                                    //   defaultTextStyle: Theme.of(context)
                                    //       .textTheme
                                    //       .caption
                                    //       .apply(
                                    //           fontSizeDelta:
                                    //               MediaQuery.of(context)
                                    //                       .size
                                    //                       .width *
                                    //                   0.0045,
                                    //           color: Colors.black),
                                    //   data: _importantInfoList[0]['descriptions'],
                                    // ),
                                    ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showSemuaJadwal();
                                },
                                child: Text('Jadwal Lengkap',
                                    style: TextStyle(
                                        color: Color(0xff5764fc),
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
//                      decoration: BoxDecoration(
//                          border: Border(
//                              left: BorderSide(color: Colors.grey[300]))),
                      child: GridView.count(
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                        padding: EdgeInsets.only(left: 0),
                        childAspectRatio:
                            MediaQuery.of(context).size.width * 0.02,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        children: List.generate(_importantInfoLength, (pos) {
                          if (pos == _importantInfoLength - 1) {
                            return Container();
                          }
                          Map<String, dynamic> _item =
                              _importantInfoList[pos + 1];
                          return Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                        child: CachedNetworkImage(
                                      imageUrl: '${_item['icon']}',
                                      width: 15,
                                    )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Text(
                                        '${_item['descriptions']}',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                    _importantInfoList.length <= 8
                        ? Container()
                        : FlatButton(
                            child: Text(
                              _infoShowMore ? 'lebih sedikit' : 'lebih banyak',
                              style: TextStyle(color: Color(0xff5764fc)),
                            ),
                            onPressed: () {
                              if (_infoShowMore) {
                                _infoShowMore = false;
                                _importantInfoLength =
                                    _importantInfoList.length < 8
                                        ? _importantInfoList.length
                                        : 8;
                              } else {
                                _infoShowMore = true;
                                _importantInfoLength =
                                    _importantInfoList.length;
                              }

                              setState(() {});
                            },
                          )
                  ],
                ),
              ),
            ),

            /*
            GridView.count(
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              padding: EdgeInsets.only(left: 20),
              childAspectRatio: 4,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(model.importantInfo.length, (pos) {
                if (pos == model.importantInfo.length - 1) {
                  return Container();
                }
                Map<String, dynamic> _item = model.importantInfo[pos + 1];
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                              width: 20,
                              child: Image.network('${_item['icon']}')),
                          SizedBox(
                            width: 10,
                          ),
                          Text('${_item['descriptions']}')
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
            */

            Divider(
              thickness: 0.5,
              color: Colors.grey[700],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoLain(MainModel model) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
        child: Column(
          children: <Widget>[
            _importantInfoList == null
                ? Divider(
                    thickness: 0.5,
                    color: Colors.grey[700],
                  )
                : Container(),
            Row(
              children: <Widget>[
                Text(
                  'Informasi Tambahan',
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '$_additionalInfo',
                  maxLines: 5,
                  softWrap: true,
                  textAlign: TextAlign.left,
                )),
            Divider(
              thickness: 0.5,
              color: Colors.grey[700],
            ),
          ],
        ),
      ),
    );
  }

  Widget _map(MainModel model) {
    _gotoMyPlace({double lat, double lng}) async {
      setState(() {
        latitude = lat;
        longitude = lng;
      });
      _addMarker(lat: lat, lng: lng);
      final GoogleMapController controller = await _controller.future;

      controller.moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 15.0)));
    }

    _openMap({double lat, double lng}) async {
      String googleUrl =
          'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      } else {
        throw 'Could not open the map.';
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            height: 200,
            child: GoogleMap(
              padding: EdgeInsets.all(10),
              scrollGesturesEnabled: false,
              initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude), zoom: 15.0),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);

                var mylat = double.parse(_detail.latitude);
                var mylong = double.parse(_detail.longitude);

                print('===> lat: $mylat, lng: $mylong');

                _gotoMyPlace(lat: mylat, lng: mylong);
              },
              markers: Set<Marker>.of(markers.values),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                Icon(
//                  Icons.map,
//                  size: 20,
//                ),
                Image.asset(
                  'assets/icons/new/map.png',
                  scale: 2.5,
                ),
                SizedBox(
                  width: 5,
                ),
                Text('Buka Peta'),
              ],
            ),
            onPressed: () {
              _openMap(
                  lat: double.parse(_detail.latitude),
                  lng: double.parse(_detail.longitude));
            },
          )
        ],
      ),
    );
  }

  Widget _slider(Size size, MainModel model) {
    return Stack(children: [
      CarouselSlider(
        height: size.height * 0.5,
        viewportFraction: 1.0,
        items: map<Widget>(_detailSliders, (index, i) {
          DetailSliderItem item = _detailSliders[index];
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                child:

                    // Image.asset(
                    //   'assets/images/${index + 1}.jpg',
                    //   fit: BoxFit.cover,
                    //   width: MediaQuery.of(context).size.width,
                    // ),
                    item.images == ''
                        ? Container()
                        : CachedNetworkImage(
                            imageUrl: '${item.images}',
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
              );
            },
          );
        }).toList(),
        autoPlay: false,
        aspectRatio: 2.0,
        onPageChanged: (index) {
          // _updateCurrentSlide(index);
          setState(() {
            currentSlide = index;
          });
        },
      ),
      // Positioned(
      //   top: 38,
      //   left: 50,
      //   child: Padding(
      //     padding: const EdgeInsets.only(left: 8.0),
      //     child: Container(
      //       decoration: BoxDecoration(
      //           color: Colors.black,
      //           borderRadius: BorderRadius.all(Radius.circular(20))),
      //       padding: EdgeInsets.only(left: 8, top: 2, bottom: 2, right: 8),
      //       child: _detailSliders != null
      //           ? Text(
      //               '${currentSlide + 1}/${_detailSliders.length}',
      //               style: TextStyle(
      //                   color: Theme.of(context).primaryColor, fontSize: 16),
      //             )
      //           : Container(),
      //     ),
      //   ),
      // ),
      Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 5.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(_detailSliders, (index, url) {
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

  Widget _cancellation() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return SafeArea(
                  minimum: EdgeInsets.all(32),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Cancelation Policy',
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .apply(color: Colors.red),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        ),
                        Helper().spacer(isVertical: true, dist: 50),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Html(
                              data: policy,
                            ),
                          ),
                        )
                        // Text('${Helper().dummyText}'),
                      ],
                    ),
                  ),
                );
              });

          // showDialog(context: context, builder: (context){
          //   return Material(
          //     color: Colors.blue,
          //     child: Padding(
          //       padding: const EdgeInsets.all(20.0),
          //       child: Container(
          //         width: MediaQuery.of(context).size.width*0.8,
          //       child: Padding(
          //         padding: const EdgeInsets.all(12.0),
          //         child: Text('${Helper().dummyText}'),
          //       ),
          //   ),
          //     ),
          //   );

          // AlertDialog(
          //   content: Column(children: <Widget>[
          //     Text('${Helper().dummyText}')
          //   ],),
          // );
          // });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(border: Border.all(color: Colors.red)),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.info_outline, color: Colors.red),
                  Text(
                    'Cancelation Policy',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  // Text('Pembatalan dapat dilakukan jika terjadi kesalahan info...'),
                  // Helper().spacer(isVertical: true),
                  // GestureDetector(child: Text('Lihat Review Lainnya...', style: TextStyle(color: Colors.blue),), onTap: (){},)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
