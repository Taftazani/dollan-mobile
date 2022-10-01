import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/booking/cart_response.dart';
import 'package:dollan/models/viewmodels/cart_model.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:dollan/pages/CustomSlideRoute.dart';
import 'package:dollan/pages/cart.dart';
import 'package:dollan/pages/ketentuan.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class BookingItem extends StatefulWidget {
  BookingItem({this.cartItem, this.position, this.func});

  final CartItem cartItem;
  final int position;
  final void Function(int) func;

  @override
  _BookingItemState createState() => _BookingItemState();
}

class _BookingItemState extends State<BookingItem> {
  TextEditingController dateCtrl = TextEditingController();
  TextEditingController picCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  final formatter = new NumberFormat('#,###', 'id_ID');

  final GlobalKey formKey = GlobalKey<FormState>();
  int _available = 0; // 0=defaut 1=tidak tersedia 2=tersedia

  List<Paket> paket = [];

  bool agreed = false;

  String getMonthName(int month) {
    var months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    return months[month - 1];
  }

  int _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    paket = widget.cartItem.paket;
    _sum();
  }

  _deleteItem() async {
    bool delete =
        await Helper().showAlertWithParams(context, 'Yakin menghapus data?');
    if (!delete) {
      await ScopedModel.of<MainModel>(context)
          .deleteCartItem(id: widget.cartItem.id, position: widget.position);
    }
  }

  _updateItem(int paketPosition, int qty) {
    ScopedModel.of<MainModel>(context).updateCart(
        cartPos: widget.position, paketPos: paketPosition, qty: qty);
    _sum();
  }

  _sum() {
    int total = 0;
    for (int i = 0; i < widget.cartItem.paket.length; i++) {
      var p = int.parse(widget.cartItem.paket[i].price);
      var sub = p * int.parse(widget.cartItem.paket[i].qty);
      total += sub;
    }

    setState(() {
      _totalPrice = total;
    });
  }

  _payBooking() async {
    print('pay: ${widget.cartItem}');

    Map<String, dynamic> item = {};

    item['transactionid'] = widget.cartItem.id;
    item['client_id'] = widget.cartItem.clientId;
    item['travel_date'] = widget.cartItem.travelDate;
    item['postid'] = widget.cartItem.postId;
    item['company'] = widget.cartItem.datumOperator;
    item['pic'] = widget.cartItem.pic;
    item['mobile'] = widget.cartItem.mobile;
    item['email'] = widget.cartItem.email;

    int paketIndex = -1;
    for (int i = 0; i < widget.cartItem.paket.length; i++) {
      paketIndex++;
      item['package_id[$paketIndex]'] = widget.cartItem.paket[i].id;
      item['price[$paketIndex]'] = widget.cartItem.paket[i].price;
      item['qty[$paketIndex]'] = widget.cartItem.paket[i].qty;
      item['packagename[$paketIndex]'] = widget.cartItem.paket[i].packagename;

      item['tot_price[$paketIndex]'] =
          '${int.parse(widget.cartItem.paket[i].price) * int.parse(widget.cartItem.paket[i].qty)}';
    }

    // print('item: $item');

    await Services().payBooking(item).then((res) {
      print('paybooking: ${res.body}');
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
  Widget build(BuildContext context) {
    var now = DateTime.now();
    String selectedDate;
    dateCtrl.text = widget.cartItem.travelDate;
    picCtrl.text = widget.cartItem.pic;
    emailCtrl.text = widget.cartItem.email;
    mobileCtrl.text = widget.cartItem.mobile;
    paket = widget.cartItem.paket;

    Future _showCalendar() async {
      await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(now.year),
        lastDate: DateTime(now.year + 2, now.month, now.day),
      ).then((res) {
        print(res);
        setState(() {
          _available = 1;
          selectedDate = '${res.day} ${getMonthName(res.month)} ${res.year}';
          dateCtrl.text = selectedDate;
        });
      });
    }

    return GestureDetector(
      onTap: () {
        // focus
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    color: Colors.grey[100],
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            leading:

                                // Image.asset(
                                //   'assets/kat1.png',
                                // ),

                                SizedBox(
                              width: 80,
                              height: 80,
                              child: CachedNetworkImage(
                                imageUrl: '${widget.cartItem.images}',
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
                            title: Text('${widget.cartItem.wisata}',
                                style: Helper().formatText(4)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('${widget.cartItem.kabupaten}',
                                    style: Helper().formatText(4)),
                                Text('${widget.cartItem.propinsi}',
                                    style: Theme.of(context).textTheme.caption)
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteItem();
                          },
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Helper().spacer(isVertical: true, dist: 20),
                      _available == 1
                          ? Container(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'MAAF, TIDAK TERSEDIA',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : Container(),
                      _form(func: _showCalendar),
                      // _paket(paket: paket)
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Sub Total',
                            style: Helper().formatText(4),
                          ),
                          Spacer(),
                          //'Rp ${formatter.format(_totalPrice.round())}'
                          Text('Rp ${formatter.format(_totalPrice.round())}',
                              style: Helper().formatText(4))
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          shape: StadiumBorder(),
                          child: Text(
                            'BAYAR',
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .apply(fontWeightDelta: 4),
                          ),
                          onPressed: () {
                            if (agreed) {
                              _payBooking();
                            }
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                          value: agreed,
                          onChanged: (active) {
                            setState(() {
                              agreed = active;
                            });
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          children: <Widget>[
                            Text('Setuju dengan'),
                            FlatButton(
                              child: Text(
                                'Ketentuan Dollan',
                                style: TextStyle(color: Colors.blue),
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    CustomSlideRoute(page: KetentuanPage()));
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          _available == 2
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        shape: StadiumBorder(),
                        child: Text(
                          'BAYAR',
                          style: Helper().formatText(3),
                        ),
                        onPressed: () {},
                      )),
                )
              : Container()
        ],
      ),
    );
  }

  Widget _form({@required Function func}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Form(
        key: formKey,
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
                      controller: dateCtrl,
                      decoration: InputDecoration(
                        labelText: 'Tanggal',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
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
              controller: picCtrl,
              decoration: InputDecoration(
                labelText: 'Nama Pemesan',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            TextFormField(
              validator: (data) {
                if (data.isEmpty) {
                  return 'Please fill this field';
                }
                return null;
              },
              readOnly: true,
              keyboardType: TextInputType.phone,
              controller: mobileCtrl,
              decoration: InputDecoration(
                labelText: 'Mobile',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
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
              controller: emailCtrl,
              decoration: InputDecoration(
                labelText: 'Email',
                border: null,
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
          int _quota = int.parse(item.quota);

          return Card(
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
                          overflow: TextOverflow.ellipsis,
                          style: Helper().formatText(4),
                        ),
                        Text(
                          'Harga satuan : Rp ${int.parse(item.price)}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          'Subtotal : Rp ${int.parse(item.price) * _qty}',
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
                          // GestureDetector(
                          //   onTap: () {
                          //     // if (_qty > 0) {
                          //     //   setState(() {
                          //     //     _qty--;
                          //     //     item.qty = '$_qty';
                          //     //     _updateItem(pos, _qty);
                          //     //   });
                          //     // }
                          //   },
                          //   child: _counterButton(false),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Text(
                              '${item.qty}',
                              style: Helper().formatText(3),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     // if (_qty < _quota) {
                          //     //   setState(() {
                          //     //     _qty++;
                          //     //     item.qty = '$_qty';
                          //     //     _updateItem(pos, _qty);
                          //     //   });
                          //     // }
                          //   },
                          //   child: _counterButton(true),
                          // ),
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

  // Widget _counter() {
  //   return Row(
  //     children: <Widget>[
  //       GestureDetector(
  //         onTap: () {},
  //         child: _counterButton(false),
  //       ),
  //       Text('${paket[pos].total}')
  //       GestureDetector(
  //         onTap: () {},
  //         child: _counterButton(true),
  //       ),
  //     ],
  //   );
  // }

  Widget _counterButton(bool add) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Icon(
        add ? FontAwesomeIcons.plus : FontAwesomeIcons.minus,
        size: 10,
      ),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor, shape: BoxShape.circle),
    );
  }
}

class PackageItem {
  String title;
  int total;
  int allocate;
  int priceUnit;
  int priceTotal;

  PackageItem({this.title, this.total = 0, this.allocate, this.priceUnit}) {
    title = title;
    total = total;
    allocate = allocate;
  }
}
