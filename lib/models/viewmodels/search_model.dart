import 'dart:convert';

import 'package:dollan/models/city_response.dart';
import 'package:dollan/models/home/mood_model.dart';
import 'package:dollan/models/propinsi_response.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/utilities/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchModel extends Model {
  int _adventure = 1;
  int _price = 100000;
  double _slideValue = 1.0;
  double _slideValuePrice = 0.0;
  String _kota = '';
  String _propinsi = '';
  String _provinceId;
  String _cityId;
  String _search = '';
  List<PropinsiResponse> _provinces = [];
  List<CityResponse> _cities = [];
  List<CityResponse> _citiesFiltered = [];
  List<bool> _moodStates = [];
  List<MoodItem> _moods = [];

  bool _busy = false;

  int get adventure => _adventure;
  int get price => _price;
  double get slideValue => _slideValue;
  double get slideValuePrice => _slideValuePrice;
  String get propinsi => _propinsi;
  String get kota => _kota;
  List<bool> get moodStates => _moodStates;
  List<MoodItem> get moods => _moods;
  bool get busy => _busy;
  String get cityId => _cityId;
  String get provinceId => _provinceId;
  List<CityResponse> get cities => _cities;
  List<CityResponse> get citiesFiltered => _citiesFiltered;
  String get search => _search;
  List<PropinsiResponse> get provinces => _provinces;

  init() {
    _slideValue = 1;
    _slideValuePrice = 100000;
    _kota = 'Pilih Kota';
    _propinsi = 'Mengambil data propinsi...';
    notifyListeners();

    getMoods();
  }

  setAdventure(int par) {
    _adventure = par;
    _slideValue = _adventure.toDouble();
    notifyListeners();
  }

  setPrice(int p) {
    _price = p;
    _slideValuePrice = _price.toDouble();
    notifyListeners();
  }

  // setPropinsi(String id, int pos) {
  //   print('propinsi : $id');
  //   _provinceId = id;
  //   _propinsi = _provinces[pos].name;
  //   notifyListeners();

  //   getKota();
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

  getMoods() async {
    await Services().getActivities().then((res) {
//      print(res.body);
      if (res.statusCode == 200) {
        var data = moodResponseFromJson(res.body);
        _moods = data;
        notifyListeners();

        fillMoodState();

        getPropinsi();
      }
    });
  }

  getPropinsi() async {
    await Services().getPropinsi().then((res) {
      if (res.statusCode == 200) {
        _provinces = propinsiResponseFromJson(res.body);
        _propinsi = 'Pilih Propinsi';
        notifyListeners();
        print('propinsi dapet');
      }
    });
  }

  getKota() async {
    _kota = 'Mengambil data kota...';
    notifyListeners();

    http.Response res = await Services().getKota();
    if (res.statusCode == 200) {
      var data = cityResponseFromJson(res.body);

      _cities = data;
      _citiesFiltered = _cities;
      _kota = _cities[0].name;

      notifyListeners();
    }
  }

  updateFilter(String s) {
    _citiesFiltered = _cities;
    var _temp = [];
    if (s != "" || !s.isEmpty) {
      for (var i = 0; i < _cities.length; i++) {
        if (_cities[i].name.toLowerCase().contains(s.toLowerCase())) {
          _temp.add(_cities[i]);
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
    for (int i = 0; i < _moodStates.length; i++) {
      if (_moodStates[i] == true) {
        moodstring += '${_moods[i].dataId},';
      }
    }

    if (moodstring.isNotEmpty) {
      moodstring = moodstring.substring(0, moodstring.length - 1);
    }

    print('--->>> Filter:');
    print('--->>> mood:$moodstring');
    print('--->>> adventure:$_adventure');
    print('--->>> price:$_price');
    print('--->>> kota:$_cityId');
    print('--->>> /Filter:');

    Navigator.of(context).pushReplacementNamed('categories',
        arguments: RouteArguments(
            page: '',
            id: moodstring,
            search: _search,
            adventure: _adventure.toString(),
            price: _price.toString(),
            kota: cityId,
            title: title));
  }
}

class Params {
  String search;
  String catmod;
  String adventure;
  String price;
  int page;

  Params({this.search, this.catmod, this.adventure, this.price, this.page});
}
