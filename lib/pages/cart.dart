import 'dart:convert';
import 'dart:math';

import 'package:dollan/models/booking/cart_response.dart';
import 'package:dollan/models/viewmodels/cart_model.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:dollan/pages/CustomSlideRoute.dart';
import 'package:dollan/pages/ketentuan.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/templates/booking_item.dart';
import 'package:dollan/templates/cart_item_cell.dart';
import 'package:dollan/templates/list_item_row.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with AutomaticKeepAliveClientMixin {
  List<CartItem> cartItems = [];
  bool busy = false;

  int totalPurchase = 0;
  int _total;

  bool agreed = false;
  bool agreedAll = false;
  bool payAll = false;

  bool showAgreeAllMessage = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  _init() async {
    if (mounted) {
      ScopedModel.of<MainModel>(context).getItems(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ScopedModelDescendant<MainModel>(
      builder: (context, widget, model) {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
              title: Row(children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Image.asset(
                      'assets/icons/new/cart.png',
                      color: Theme.of(context).primaryColor,
                      scale: 2.5,
                    )),
                SizedBox(
                  width: 10,
                ),
                model.cartItems != null
                    ? Text('Cart (${model.cartItems.length})',
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .apply(fontWeightDelta: 4))
                    : Text('Cart',
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .apply(fontWeightDelta: 4))
              ]),
              actions: <Widget>[
                model.cartItems == null
                    ? Container()
                    : model.cartItems.length > 1
                        ? FlatButton.icon(
                            onPressed: () {
                              setState(() {
                                payAll = true;
                              });
//                  _confirmPayAll(context, model);
//                  _displayDialog(context);
                            },
                            icon: Icon(Icons.done_all),
                            label: Text('Bayar Semua'))
                        : Container()
              ],
            ),
            body: model.busy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : payAll
                    ? _payAllLayout(model)
                    : model.cartItems.length > 0
                        ? Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: CustomScrollView(slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildListDelegate([
                                  Container(
                                    // height: 400,
                                    padding: EdgeInsets.all(10),
                                    child: model.cartItems == null ||
                                            model.cartItems.length == 0
                                        ? Container()
                                        : ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: model.cartItems.length,
                                            itemBuilder: (context, pos) {
                                              return
//                                      Text(model.cartItems[pos].wisata);

                                                  // BookingItem(cartItem: cartItems[pos], position: pos, unc: _deleteItem,);

                                                  BookingItem(
                                                      cartItem:
                                                          model.cartItems[pos],
                                                      position: pos);
                                            },
                                          ),
                                  ),

                                  SizedBox(
                                    height: 15,
                                  ),
//
                                ]),
                              ),
                            ]),
                          )
                        : Center(
                            child: Text(
                            'Tidak ada data.\nSilahkan pilih paket.',
                            textAlign: TextAlign.center,
                          )));
      },
    );
  }

  _displayDialog(BuildContext context) async {
    return AlertDialog(
      title: Text('CheckBox'),
      content: CheckboxListTile(
        title: Text("CheckBox Text"),
        value: agreedAll,
        onChanged: (val) {
          setState(() {
            agreedAll = val;
          });
        },
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  Widget _payAllLayout(MainModel model) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Yakin akan membayar semua sekaligus?',
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          shape: StadiumBorder(),
                          child: Text(
                            'YA',
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                          onPressed: () {
                            if (agreedAll) {
                              _payAll(model);
                            } else {
                              setState(() {
                                showAgreeAllMessage = true;
                              });
                            }
                          },
                        ),
                        RaisedButton(
                          color: Colors.red,
                          shape: StadiumBorder(),
                          child: Text(
                            'BATAL',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle
                                .apply(color: Colors.white),
                          ),
                          onPressed: () {
                            if (agreedAll) {
                              setState(() {
                                payAll = false;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        value: agreedAll,
                        onChanged: (active) {
//              _updateValue();
                          setState(() {
                            agreedAll = active;
                            print(agreedAll);
                          });
                        },
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Setuju dengan'),
                      FlatButton(
                        child: Text(
                          'Ketentuan Dollan',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context, CustomSlideRoute(page: KetentuanPage()));
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        !showAgreeAllMessage
            ? Container()
            : Center(
                child:
                    Text('Anda harus memilih setuju dengan ketentuan Dollan')),
      ],
    );
  }

  _confirmPayAll(BuildContext contet, MainModel model) async {
    bool pay = false;
    bool agreed = false;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Yakin akan membayar semua sekaligus?'),
            content: _payAllLayout(model),
            actions: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        child: Text('YA'),
                        onPressed: () {
                          pay = true;
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text(
                          'BATAL',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        });

    if (pay) {
      if (agreed) {
        _payAll(model);
      }
    }
  }

  _payAll(MainModel model) async {
    print('=== pay all ===');
    setState(() {
      busy = true;
    });

    Map<String, dynamic> items = {};

    for (int i = 0; i < model.cartItems.length; i++) {
      CartItem cartItem = model.cartItems[i];
      items['transactionid[$i]'] = cartItem.id;
      items['client_id[$i]'] = cartItem.clientId;
      items['travel_date[$i]'] = cartItem.travelDate;
      items['postid[$i]'] = cartItem.postId;
      items['company[$i]'] = cartItem.datumOperator;
      items['pic[$i]'] = cartItem.pic;
      items['mobile[$i]'] = cartItem.mobile;
      items['email[$i]'] = cartItem.email;

      int paketIndex = -1;
      for (int j = 0; j < cartItem.paket.length; j++) {
        if (cartItem.paket[j].qty == '0') {
          paketIndex++;
          items['package_id[$i][$paketIndex]'] = cartItem.paket[j].id;
          items['price[$i][$paketIndex]'] = cartItem.paket[j].price;
          items['qty[$i][$paketIndex]'] = cartItem.paket[j].qty;
          items['packagename[$i][$paketIndex]'] = cartItem.paket[j].packagename;

          items['tot_price[$i][$paketIndex]'] =
              '${int.parse(cartItem.paket[j].price) * int.parse(cartItem.paket[j].qty)}';
        }

        // print('cartItem.paket[j].qty: ${cartItem.paket[j].qty}');

      }

      print('items---: $items');
    }

    await Services().payAllBooking(items).then((res) {
      setState(() {
        busy = false;
      });

      print('response: ${res.body}');

      if (res != null) {
        print('${res.statusCode}');
        print('${res.body}');
        if (res.statusCode == 200) {
          var result = json.decode(res.body);
          if (result["success"] == "true") {
            var url = result["data"];
            Navigator.of(context)
                .pushNamed('payment', arguments: RouteArguments(url: url));
          } else {
            Helper()
                .showAlert(context, 'Gagal membuka halaman pembayaran')
                .then((_) {
              return null;
            });
          }
        } else {
          Helper()
              .showAlert(context, 'Gagal membuka halaman pembayaran')
              .then((_) {
            return null;
          });
        }
      }
    }).catchError((err) {
      print('paybooking ERROR : $err');
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
