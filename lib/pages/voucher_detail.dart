import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/booking/voucher_detail_response.dart';
import 'package:dollan/models/booking/voucher_list_response.dart';
import 'package:dollan/pages/voucher_viewer.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:easy_dialog/easy_dialog.dart';

class VoucherDetailPage extends StatefulWidget {
  VoucherDetailPage({this.item});

  final VoucherItem item;

  @override
  _VoucherDetailPageState createState() => _VoucherDetailPageState();
}

class _VoucherDetailPageState extends State<VoucherDetailPage> {
  int total = 0;
  TextEditingController unCtl = TextEditingController();
  TextEditingController pwCtl = TextEditingController();
  bool busy = false;
  List<VoucherPaket> paket;
  VoucherDetailResponse resp;
  VoucherDetailItem item;
  var filePath = 'http://dollan.id/adminpanel/sales/so/voucher/?sid=185';
  String _localPath = '';
  DateFormat dateFormatDisplay = DateFormat("dd-MM-yyyy");
  String dateString;
  String status;
  TextEditingController messageCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  _init() async {
    setState(() {
      busy = true;
    });

    _localPath = (await _findLocalPath()) + '/Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    await Services().getVoucherDetail(widget.item.voucherNo).then((res) {
      setState(() {
        busy = false;
      });

      resp = voucherDetailResponseFromJson(res.body);

      print('res: ${resp.data[0]}');

      setState(() {
        item = resp.data[0];
        paket = item.paket;

        print(item.status);

        var _statusFirstLetter = item.status.substring(0, 1).toUpperCase();
        var _statusRemain = item.status.substring(1, item.status.length);
        status = '$_statusFirstLetter$_statusRemain';
      });

      _setTotal();
      dateString = dateFormatDisplay.format(DateTime.parse(item.travelDate));
    });
  }

  Future<String> _findLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    // final directory = widget.platform == TargetPlatform.android
    //     ? await getExternalStorageDirectory()
    //     : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  _setTotal() {
    for (int i = 0; i < item.paket.length; i++) {
      var p = int.parse(item.paket[i].price);
      var sub = p * int.parse(item.paket[i].qty);
      total += sub;
    }
  }

  _loginOperator() async {
    bool sukses = false;
    bool cancel = false;
    await showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Login Operator',
                  style: Theme.of(context).textTheme.title,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Username'),
                  controller: unCtl,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Password'),
                  controller: pwCtl,
                ),
//                RaisedButton(
//                  child: Text('Login'),
//                  onPressed: () async {
//                    sukses = await signInOperator(unCtl.text, pwCtl.text);
//                    Navigator.of(context).pop();
//                  },
//                )
              ],

            )),
            actions: <Widget>[
              FlatButton(child: Text('Login'), onPressed: () async{
                if(unCtl.text.isEmpty || pwCtl.text.isEmpty) return;
                sukses = await signInOperator(unCtl.text, pwCtl.text);
                Navigator.of(context).pop();
              },),
              FlatButton(child: Text('Batal'), onPressed: (){
                cancel = true;
                Navigator.of(context).pop();
              },),
            ],
          );
        });

    if(!cancel){
      if (sukses) {
        _init();
      } else {
        Helper().showAlert(context, 'Data Operator Tidak Ditemukan');
      }
    }

  }

