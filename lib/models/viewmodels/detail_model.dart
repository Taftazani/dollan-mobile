import 'dart:convert';

import 'package:dollan/models/detail/detail_product_model.dart';
import 'package:dollan/models/detail/detail_slider_model.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';

class DetailModel extends Model {
  bool _getLocation = false;
  double _lat = 0.0;
  double _lng = 0.0;

  bool get getLocation => _getLocation;
  double get lat => _lat;
  double get lng => _lng;

  bool _busy = false;
  bool get busy => _busy;

  String _id;
  BuildContext context;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  List<DetailSliderItem> _sliders = [];
  List<DetailSliderItem> get sliders => _sliders;

  DetailProductItem _detail;
  DetailProductItem get detail => _detail;

  bool _haveDetail = false;
  bool get haveDetail => _haveDetail;

  bool _sliderDone = false;
  bool get sliderDone => _sliderDone;

  bool _detailDone = false;
  bool get detailDone => _detailDone;



  init(BuildContext context, String id) {
    context = context;
    _id = id;
    getFavorite(_id);
  }

  getFavorite(String productId) async{

    print('get favorite');

    var userid = await Helper().getUserPrefs('userid');

    print('userid: $userid');

    if(userid == null) {
      getSlider();
      return;
    }

    await Services().getFavorite(userid, productId).then((res){
      if(res.statusCode==200){
        var body = json.decode(res.body);
        print('fav: $body');
        if(body["success"]=="true"){
          var fav = body["data"];
          if(fav == '1'){
            _isFavorite = true;
          } else {
            _isFavorite = false;
          }

          notifyListeners();

          getSlider();
        }
      }
    });

  }

  getSlider() {
    _busy = true;
    notifyListeners();

    Services().getDetailSlider(_id).then((res) {
      // _busy = false;
      // notifyListeners();

      if (res.statusCode == 200) {
        DetailSliderResponse items = detailSliderResponseFromJson(res.body);
        if (items.success == 'true') {
          _sliders = items.data;
          _sliderDone = true;
          notifyListeners();

          getDetailProduct();
        }
      } else {
        Helper().showAlert(context, 'Gagal mengambil data slider');
      }
    });
  }

  getDetailProduct() {
    // _busy = true;
    // notifyListeners();

    Services().getDetailProduct(_id).then((res) {
      _busy = false;
      notifyListeners();

      if (res.statusCode == 200) {

//        print('get detail : ${res.body}');
        
        DetailProductResponse _json = detailProductResponseFromJson(res.body);

        

        if (_json.success == 'true') {
          _detail = _json.data;
          _detailDone = true;
          notifyListeners();
          // _haveDetail = true;
          // notifyListeners();

          // var s = detailProductResponseToJson(_json);
          // print('detail: $s');
        } else {
          Helper().showAlert(context, 'Gagal mengambil data');
        }
      } else {
        _busy = false;
      notifyListeners();
        Helper().showAlert(context, 'Gagal mengambil data');
      }
    });
  }

  updateLocationStatus({double lat, double lng}) {
    _lat = lat;
    _lng = lng;
    _getLocation = true;
    notifyListeners();
  }

  setFavorite() async {
    _isFavorite = !_isFavorite;
    notifyListeners();

    var userid = await Helper().getUserPrefs('userid');

    if(userid == null) return;

    await Services().sendFavorite({'iduser':userid, 'postid':_id, 'action':'$_isFavorite'}).then((res){
      print('set fav: ${res.body}');
      if(res.statusCode == 200){

      }
    });

  }


}
