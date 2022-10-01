import 'dart:convert';

import 'package:dollan/models/home/articles_model.dart';
import 'package:dollan/models/home/bestseller_model.dart';
import 'package:dollan/models/home/mood_model.dart';
import 'package:dollan/models/home/popular_model.dart';
import 'package:dollan/models/home/rekomendasi_model.dart';
import 'package:dollan/models/home/slider_model.dart';
import 'package:dollan/utilities/services.dart';
import 'package:package_info/package_info.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePageModel extends Model {
  List<Section1Item> _section1Items = [];

  List<Section1Item> get section1Items => _section1Items;

  List<SliderItem> _sliders;
  List<PopularItem> _populars;
  List<RekomendasiItem> _rekomendasi;
  List<ArticleItem> _articles;
  List<BestSellerItem> _bestseller;
  List<MoodItem> _moods;

  createSection1Items(){
    _section1Items.add(Section1Item(path: 'https://picsum.photos/id/867/150/70', title: 'Lorem Ipsum Dolor Sit Amet', price: '500000', desc: 'Aenean non mauris et elit aliquet consectetur. Nulla a lacus at eros consectetur sollicitudin consectetur sed tellus.'));
    _section1Items.add(Section1Item(path: 'https://picsum.photos/id/867/150/70', title: 'Lorem Ipsum Dolor Sit Amet', price: '500000', desc: 'Aenean non mauris et elit aliquet consectetur. Nulla a lacus at eros consectetur sollicitudin consectetur sed tellus.'));
    _section1Items.add(Section1Item(path: 'https://picsum.photos/id/867/150/70', title: 'Lorem Ipsum Dolor Sit Amet', price: '500000', desc: 'Aenean non mauris et elit aliquet consectetur. Nulla a lacus at eros consectetur sollicitudin consectetur sed tellus.'));
    _section1Items.add(Section1Item(path: 'https://picsum.photos/id/867/150/70', title: 'Lorem Ipsum Dolor Sit Amet', price: '500000', desc: 'Aenean non mauris et elit aliquet consectetur. Nulla a lacus at eros consectetur sollicitudin consectetur sed tellus.'));
  }

  List<SliderItem> get sliders => _sliders;
  List<PopularItem> get populars => _populars;
  List<RekomendasiItem> get rekomendasi => _rekomendasi;
  List<ArticleItem> get articles => _articles;
  List<BestSellerItem> get bestseller => _bestseller;
  List<MoodItem> get moods => _moods;

  



  Future<List<MoodItem>> getMoods() async {
    print('get mood');
    _moods = null;
    await Services().getMoods().then((res){
      if(res.statusCode == 200){
        List<MoodItem> data = moodResponseFromJson(res.body);
        _moods = data;
//        notifyListeners();

        getSliders();
      }
    });
    return _moods;
  }

  getSliders(){
    print('get slider');
    Services().getSliders().then((res){
      if(res.statusCode == 200){
        var data = sliderResponseFromJson(res.body);
        if(data.success == 'true'){
          _sliders = data.data;

          notifyListeners();

          getPopulars();
        }
      }
    });
  }

  getPopulars(){
    print('get popular');
    Services().getPopular().then((res){
      if(res.statusCode == 200){
        var data = popularResponseFromJson(res.body);
        if(data.success == 'true'){
          _populars = data.data;
          notifyListeners();

          getRekomendasi();
        } else {
          print('data popular gagal');
        }
      } else {
        print('get popular code : ${res.statusCode}');
      }
    });
  }

  getRekomendasi(){
    Services().getRecommendation().then((res){
      if(res.statusCode == 200){
        var data = rekomendasiResponseFromJson(res.body);
        if(data.success == 'true'){
          _rekomendasi = data.data;
          notifyListeners();

          getArticles();
        }
      }
    });
  }

  getArticles(){
    print('get article');
    Services().getArticles().then((res){
      if(res.statusCode == 200){
        var data = articleResponseFromJson(res.body);
        if(data.success == 'true'){
          _articles = data.data;
          notifyListeners();

          getBestSeller();
        }
      }
    });
  }

  getBestSeller(){
    Services().getBestSeller().then((res){
      if(res.statusCode == 200){
        var data = bestSellerResponseFromJson(res.body);
        if(data.success == 'true'){
          _bestseller = data.data;
          notifyListeners();
        }
      }
    });
  }
}

class Section1Item {
  String path;
  String title;
  String price;
  String desc;

  Section1Item({String path, String title, String price, String desc}) {
    this.path = path;
    this.title = title;
    this.price = price;
    this.desc = desc;
  }
}