//  Future<String> _findLocalPath() async {
//    final directory = Platform.isAndroid
//        ? await getExternalStorageDirectory()
//        : await getApplicationDocumentsDirectory();
//    return directory.path;
//  }
//
  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<bool> signInOperator(String un, String pw) async {
    print('sign in');
    bool sukses = false;
    if (unCtl.text.isEmpty || pwCtl.text.isEmpty) return false;
    Map data = {
      'voucher_no': item.voucherNo,
      'username_operator': un,
      'password_operator': pw
    };
    await Services().verifyOperator(data).then((res) {
      print('verify operator: ${res.body}');
      if (res.statusCode == 200) {
        var b = json.decode(res.body);
        if (b['success'] == 'true') {
          sukses = true;
        }
      }
    });
    return sukses;
  }

  _createDownloadTask(String id) async {
    //  String taskId = await FlutterDownloader.enqueue(
    //    url: 'http://dollan.id/adminpanel/sales/so/Invoice/?sid=$id',
    //    savedDir: _localPath,
    //    showNotification: true,
    //    openFileFromNotification:
    //    true, // click on notification to open downloaded file (for Android)
    //  );

//    Navigator.of(context).push(MaterialPageRoute(builder: (context) => VoucherViewer(url: 'http://dollan.id/adminpanel/sales/so/Invoice/?sid=$id',)));

    var url = 'http://dollan.id/adminpanel/sales/so/Invoice/?sid=$id';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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

  @override
  void dispose() {
//    FlutterDownloader.registerCallback(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('e-Voucher'),
        ),
        body: busy
            ? Helper().busyIndicator(context, size)
            : item == null
                ? Helper().noData(size)
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            decoration: BoxDecoration(
                                                color: status == 'Paid'
                                                    ? Colors.green
                                                    : status == 'Requested'
                                                        ? Colors.blue
                                                        : Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: Text(
                                              '$status',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ),
                                    ),
                                    ListTile(
                                      leading:
                                          // Image.asset(
                                          //   'assets/kat1.png',
                                          // ),
                                          CachedNetworkImage(
                                        imageUrl: '${item.images}',
                                        placeholder: (context, url) =>
                                            Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Theme.of(context)
                                                          .primaryColor),
                                            ),
                                          ),
                                        ),
                                        fit: BoxFit.cover,
                                        width: 80,
                                        height: 80,
                                        errorWidget: (context, string, obj) {
                                          return SizedBox(
                                            child: Helper().noImage(h: 80),
                                            width: 80,
                                            height: 80,
                                          );
                                        },
                                      ),
                                      title: item.wisata == null
                                          ? Container()
                                          : Text(item.wisata),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(item.kabupaten == null
                                              ? ''
                                              : item.kabupaten),
                                          Text(item.propinsi == null
                                              ? ''
                                              : item.propinsi)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Date',
                                            style: Helper().formatText(4),
                                          ),
                                          Text(item.travelDate == null
                                              ? ''
                                              : dateString),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Nama Pemesan',
                                            style: Helper().formatText(4),
                                          ),
                                          Text(
                                              item.pic == null ? '' : item.pic),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Mobile',
                                            style: Helper().formatText(4),
                                          ),
                                          Text(item.mobile == null
                                              ? ''
                                              : item.mobile),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          // Text(
                                          //   'Detail Paket',
                                          //   style: Helper().formatText(4),
                                          // ),
                                          // Text('Nama Paket : Paket 10 Km'),
                                          // Text('Jumlah Peserta : 10 orang'),
                                          // SizedBox(
                                          //   height: 10,
                                          // ),
                                          Text(
                                              'No. Invoice : ${item.invoiceNo}',
                                              style: Helper().formatText(4)),
                                          Text(
                                              'No. Voucher : ${item.voucherNo}',
                                              style: Helper().formatText(4)),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Total',
                                      style: Helper().formatText(3),
                                    ),
                                    Spacer(),
                                    Text('${Helper().setCurrencyFormat(total)}',
                                        style: Helper().formatText(3))
                                  ],
                                ),
                              ),
                            ),
                            item.status != 'paid'
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        FlatButton.icon(
                                          icon:Icon(Icons.monetization_on,color:Colors.red),
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
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            FlatButton.icon(
                                              icon: Icon(Icons.local_activity, color:Colors.green),
                                              label: Text(
                                                'Selesaikan Aktifitas',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle,
                                              ),
                                              onPressed: () {
                                                _loginOperator();
                                              },
                                            ),
                                            FlatButton.icon(
                                              icon: Icon(Icons.file_download, color: Colors.blue,),
                                              label: Text(
                                                'Download',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle
                                                    .apply(color: Colors.black),
                                              ),
                                              onPressed: () {
                                                _createDownloadTask(item.id);
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
                  ));
  }
}
