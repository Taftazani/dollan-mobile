import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dollan/models/auth_model.dart';
import 'package:dollan/models/booking/cart_response.dart';
import 'package:dollan/models/catmood/cat_mood_response.dart';
import 'package:dollan/models/city_response.dart';
import 'package:dollan/models/detail/detail_product_model.dart';
import 'package:dollan/models/detail/detail_slider_model.dart';
import 'package:dollan/models/home/articles_model.dart';
import 'package:dollan/models/home/bestseller_model.dart';
import 'package:dollan/models/home/mood_model.dart';
import 'package:dollan/models/home/popular_model.dart';
import 'package:dollan/models/home/rekomendasi_model.dart';
import 'package:dollan/models/home/slider_model.dart';
import 'package:dollan/models/profile/profile_data_model.dart';
import 'package:dollan/models/propinsi_response.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info/package_info.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dollan/utilities/services.dart';
import 'package:dollan/utilities/apis.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

class MainModel extends Model {
  ProfileData _profileData;

  MainModel._internal();
  static MainModel _instance;

  static MainModel get instance {
    if (_instance == null) {
      _instance = MainModel._internal();
    }
    return _instance;
  }

  bool sorting = false;
  bool _userLoggedIn = false;
  bool _busy = false;
  String _username = 'belum ada';

  bool _dev = false;

  bool get userLoggedIn => _userLoggedIn;

  bool get busy => _busy;

  String get username => _username;

  BuildContext context;

  TextEditingController searchKotaController = TextEditingController();

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  // Home
  List<SliderItem> _sliders;
  List<PopularItem> _populars;
  List<RekomendasiItem> _rekomendasi;
  List<ArticleItem> _articles;
  List<BestSellerItem> _bestseller;
  List<MoodItem> _moods;

  List<CatMoodItem> _categories = [];
  CatMoodResponse _catMoodResponse;
  CatMoodResponse get catMoodResponse => _catMoodResponse;
  List<CatMoodItem> get categories => _categories;

  List<dynamic> _importantInfoList;
  List<dynamic> get importantInfo => _importantInfoList;

  String _additionalInfo;
  String get additionalInfo => _additionalInfo;

  int _adventure = 0;
  String _price = '0,0';
  double _slideValue = 0.0;
  String _slideValuePrice = '0,0';
  String _kota = '';
  String _propinsi = '';
  String _provinceId;
  String _cityId;
  String _search = '';
  String _sort = '';
  List<PropinsiResponse> _provinces = [];
  List<CityResponse> _cities = [];
  List<CityResponse> _citiesFiltered = [];
  List<bool> _moodStates = [];

  int get adventure => _adventure;
  String get price => _price;
  double get slideValue => _slideValue;
  String get slideValuePrice => _slideValuePrice;
  String get propinsi => _propinsi;
  String get kota => _kota;
  List<bool> get moodStates => _moodStates;
  String get sort => _sort;
  // List<MoodItem> get moods => _moods;
  // bool get busy => _busy;
  String get cityId => _cityId;
  String get provinceId => _provinceId;
  List<CityResponse> get cities => _cities;
  List<CityResponse> get citiesFiltered => _citiesFiltered;
  String get search => _search;
  List<PropinsiResponse> get provinces => _provinces;

  // Home get
  List<SliderItem> get sliders => _sliders;

  List<PopularItem> get populars => _populars;

  List<RekomendasiItem> get rekomendasi => _rekomendasi;

  List<ArticleItem> get articles => _articles;

  List<BestSellerItem> get bestseller => _bestseller;

  List<MoodItem> get moods => _moods;

  bool _isdone = false;

  bool get isdone => _isdone;

  bool _slidersDone = false;

  bool get slidersDone => _slidersDone;

  bool _moodDone = false;

  bool get moodDone => _moodDone;

  String _userid;

  String get userid => _userid;

  bool get devMode => _dev;

  String _id;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  List<DetailSliderItem> _detailSliders = [];
  List<DetailSliderItem> get detailSliders => _detailSliders;

  DetailProductItem _detail;
  DetailProductItem get detail => _detail;

  bool _haveDetail = false;
  bool get haveDetail => _haveDetail;

  bool _sliderDone = false;
  bool get sliderDone => _sliderDone;

