import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/booking/voucher_list_response.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/templates/profile_template.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:flutter/material.dart';

class VouchersPage extends StatefulWidget {
  @override
  _VouchersPageState createState() => _VouchersPageState();
}

class _VouchersPageState extends State<VouchersPage> {
  String userid;
  List<VoucherItem> vouchers;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  _init() async {
    var user = await Helper().getUserPrefs('userid');
    if (user == null) return;
    setState(() {
      userid = user;
      print('userid: $userid');
    });
    _getVoucher();
  }

  _getVoucher() async {
    setState(() {
      busy = true;
    });
    await Services().getVoucher(userid).then((res) {
      setState(() {
        busy = false;
      });
      print('get voucher: ${res.body}');
      if (res.statusCode == 200) {
        VoucherListResponse list = voucherListResponseFromJson(res.body);
        if (list.success == 'true') {
          print(list);
          setState(() {
            vouchers = list.data;
          });
        } else {
          print('gk ada voucher');
        }
      } else {
        print('errors');
      }
    }).catchError((err) => print('ada error: $err'));
  }

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
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('My Voucher', style: Theme.of(context).textTheme.title.apply(fontWeightDelta: 4),),
            ),
            body: busy
                ? Helper().busyIndicator(context, size)
                : userid == null
                    ? Helper().noLoginData(context,
                        'Login terlebih dahulu untuk mengakses data ini.')
                    : vouchers == null || vouchers.length == 0
                        ? Helper().noData(size)
                        : SingleChildScrollView(
                            child: Container(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: vouchers.length,
                                itemBuilder: (context, idx) {
                                  VoucherItem item = vouchers[idx];
                                  var _statusFirstLetter = item.status.substring(0,1).toUpperCase();
                                  var _statusRemain = item.status.substring(1, item.status.length);
                                  var _status = '$_statusFirstLetter$_statusRemain';

                                  return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            'vouchers/detail',
                                            arguments: RouteArguments(
                                                voucherItem: item));
                                      },
                                      child: Card(
                                        child: Column(
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Align(alignment:Alignment.centerRight,
                                                    child: Container(
                                                        padding: EdgeInsets.only(left:10, right: 10),
                                                        decoration: BoxDecoration(
                                                            color: _status=='Paid' ? Colors.green : _status=='Requested'? Colors.blue : Colors.black,
                                                            borderRadius: BorderRadius.circular(50)
                                                        ),
                                                        child: Text('$_status',
                                                          style: TextStyle(color: Colors.white),)),
                                                  ),
                                                ),
                                                ListTile(
                                                  leading: SizedBox(
                                                width: 80,
                                                    height: 80,
                                                    child: CachedNetworkImage(
                                                      imageUrl: '${item.images}',
                                                      placeholder: (context, url) =>
                                                          Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  8.0),
                                                          child:
                                                              CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation(
                                                                    Theme.of(
                                                                            context)
                                                                        .primaryColor),
                                                          ),
                                                        ),
                                                      ),
                                                      fit: BoxFit.cover,
                                                      width: 80,
                                                      height: 80,
                                                    ),
                                                  ),
                                                  title: Text(
                                                    item.wisata,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle,
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                          'Invoice no. ${item.invoiceNo}'),
                                                      Text(
                                                          'Voucher no. ${item.voucherNo}')
                                                    ],
                                                  ),
//                                              trailing:
//                                                  Icon(Icons.arrow_forward),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ))
      ],
    );
  }
}
