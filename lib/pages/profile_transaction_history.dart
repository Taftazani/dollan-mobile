import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/booking/cart_response.dart';
import 'package:dollan/models/viewmodels/trans_history_model.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/templates/booking_item.dart';
import 'package:dollan/templates/profile_template.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dollan/templates/history_item.dart';
import 'package:http/http.dart' as http;

class TransactionHistoryPage extends StatefulWidget {
  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  TextEditingController dateCtrl = TextEditingController();
  TextEditingController picCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController messageCtrl = TextEditingController();

  List<CartItem> items;
  List<CartItem> temp;

  int totalPurchase = 0;
  String userid;
  bool busy = false;
  CartResponse cartResponse;

  // final GlobalKey formKey2 = GlobalKey<FormState>();

  updateTotalPurchase(int price) {
    setState(() {
      totalPurchase += price;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
//  _init();
  }

  _init() async {
    var user;
    user = await Helper().getUserPrefs('userid');
    setState(() {
      userid = user;
      print('userid: $userid');
    });

    if (userid == null) return;

    setState(() {
      busy = true;
    });

    bool sukses = false;

    await Services().getHistory(userid).then((res) {
      print(res.body);
      setState(() {
        busy = false;
      });
      if (res.statusCode == 200) {
        sukses = true;
        cartResponse = cartResponseFromJson(res.body);
      } else {
        print('disini');
      }
    });

    temp = cartResponse.data;
    print('temp: $temp');

    setState(() {
      items = temp;
    });
    print('history: $items');

    // ScopedModel.of<TransactionHistoryModel>(context).getItems();
  }

//  @override
//  void didChangeDependencies() {
//    // TODO: implement didChangeDependencies
//    super.didChangeDependencies();
//    if(items!=null){
//      setState(() {
//        items = cartResponse.data;
//      });
//    }
//
//
//  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        ProfileBackground(
          top: 0.88,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: Helper().backButton(context),
            title: Text('Transaction History', style: Theme.of(context).textTheme.title.apply(fontWeightDelta: 4),),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: busy
              ? Helper().busyIndicator(context, size)
              : userid == null
                  ? Helper().noLoginData(context,
                      'Login terlebih dahulu untuk mengakses data ini.')
                  : items == null || items.length == 0
                      ? Helper().noData(size)
                      : Container(
                          child: Container(
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, pos) {
                              CartItem item = items[pos];
                              List<Paket> paket = item.paket;
                              int total = 0;
                              for (int i = 0; i < item.paket.length; i++) {
                                var p = int.parse(item.paket[i].price);
                                var sub = p * int.parse(item.paket[i].qty);
                                total += sub;
                              }

                              return

                                  //---
                                  buildHistoryItem(item, context, paket, total);
                              //---
                            },
                          ),
                        )),
        )
      ],
    );
  }

  Padding buildHistoryItem(
      CartItem item, BuildContext context, List<Paket> paket, int total) {
    var _statusFirstLetter = item.status.substring(0, 1).toUpperCase();
    var _statusRemain = item.status.substring(1, item.status.length);
    var _status = '$_statusFirstLetter$_statusRemain';
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: Colors.grey[100],
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: _status == 'Paid'
                              ? Colors.green
                              : _status == 'Requested'
                                  ? Colors.blue
                                  : Colors.black,
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        '$_status',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              color: Colors.grey[100],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      leading: SizedBox(
                        width: 80,
                        height: 80,
                        child: CachedNetworkImage(
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
                          width: 80,
                          height: 80,
                        ),
                      ),
                      title:
                          Text('${item.wisata}', style: Helper().formatText(4)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${item.kabupaten}',
                              style: Helper().formatText(4)),
                          Text('${item.propinsi}',
                              style: Theme.of(context).textTheme.caption)
                        ],
                      ),
                    ),
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.delete),
                  //   onPressed: () {
                  //     _deleteItem();
                  //   },
                  // )
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Helper().spacer(isVertical: true, dist: 20),

                // ===