  bool _detailDone = false;
  bool get detailDone => _detailDone;

  bool _getLocation = false;
  double _lat = 0.0;
  double _lng = 0.0;

  bool get getLocation => _getLocation;
  double get lat => _lat;
  double get lng => _lng;
//  bool _slidersDone = false;
//  bool get slidersDone => _slidersDone;

  String _searchSearch;
  String get searchSearch => _searchSearch;
  String _searchCatmod;
  String get searchCatmod => _searchCatmod;
  String _searchAdventure;
  String get searchAdventure => _searchAdventure;
  String _searchKota;
  String get searchKota => _searchKota;
  String _searchSort;
  String get searchSort => _searchSort;

  RouteArguments args;

  int _totalPurchase = 0;
  int get totalPurchase => _totalPurchase;
  List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;
  bool get getCartDone => _getCartDone;
  bool _getCartDone = false;

  init(BuildContext context, String id) {
    print('init');
    _isdone = false;
    _slidersDone = false;
    _moodDone = false;
    notifyListeners();

    // context = context;
    // _id = id;
    // getFavorite(_id);

    // onGetVersionInfo();
  }

  String _versionCode, _versionName;

  String versionName() => _versionName;
  String versionCode() => _versionCode;

  Future<String> onGetVersionInfo() async {
    _versionName = '';
    await PackageInfo.fromPlatform().then((res) {
      _versionCode = res.buildNumber;
      _versionName = res.version;
      // notifyListeners();
      print('version name: $_versionName');
    });
    return _versionName;
  }

  Future<bool> checkUser(BuildContext context) async {
    _busy = true;
    notifyListeners();

    _userLoggedIn = false;

    var user = await Helper().getUserPrefs('userid');

    if (user != null) {
      _busy = false;
      notifyListeners();

      _userLoggedIn = true;
      notifyListeners();

      _userid = user;

      var s = await Helper().getUserPrefs('username');
      print('username: $s');
    } else {
      _busy = false;
      notifyListeners();
      _userLoggedIn = false;
    }

    return _userLoggedIn;
  }

  Future<ProfileData> getProfile(String userid) async {
    print('get profile');
    _busy = true;
    notifyListeners();

    await Services().getProfile(userid).then((res) {
      _busy = false;
      notifyListeners();

//      print(res.body);

      if (res.statusCode == 200) {
        ProfileDataModel profileDataModel = profileDataModelFromJson(res.body);
        if (profileDataModel.success == 'true') {
          _profileData = profileDataModel.data;

          notifyListeners();
        }
      }
    });

    return _profileData;
  }

  saveUserPrefs(String s) async {
    Helper().saveUserPrefs('username', s);
  }

  setFcm() async {
    var userid = await Helper().getUserPrefs('userid');
    await _saveDeviceToken(userid);
  }

  loginNative(BuildContext context, Map authData) async {
    _busy = true;
    notifyListeners();

    await Services().loginNative(authData).then((res) {
      _busy = false;
      notifyListeners();
      // print(json.decoderes.body);
      if (res.statusCode == 200) {
        AuthResponse response = authResponseFromJson(res.body);
        if (response.success == 'true') {
          Helper().saveUserPrefs('userid', response.data.userId);
          Helper().saveUserPrefs('username', response.data.firstname);

          setFcm();
          Navigator.of(context).pushNamedAndRemoveUntil(
              'survey', (Route<dynamic> route) => false);
        } else {
          Helper().showAlert(context, 'Data tidak ditemukan.');
        }
      } else {
        // show alert
        Helper().showAlert(context, 'Gagal memverifikasi data.');
      }
    }).catchError((err) {
      _busy = false;
      notifyListeners();

      print('login native error: $err');
      Helper().showAlert(context, err.toString());
    });
  }

