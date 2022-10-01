import 'dart:convert';

import 'package:dollan/models/booking/cart_response.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:dollan/pages/cart.dart';
import 'package:dollan/templates/booking_item.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class CartModel extends Model {
  int _totalPurchase = 0;

  bool _busy = false;

  bool get busy => _busy;

  bool _getCartDone = false;
  bool _deleteCartItemDone = false;

  bool get deleteCartItemDone => _deleteCartItemDone;

  bool get getCartDone => _getCartDone;

  List<CartItem> _cartItemsToSend = [];
  List<CartItem> _cartItems = [];

  int get totalPurchase => _totalPurchase;

  List<CartItem> get cartItems => _cartItems;
  BuildContext context;

  init() {
    _getCartDone = false;
    _deleteCartItemDone = false;
    _busy = false;
    notifyListeners();
  }

  getItems(BuildContext context) async {
    context = context;
    _busy = true;
    notifyListeners();

    _cartItems = null;
    _cartItemsToSend = null;

    String userid = await Helper().getUserPrefs('userid');

    if (userid != null) {
      http.Response res = await Services().getCart(userid);

      CartResponse cartResponse = cartResponseFromJson(res.body);
      if (cartResponse.success == 'true') {
//        _cartItemsToSend = cartResponse.data;
        _cartItems = cartResponse.data;
        notifyListeners();

        _getCartDone = true;
        notifyListeners();

        _busy = false;
        notifyListeners();
      } else {
        _busy = false;
        notifyListeners();
      }
    } else {
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

// deleteCartItem({String id, int position}) async{
//     print('delete item');
//     _busy = true;
//     notifyListeners();
//     // bool success = false;

//     var userid =  await Helper().getUserPrefs('userid');

//       await Services().deleteCartItem({'id': id, 'iduser': userid}).then((res) {
//         _busy = false;
//         notifyListeners();

//         print('delete item : ${res.statusCode }');

//         if (res.statusCode == 200) {
//           var body = json.decode(res.body);
//           if (body["success"] == 'true') {
//             // success = true;
//             // getItems(null);
//             // _cartItems.removeAt(position);
//             // notifyListeners();
//             // MainModel().getCartItems(userid);
//             // _getCartDone = true;
//         notifyListeners();
//           }
//         }
//       }).catchError((err){
//         _busy = false;
//         notifyListeners();
//         print('delete item error: $err');
//       });

// //    print('delete item : $success');
//     _busy = false;
//     notifyListeners();

//     // return success;
//   }
}