//                                            item==null?Container():_form(item: item),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Tanggal',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                Text(item.travelDate),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Nama Pemesan',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                Text(item.pic),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Mobile',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                Text(item.mobile),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Email',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                Text(item.email),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ===
                item == null ? Container() : _paket(paket: paket)
              ],
            ),
            Container(
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Total',
                      style: Helper().formatText(4),
                    ),
                    Spacer(),
                    Text('${Helper().setCurrencyFormat(total)}',
                        style: Helper().formatText(4))
                  ],
                ),
              ),
            ),
            item.status != 'paid'
                ? Container()
                : FlatButton.icon(
                    icon: Icon(Icons.monetization_on, color: Colors.red),
                    label: Text(
                      'Refund',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .apply(color: Colors.black),
                    ),
                    onPressed: () {
                      _refund(item.voucherNo);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  _refund(String voucherNo) async {
    bool send = false;

    await EasyDialog(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.3,
        contentList: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Berikan alasan Anda'),
                controller: messageCtrl,
                maxLength: 200,
                maxLines: 3,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text('Kirim', style: TextStyle(color: Colors.blue),),
                onPressed: () {
                  if (messageCtrl.text.isNotEmpty) {
                    send = true;
                    Navigator.of(context).pop();
                  }

                },
              ),
              SizedBox(width: 10,),
              FlatButton(
                child: Text(
                  'Batal',  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ]).show(context);

    print(send);

    if (send) {
      if (messageCtrl.text.isNotEmpty) {
        setState(() {
          busy = true;
        });
        Map data = {'voucher_no': voucherNo, 'refund_note': messageCtrl.text};
        http.Response res = await Services().refund(data);

        setState(() {
          busy = false;
        });

        print(res.body);
        var body = json.decode(res.body);
        if (body['success'] == 'true') {
          await Helper().showAlert(context, body['message']);
//          Navigator.of(context)
//              .pushNamedAndRemoveUntil('profile', (Route<dynamic> route) => false);

          Navigator.of(context).pushNamedAndRemoveUntil(
              'home', (Route<dynamic> route) => false,
              arguments: RouteArguments(tabIndex: 3));

        }
      };

    }
  }

  Widget _form({@required CartItem item}) {
    print('mobileCtrl.text: ${mobileCtrl.text}');
    dateCtrl.text = item.travelDate;
    picCtrl.text = item.pic;
    emailCtrl.text = item.email;
    mobileCtrl.text = item.mobile;
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Form(
        // key: formKey2,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: TextFormField(
                      validator: (data) {
                        if (data.isEmpty) {
                          return 'Please fill this field';
                        }
                        return null;
                      },
                      readOnly: true,
                      enabled: false,
                      controller: dateCtrl,
                      decoration: InputDecoration(labelText: 'Tanggal'),
                    ),
                  ),
                ),
              ],
            ),
            TextFormField(
              validator: (data) {
                if (data.isEmpty) {
                  return 'Please fill this field';
                }
                return null;
              },
              readOnly: true,
              enabled: false,
              controller: picCtrl,
              decoration: InputDecoration(labelText: 'Nama Pemesan'),
            ),
            TextFormField(
              validator: (data) {
                if (data.isEmpty) {
                  return 'Please fill this field';
                }
                return null;
              },
              readOnly: true,
              enabled: false,
              keyboardType: TextInputType.phone,
              controller: mobileCtrl,
              decoration: InputDecoration(labelText: 'Mobile'),
            ),
            TextFormField(
              validator: (data) {
                if (data.isEmpty) {
                  return 'Please fill this field';
                }
                return null;
              },
              readOnly: true,
              keyboardType: TextInputType.emailAddress,
              enabled: false,
              controller: emailCtrl,
              decoration: InputDecoration(labelText: 'Email', border: null),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _paket({@required List<Paket> paket}) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: paket.length,
      itemBuilder: (context, pos) {
        Paket item = paket[pos];
        int _qty = int.parse(item.qty);
//          int _quota = int.parse(item.q);

        return _qty == 0
            ? Container()
            : Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${item.packagename}',
                              style: Helper().formatText(4),
                            ),
                            Text(
                              'Harga satuan : ${Helper().setCurrencyFormat(int.parse(item.price))}',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              'Subtotal : ${Helper().setCurrencyFormat(int.parse(item.price) * _qty)}',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Text(
                                  '${item.qty}',
                                  style: Helper().formatText(3),
                                ),
                              ),
                            ],
                          ),
                          Helper().spacer(isVertical: true, dist: 10),
                          // Text(
                          //   'Sisa ${_quota - _qty}',
                          //   style: TextStyle(fontSize: 16, color: Colors.black),
                          // )
                        ],
                      )
                    ],
                  ),
                ),
              );
      },
    ),
  );
}