  loginGoogle(BuildContext context, Map authData) async {
    _busy = true;
    notifyListeners();

    http.Response res = await Services().loginGoogle(authData);

    print('=== login google ===');
    print(res.body);

    if (res.statusCode == 200) {
      // success
      var data = json.decode(res.body);

      // print('$data');
      // print('call api getinbro/google, dapet photo : ');
      // print('${data['data']['photo']}');

      if (data['success'] == "true") {
        print('userid login: ${data['data']['UserId']}');
        await Helper().saveUserPrefs('userid', data['data']['UserId']);
        await Helper().saveUserPrefs('username', data['data']['name']);
        _busy = false;
        notifyListeners();

        setFcm();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('survey', (Route<dynamic> route) => false);
      } else {
        Helper().showAlert(
            context, 'Gagal otentikasi user. Coba beberapa saat lagi.');
      }
    } else {
      // show alert
      _busy = false;
      notifyListeners();
      Helper().showAlert(
          context, 'Gagal otentikasi user. Coba beberapa saat lagi.');
    }
  }

  loginFb(BuildContext context, Map authData) async {
    _busy = true;
    notifyListeners();

    await Services().loginFb(authData).then((res) {
      if (res.statusCode == 200) {
        // success
        var data = json.decode(res.body);
        if (data['success'] == "true") {
          print('login fb: $data');

          Helper().saveUserPrefs('username', data['data']['name']);
          Helper().saveUserPrefs('userid', data['data']['UserId']);

          _busy = false;
          notifyListeners();

          setFcm();
          Navigator.of(context).pushNamedAndRemoveUntil(
              'survey', (Route<dynamic> route) => false);
        } else {
          Helper().showAlert(
              context, 'Gagal otentikasi user. Coba beberapa saat lagi.');
        }

        print('---------------------------');
        print('login fb success : ${data['UserId']}');
        print('---------------------------');
      } else {
        // show alert
        _busy = false;
        notifyListeners();
        Helper().showAlert(
            context, 'Gagal otentikasi user. Coba beberapa saat lagi.');
      }
    }).catchError((err) {
      _busy = false;
      notifyListeners();

      print('login native error: $err');
    });
  }

  _saveDeviceToken(String userid) async {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    String fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      ref.child('users').child(userid).set({
        'token': fcmToken,
      });
    }
  }

  // Home
  Future<List<MoodItem>> getMoods() async {
    print('get mood');
    _moods = [];
    await Services().getMoods().then((res) {
      if (res.statusCode == 200) {
        var data = moodResponseFromJson(res.body);
        _moods = data;
//        notifyListeners();
//
        getSliders();
      }
    });
    return _moods;
  }

  getMoodsFromCategories() async {
    print('get mood');
    await Services().getMoods().then((res) {
      // print(res.body);
      if (res.statusCode == 200) {
        List<MoodItem> data = moodResponseFromJson(res.body);
        print(data);
        _moods = data;
        notifyListeners();
      }
    });
  }

  Future<List<SliderItem>> getSliders() async {
    print('get slider');
    _sliders = [];
    await Services().getSliders().then((res) {
      if (res.statusCode == 200) {
        var data = sliderResponseFromJson(res.body);
        if (data.success == 'true') {
          _sliders = data.data;
          _isdone = true;
        }
      }
    });
    return _sliders;
  }

  Future<List<PopularItem>> getPopulars() async {
    print('get popular');
    _populars = [];
    await Services().getPopular().then((res) {
      if (res.statusCode == 200) {
        var data = popularResponseFromJson(res.body);
        if (data.success == 'true') {
          _populars = data.data;
//          notifyListeners();
//          getRekomendasi();
        } else {
          print('data popular gagal');
        }
      } else {
        print('get popular code : ${res.statusCode}');
      }
    });
    return _populars;
  }

  Future<List<RekomendasiItem>> getRekomendasi() async {
    _rekomendasi = [];
    await Services().getRecommendation().then((res) {
      if (res.statusCode == 200) {
        var data = rekomendasiResponseFromJson(res.body);
        if (data.success == 'true') {
          _rekomendasi = data.data;
//          notifyListeners();
//          getArticles();
        }
      }
    });
    return _rekomendasi;
  }

  Future<List<ArticleItem>> getArticles() async {
    print('get article');
    _articles = [];
    await Services().getArticles().then((res) {
      if (res.statusCode == 200) {
        var data = articleResponseFromJson(res.body);
        if (data.success == 'true') {
          _articles = data.data;
//          notifyListeners();
//          getBestSeller();
        }
      }
    });
    return _articles;
  }

  Future<List<BestSellerItem>> getBestSeller() async {
    _bestseller = [];
    await Services().getBestSeller().then((res) {
      if (res.statusCode == 200) {
        var data = bestSellerResponseFromJson(res.body);
        if (data.success == 'true') {
          _bestseller = data.data;
          notifyListeners();
        }
      }
    });
    return _bestseller;
  }

  // Cart
  

  getItems(BuildContext context) async {
    context = context;
    _busy = true;
    notifyListeners();

    _cartItems = [];
//    _cartItemsToSend = null;

    String userid = await Helper().getUserPrefs('userid');

    if (userid != null) {
      http.Response res = await Services().getCart(userid);

      CartResponse cartResponse = cartResponseFromJson(res.body);
      if (cartResponse.success == 'true') {
//        _cartItemsToSend = cartResponse.data;
        _cartItems = cartResponse.data;
        notifyListeners();

        print(_cartItems);

        _getCartDone = true;
        notifyListeners();

        _busy = false;
        notifyListeners();
      } else {
        print('--error');
        _busy = false;
        notifyListeners();
      }
    } else {
      print('error');
      _busy = false;
      notifyListeners();
    }
  }

  updateTotalPurchase({int idx, int price}) {
    _getCartDone = false;
    notifyListeners();

    _totalPurchase = 0;

    for (int i = 0; i < _cartItems.length; i++) {
      List<Paket> paket = _cartItems[i].paket;
      for (int j = 0; j < paket.length; j++) {
        var sub = 0;
        var _price = int.parse(paket[j].price);
        var _qty = int.parse(paket[j].qty);
        sub = _price * _qty;
        print(sub);
        _totalPurchase += sub;
      }
    }

    print('_totalPurchase: $_totalPurchase');
    notifyListeners();
  }

  updateCart({int cartPos, int paketPos, int qty}) {
    _cartItems[cartPos].paket[paketPos].qty = '$qty';
    updateTotalPurchase();
  }

  deleteCartItem({String id, int position}) async {
    print('delete item cart id: $id');
    _busy = true;
    notifyListeners();
    // bool success = false;

    var userid = await Helper().getUserPrefs('userid');

    await Services().deleteCartItem({'id': id, 'iduser': userid}).then((res) {
      _busy = false;
      notifyListeners();

      print('delete item : ${res.statusCode}');

      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        if (body["success"] == 'true') {
          // success = true;
          // _cartItems.removeAt(position);
          getItems(context);
//          notifyListeners();
        }
      }
    }).catchError((err) {
      _busy = false;
      notifyListeners();
      print('delete item error: $err');
    });

