import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/booking/cart_response.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class TransHistoryItem extends StatefulWidget {
  TransHistoryItem({this.cartItem, this.position, this.func});

  final CartItem cartItem;
  final int position;
  final void Function(int) func;

  @override
  _TransHistoryItemState createState() => _TransHistoryItemState();
}

class _TransHistoryItemState extends State<TransHistoryItem> {
  TextEditingController dateCtrl = TextEditingController();
  TextEditingController picCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();

  final GlobalKey formKey = GlobalKey<FormState>();
  int _available = 0; // 0=defaut 1=tidak tersedia 2=tersedia

  List<Paket> paket = [];

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

  

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    String selectedDate;
    dateCtrl.text = widget.cartItem.travelDate;
    picCtrl.text = widget.cartItem.pic;
    emailCtrl.text = widget.cartItem.email;
    mobileCtrl.text = widget.cartItem.mobile;
    paket = widget.cartItem.paket;

    
    return Scaffold(
      body:
      
      Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 2.0,
            child: 
            
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  color: Colors.grey[100],
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: 
                        
                        ListTile(
                          leading: 
                          CachedNetworkImage(
                      imageUrl: '${widget.cartItem.images}',
                      placeholder: (context, url) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),),
                        ),
                      ),
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    ),
                          title: Text('${widget.cartItem.wisata}',
                              style: Helper().formatText(4)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('${widget.cartItem.kabupaten}',
                                  style: Helper().formatText(4)),
                              Text('${widget.cartItem.propinsi}',
                                  style:
                                      Theme.of(context).textTheme.caption)
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
                    _form(func: null),
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
                          'Total',
                          style: Helper().formatText(4),
                        ),
                        Spacer(),
                        Text('Rp $_totalPrice',
                            style: Helper().formatText(4))
                      ],
                    ),
                  ),
                ),
                
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
    )
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
              controller: emailCtrl,
              decoration: InputDecoration(labelText: 'Email', border: null),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
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
