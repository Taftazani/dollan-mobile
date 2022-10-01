import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dollan/models/booking/booking_response.dart';
import 'package:dollan/models/booking/cart_response.dart';
import 'package:dollan/models/viewmodels/booking_model.dart';
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
import 'package:flutter_counter/flutter_counter.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BookingPage extends StatefulWidget {
  BookingPage({this.id, this.companyId});

  final String id;
  final String companyId;

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  TextEditingController dateCtrl = TextEditingController();
  TextEditingController picCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  final formatter = new NumberFormat('#,###', 'id_ID');

  final GlobalKey formKey = GlobalKey<FormState>();
  int _available = 0; // 0=defaut 1=tidak tersedia 2=tersedia
  GetBookingData _bookingData;
  int totalPrice = 0;
  String selectedDateToSend;
  bool busy = false;
  String userid;

  bool agreed = false;

//  List<PackageItem> paket = [
//    PackageItem(title: 'Paket Jalan 10Km', allocate: 5),
//    PackageItem(title: 'Paket Jalan 20Km', allocate: 10),
//    PackageItem(title: 'Paket Jalan 30Km', allocate: 100),
//  ];

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

  List<int> totals = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());

    if (ScopedModel.of<MainModel>(context).devMode == true) {
      setState(() {
        picCtrl.text = 'Jhon Doe';
        emailCtrl.text = 'jhondoe@email.com';
        mobileCtrl.text = '098765432';
      });
    }
  }

  _init() {
    print('company id: ${widget.companyId}');
    setState(() {
      busy = true;
    });
    ScopedModel.of<BookingModel>(context).getData(widget.id);
    ScopedModel.of<BookingModel>(context).addListener(_listener);
  }

  _listener() {
    if (ScopedModel.of<BookingModel>(context).dataDone) {
      setState(() {
        busy = false;
        _bookingData = ScopedModel.of<BookingModel>(context).getBookingData;
        for (int i = 0; i < _bookingData.product.length; i++) {
          setState(() {
            totals.add(0);
          });
        }
      });
    }
  }

  _sum() {
    int total = 0;
    for (int i = 0; i < _bookingData.product.length; i++) {
      var p = int.parse(_bookingData.product[i].price);
      var sub = p * totals[i];
      total += sub;
    }

    setState(() {
      totalPrice = total;
    });
  }

  _sendBooking(bool directToPayment) async {
    if (picCtrl.text.isEmpty || mobileCtrl.text.isEmpty) {
      await Helper()
          .showAlert(context, 'Data Nama Pemesan dan Mobile harus diisi');
      return;
    }

    print('total paket : $totals');
    int _subtotal = 0;
    for (int data in totals) {
      _subtotal += data;
    }

    if (_subtotal == 0) {
      await Helper().showAlert(context, 'Harap pilih paket terlebih dahulu');
      return;
    }

    setState(() {
      busy = true;
    });
    List<Map<String, dynamic>> submit = [];
    Map<String, dynamic> item = {};

    SharedPreferences sp = await SharedPreferences.getInstance();
    userid = sp.getString("userid");
    print('userid: $userid');

    item['client_id'] = userid;
    item['travel_date'] = '$selectedDateToSend';
    item['postid'] = widget.id;
    item['company'] = widget.companyId;
    item['pic'] = picCtrl.text;
    item['mobile'] = mobileCtrl.text;
    item['email'] = emailCtrl.text;

    int paketIndex = -1;
    for (int i = 0; i < totals.length; i++) {
      if (totals[i] != 0) {
        paketIndex++;
        item['package_id[$paketIndex]'] = _bookingData.product[i].id;
        item['price[$paketIndex]'] = _bookingData.product[i].price;
        item['qty[$paketIndex]'] = '${totals[i]}';

        item['tot_price[$paketIndex]'] =
            '${int.parse(_bookingData.product[i].price) * totals[i]}';
      }
    }

    http.Response res = await Services().sendBooking(item);
    setState(() {
      busy = false;
    });

    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      print('body: $body');
      if (body["success"] == 'true') {
        if (!directToPayment) {
          Helper()
              .showAlertCustom(
                  context: context,
                  msg: 'Paket berhasil ditambahkan.',
                  buttonLabel: 'Lihat Keranjang')
              .then((res) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                'home', (Route<dynamic> route) => false,
                arguments: RouteArguments(tabIndex: 2));
          });
        } else {
          // If pay directly
          int transId = body['data']['transactionid'];
          bookNow('$transId');
        }
      } else {
        Helper().showAlert(context, 'Gagal menambahkan paket.').then((res) {
          return null;
        });
      }
    } else {
      Helper().showAlert(context, 'Gagal menambahkan paket.').then((res) {
        return null;
      });
    }
  }

  bookNow(String transId) async {
    List<CartItem> _cartItems = [];
    CartItem _cartItem;

    String userid = await Helper().getUserPrefs('userid');

    if (userid != null) {
      http.Response res = await Services().getCart(userid);

      CartResponse cartResponse = cartResponseFromJson(res.body);
      if (cartResponse.success == 'true') {
        _cartItems = cartResponse.data;
      }

      for (int i = 0; i < _cartItems.length; i++) {
        if (_cartItems[i].id == transId) {
          _payBooking(_cartItems[i]);
          i = _cartItems.length;
        }
      }
    }
  }

  _payBooking(CartItem cartItem) async {
    print('pay: ${cartItem}');

    Map<String, dynamic> item = {};

    item['transactionid'] = cartItem.id;
    item['client_id'] = cartItem.clientId;
    item['travel_date'] = cartItem.travelDate;
    item['postid'] = cartItem.postId;
    item['company'] = cartItem.datumOperator;
    item['pic'] = cartItem.pic;
    item['mobile'] = cartItem.mobile;
    item['email'] = cartItem.email;

    int paketIndex = -1;
    for (int i = 0; i < cartItem.paket.length; i++) {
      paketIndex++;
      item['package_id[$paketIndex]'] = cartItem.paket[i].id;
      item['price[$paketIndex]'] = cartItem.paket[i].price;
      item['qty[$paketIndex]'] = cartItem.paket[i].qty;
      item['packagename[$paketIndex]'] = cartItem.paket[i].packagename;

      item['tot_price[$paketIndex]'] =
          '${int.parse(cartItem.paket[i].price) * int.parse(cartItem.paket[i].qty)}';
    }

    await Services().payBooking(item).then((res) {
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
              Navigator.of(context).pushNamedAndRemoveUntil(
                  'home', (Route<dynamic> route) => false);
            });
          }
        } else {
          Helper()
              .showAlert(context, 'Gagal membuka halaman pembayaran')
              .then((_) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                'home', (Route<dynamic> route) => false);
          });
        }
      }
    }).catchError((err) {
      print('paybooking ERROR : $err');
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var now = DateTime.now();
    String selectedDate;

    Future _showCalendar() async {
      await showDatePicker(
        context: context,
        initialDate: DateTime(now.year, now.month, now.day + 1),
        firstDate: DateTime(now.year, now.month, now.day + 1),
        lastDate: DateTime(now.year + 2, now.month, now.day),
      ).then((res) {
        print(res);
        setState(() {
          _available = 2;
          selectedDate = '${res.day} ${getMonthName(res.month)} ${res.year}';

          // prepare for send data
          var d = '${res.day}';
          if (res.day < 10) {
            d = "0${res.day}";
          }

          var m = '${res.month}';
          if (res.month < 10) {
            m = "0${res.month}";
          }

          selectedDateToSend = '${res.year}-$m-$d';

          dateCtrl.text = selectedDate;
          _sum();
        });
      });
    }

    return ScopedModelDescendant<BookingModel>(
      builder: (context, child, model) {
        return busy
            ? Container(
                width: size.width,
                height: size.height,
                color: Colors.white,
                child: Center(child: CircularProgressIndicator()))
            : _bookingData == null
                ? Container()
                : Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      leading: Helper().backButton(context),
                      title: Text('Booking'),
                    ),
                    body: SingleChildScrollView(
                      child: GestureDetector(
                        onTap: () {
                          // focus
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      color: Colors.grey[100],
                                      child: ListTile(
                                        leading: Image.network(
                                          _bookingData.images == null
                                              ? Container()
                                              : '${_bookingData.images}',
                                        ),
                                        title: Text('${_bookingData.title}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '${_bookingData.kabname}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text('${_bookingData.provname}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption,
                                                overflow: TextOverflow.ellipsis)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Helper()
                                            .spacer(isVertical: true, dist: 20),
                                        _available == 1
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'MAAF, TIDAK TERSEDIA',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        _form(func: _showCalendar),
                                        _bookingData != null &&
                                                totals.length > 0
                                            ? _paket()
                                            : Container()
                                      ],
                                    ),
                                    _available == 2
                                        ? Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200]),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    'Total',
                                                    style:
                                                        Helper().formatText(3),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                      '${Helper().setCurrencyFormat(totalPrice)}',
                                                      style: Helper()
                                                          .formatText(3))
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                            // _available == 2
                            totalPrice > 0 &&
                                    picCtrl.text.isNotEmpty &&
                                    dateCtrl.text.isNotEmpty &&
                                    mobileCtrl.text.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8),
                                              child: SizedBox(
//                                                  height: 30,
                                                  child: RaisedButton(
                                                color: Colors.red,
                                                shape: StadiumBorder(),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'MASUKKAN\nKERANJANG',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle
                                                        .apply(
                                                            fontWeightDelta: 10,
                                                            color:
                                                                Colors.white),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (agreed) {
                                                    _sendBooking(false);
                                                  }
                                                },
                                              )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8),
                                              child: SizedBox(
//                                                  height: 30,
                                                  // width: 100,
                                                  child: RaisedButton(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                shape: StadiumBorder(),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'BAYAR\nSEKARANG',
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle
                                                        .apply(
                                                            fontWeightDelta:
                                                                10),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (agreed) {
                                                    _sendBooking(true);
                                                  }
                                                },
                                              )),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                              Text('Setuju dengan'),
                                              FlatButton(
                                                child: Text(
                                                  'Ketentuan Dollan',
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      CustomSlideRoute(
                                                          page:
                                                              KetentuanPage()));
                                                },
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ));
      },
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
                GestureDetector(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        FontAwesomeIcons.calendarAlt,
                        color: Colors.black,
                      )),
                  onTap: () {
                    func();
                  },
                )
              ],
            ),
            TextFormField(
              validator: (data) {
                if (data.isEmpty) {
                  return 'Please fill this field';
                }
                return null;
              },
              controller: picCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: 'Nama Pemesan'),
            ),
            TextFormField(
              validator: (data) {
                if (data.isEmpty) {
                  return 'Please fill this field';
                }
                return null;
              },
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
              keyboardType: TextInputType.emailAddress,
              controller: emailCtrl,
              decoration: InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paket() {
//    List<Product> products;
    // print('paket: $totals');

    return _bookingData == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: totals.length == 0
                ? Container()
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _bookingData.product.length,
                    itemBuilder: (context, pos) {
//          PackageItem item = paket[pos];
                      Product item = _bookingData.product[pos];
                      var itemTotal = totals[pos];
                      int total = int.parse(item.price) * itemTotal;
                      // print('item.quota: ${item.quota}');

                      return Card(
                        color: Colors.grey[100],
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        AutoSizeText(
                                          '${item.name}',
                                          maxLines: 2,
                                          style: Helper().formatText(4),
                                        ),
                                        item.quota == '0' || item.quota == null
                                            ? Text(
                                                'TIDAK TERSEDIA',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .title
                                                    .apply(color: Colors.red),
                                              )
                                            : Container(),
                                        item.quota == '0' || item.quota == null
                                            ? Container()
                                            : Text(
                                                //Rp ${formatter.format(total.round())}
                                                'Harga satuan : Rp ${formatter.format(int.parse(item.price).round())}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption,
                                              ),
                                        item.quota == '0' || item.quota == null
                                            ? Container()
                                            : Text(
                                                'Subtotal : Rp ${formatter.format(total.round())}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption,
                                              ),
                                      ],
                                    )),
                              ),
                              // Expanded(
                              //   child: Container(),
                              // ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  // Counter(
                                  //   color: Theme.of(context).primaryColor,
                                  //   initialValue: paket[pos].total,
                                  //   minValue: 0,
                                  //   maxValue: paket[pos].allocate,
                                  //   decimalPlaces: 0,
                                  //   textStyle: Helper().formatText(3),
                                  //   onChanged: (num) {
                                  //     setState(() {
                                  //       paket[pos].total = num;
                                  //     });
                                  //   },
                                  // ),
                                  Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          if (itemTotal > 0) {
                                            setState(() {
                                              itemTotal--;
                                              totals[pos] = itemTotal;
                                              _sum();
                                            });
                                          }
                                        },
                                        child: _counterButton(false),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8),
                                        child: Text(
                                          '$itemTotal',
                                          style: Helper().formatText(3),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          print('add');
                                          if (itemTotal <
                                              int.parse(item.quota)) {
                                            setState(() {
                                              itemTotal++;
                                              totals[pos] = itemTotal;
                                              _sum();
                                            });
                                          }
                                        },
                                        child: _counterButton(true),
                                      ),
                                    ],
                                  ),
                                  Helper().spacer(isVertical: true, dist: 10),
                                  Text(
                                    'Sisa ${int.parse(item.quota) - itemTotal}',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                        color: Colors.black),
                                  )
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

  PackageItem({this.title, this.total = 0, this.allocate}) {
    title = title;
    total = total;
    allocate = allocate;
  }
}