//    print('delete item : $success');
    _busy = false;
    notifyListeners();

    // return success;
  }
  //

  // Detail
  initDetail(BuildContext context, String id) {
    context = context;
    _id = id;
    getFavorite(id);
  }

  getFavorite(String productId) async {
    print('get favorite');

    var userid = await Helper().getUserPrefs('userid');

    print('userid: $userid');

    if (userid == null) {
      _isFavorite = false;
      notifyListeners();

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
          _isFavorite = true;
          print('is favorite');
        } else {
          _isFavorite = false;
          print('is NOT favorite');
        }

        notifyListeners();

        getDetailSlider(productId);
      }
    }
  }

  getDetailSlider(String id) async {
    _busy = true;
    notifyListeners();

    http.Response res = await Services().getDetailSlider(id);
    // _busy = false;
    // notifyListeners();

    if (res.statusCode == 200) {
      DetailSliderResponse items = detailSliderResponseFromJson(res.body);
      if (items.success == 'true') {
        _detailSliders = items.data;
        _sliderDone = true;
        notifyListeners();

        getDetailProduct(id);
      }
    } else {
      Helper().showAlert(context, 'Gagal mengambil data slider');
    }
  }

  getDetailProduct(String id) async {
    // _busy = true;
    // notifyListeners();

    http.Response res = await Services().getDetailProduct(id);
    _busy = false;
    notifyListeners();

    if (res.statusCode == 200) {
//        print('get detail : ${res.body}');

      DetailProductResponse _json = detailProductResponseFromJson(res.body);

      if (_json.success == 'true') {
        _detail = _json.data;
        // _detailDone = true;
        notifyListeners();
        getImportantInfo(id);
      } else {
        Helper().showAlert(context, 'Gagal mengambil data');
      }
    } else {
      _busy = false;
      notifyListeners();
      Helper().showAlert(context, 'Gagal mengambil data');
    }
  }

  getImportantInfo(String id) async {
    http.Response res = await Services().getImportantInfo(id);
    print('important info: ${res.body}');
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      if (body['success'] == 'true') {
        _importantInfoList = body['data'];
        print('_importantInfoList: ${_importantInfoList[0]['descriptions']}');
        notifyListeners();

        getOtherInfo(id);
      }
    } else {
      Helper().showAlert(context, 'Gagal mengambil data slider');
    }
  }

  getOtherInfo(String id) async {
    http.Response res = await Services().getOtherInfo(id);
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      if (body['success'] == 'true') {
        _additionalInfo = body['data'][0]['descriptions'];
        notifyListeners();
      }
    } else {
      Helper().showAlert(context, 'Gagal mengambil data slider');
    }
  }

  updateLocationStatus({double lat, double lng}) {
    _lat = lat;
    _lng = lng;
    _getLocation = true;
    notifyListeners();
  }

  setFavorite(String productId) async {
    _isFavorite = !_isFavorite;
    notifyListeners();

    var userid = await Helper().getUserPrefs('userid');

    if (userid == null) return;

    await Services().sendFavorite({
      'iduser': userid,
      'postid': productId,
      'action': '$_isFavorite'
    }).then((res) {
      print('set fav: ${res.body}');
      if (res.statusCode == 200) {}
    });
  }

  // Categories

  // List<MoodItem> _moods = [];

  // bool _busy = false;

  initCategories() {
    _searchCatmod = '';
    _searchSearch = '';
    _sort = '';
    // notifyListeners();
  }

  initSearch() {
    print('===> init search');
    _adventure = 0;
    _slideValue = 0;
    _adventure = 0;
    _price = '0,0';
    _slideValuePrice = '0,0';
    _cityId = '';
    _kota = 'Pilih Kota';
    _propinsi = 'Mengambil data propinsi...';
    notifyListeners();

    getSearchMoods();
  }

  resetSearch() {
    print('===> reset search');
    _adventure = 0;
    _slideValue = 0;
    _adventure = 0;
    _price = '0,0';
    _slideValuePrice = '0,0';
    _cityId = '';
    _kota = 'Pilih Kota';
    _propinsi = 'Mengambil data propinsi...';
  }

  getContent() async {
    print('get content city: $_cityId');

    RouteArguments ra = RouteArguments(
        page: '',
        id: _searchCatmod,
        adventure: _adventure == 0 ? '' : _adventure.toString(),
        search: _searchSearch,
        price: _price == '0,0' ? '' : _price,
        kota: _cityId == null ? '' : _cityId,
        sort: _sort == null ? '' : _sort);

    _busy = true;
    notifyListeners();

    await Services().getCatMood(ra).then((res) {
      _busy = false;
      notifyListeners();

      if (res.statusCode == 200) {
        _catMoodResponse = catMoodResponseFromJson(res.body);
        _categories = catMoodResponse.data;
        notifyListeners();
      } else {
        print(res.statusCode);
      }
    }).catchError((err) {
      _busy = false;
      notifyListeners();
    });
  }

  sortContent(String sort) async {
    _sort = sort;

    print('sort: $sort');
    getContent();

    // RouteArguments ra = RouteArguments(
    //     id: _searchCatmod,
    //     adventure: _adventure == 0 ? '' : _adventure.toString(),
    //     search: _searchSearch,
    //     price: _price.toString(),
    //     kota: _cityId == null ? '' : _cityId,
    //     sort: _sort == null ? '' : _sort);

    // _busy = true;
    // notifyListeners();
    // await Services().getCatMood(ra).then((res) {
    //   _busy = false;
    //   notifyListeners();

    //   if (res.statusCode == 200) {
    //     _catMoodResponse = catMoodResponseFromJson(res.body);
    //     _categories = catMoodResponse.data;
    //     notifyListeners();
    //     print(_categories);
    //   } else {
    //     print(res.statusCode);
    //   }
    // }).catchError((err) {
    //   _busy = false;
    //   notifyListeners();
    // });
  }

  setAdventure(int par) {
    _adventure = par;
    _slideValue = _adventure.toDouble();
    notifyListeners();
  }

  setPrice(int start, int end) {
    _price = '$start,$end';
    print('_price: $_price');
    _slideValuePrice = '$start,$end';
    notifyListeners();
  }

  setSearchSearch(String s) {
    _searchSearch = s;
  }

  setSearchCatmod(String s) {
    _searchCatmod = s;
  }

  // setAdventure(String s) {
  //   _searchAdventure = s;
  // }

  set searchKota(String s) {
    _searchKota = s;
  }

  // setPropinsi(String id, int pos) {
  //   print('propinsi : $id');
  //   _provinceId = id;
  //   _propinsi = _provinces[pos].name;
  //   notifyListeners();

  //   getKota(provinceId);
  // }

  setKota(String id, int pos) {
    _cityId = id;
    _kota = _cities[pos].name;
    notifyListeners();
  }

  setMood(int i) {
    _moodStates[i] = !_moodStates[i];
    notifyListeners();
  }

  setPopularCity(String id) {
    _cityId = id;
  }

  getSearchMoods() async {
    await Services().getActivities().then((res) {
//      print(res.body);
      if (res.statusCode == 200) {
        var data = moodResponseFromJson(res.body);
        _moods = data;
        notifyListeners();

        fillMoodState();

        // getPropinsi();
        getKota();
      }
    });
  }

  getPropinsi() async {
    await Services().getPropinsi().then((res) {
      if (res.statusCode == 200) {
        _provinces = propinsiResponseFromJson(res.body);
        _propinsi = 'Pilih Propinsi';
        notifyListeners();
        // print('propinsi dapet');
      }
    });
  }

  getKota() async {
    _kota = 'Mengambil data kota...';
    notifyListeners();

    await Services().getKota().then((res) {
      if (res.statusCode == 200) {
        var data = cityResponseFromJson(res.body);
        _cities = data;
        // _citiesFiltered = _cities;
        _kota = _cities[0].name;
        notifyListeners();
      }
    });
  }

  updateFilter(String s) {
    print('cari: $s');
    _citiesFiltered = _cities;
    notifyListeners();

    List<CityResponse> _temp = [];
    if (s != "" || s.isNotEmpty) {
      for (var i = 0; i < _cities.length; i++) {
        if (_cities[i].name.toLowerCase().contains(s.toLowerCase())) {
          _temp.add(_cities[i]);
          print('----> added');
        }
      }
      _citiesFiltered = _temp;
      notifyListeners();
    }
  }

  fillMoodState() {
    for (int i = 0; i < _moods.length; i++) {
      _moodStates.add(false);
      notifyListeners();
    }
  }

  useFilter(BuildContext context, String title) {
    var moodstring = "";
    // if (_searchCatmod == 0 &&
    //     searchSearch == '' &&
    //     _cityId == '' &&
    //     moodstring == '') return;
    for (int i = 0; i < _moodStates.length; i++) {
      if (_moodStates[i] == true) {
        moodstring += '${_moods[i].dataId},';
      }
    }

    if (moodstring.isNotEmpty) {
      moodstring = moodstring.substring(0, moodstring.length - 1);
      _searchCatmod = moodstring;
    }

    // Navigator.of(context).pushReplacementNamed('categories',
    //     arguments: RouteArguments(
    //         page: '',
    //         id: moodstring == '' ? _searchCatmod : moodstring,
    //         search: searchSearch,
    //         adventure: _adventure == 0 ? '' : _adventure.toString(),
    //         price: _price == 0 ? '' : _price.toString(),
    //         kota: cityId,
    //         title: title));

    // args = RouteArguments(
    //     page: '',
    //     id: moodstring == '' ? _searchCatmod : moodstring,
    //     search: _searchSearch,
    //     adventure: _adventure == 0 ? '' : _adventure.toString(),
    //     price: _price.toString(),
    //     kota: cityId,
    //     title: title);

    getContent();
  }

  resetFilter() {
    initSearch();
    // _searchCatmod = '';
    // _searchSearch = '';
    // _slideValue = 0;
    // _adventure = 0;
    // _price = 0;
    // _slideValuePrice = 0;
    // _cityId = '';
    for (int i = 0; i < _moodStates.length; i++) {
      _moodStates[i] = false;
    }
    notifyListeners();
  }
}
