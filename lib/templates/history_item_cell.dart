import 'package:dollan/models/viewmodels/cart_model.dart';
import 'package:dollan/models/viewmodels/trans_history_model.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class HistoryItemCell extends StatefulWidget {
  HistoryItemCell({this.title, this.adult, this.child, this.idx, this.type});

  final String title;
  final int adult;
  final int child;
  final int idx;
  final int type;

  @override
  _HistoryItemCellState createState() => _HistoryItemCellState();
}

class _HistoryItemCellState extends State<HistoryItemCell> {
  int totalPersonAdult = 0;
  int totalPersonChild = 0;
  int unitPriceAdult = 150000;
  int unitPriceChild = 75000;
  int subtotalAdult = 0;
  int subtotalChild = 0;
  int total = 0;

  initState() {
    super.initState();

    totalPersonAdult = widget.adult;
    totalPersonChild = widget.child;

    updateTotalUnitPrice(isAdult: true);
    updateTotalUnitPrice(isAdult: false);
  }

  updateTotalPerson({bool isAdult, bool add}) {
    if (isAdult) {
      setState(() {
        if (add) {
          totalPersonAdult += 1;
        } else {
          if (totalPersonAdult > 0) {
            totalPersonAdult -= 1;
          }
        }
      });
    } else {
      setState(() {
        if (add) {
          totalPersonChild += 1;
        } else {
          if (totalPersonChild > 0) {
            totalPersonChild -= 1;
          }
        }
      });
    }

    updateTotalUnitPrice(isAdult: isAdult);
  }

  updateTotalUnitPrice({bool isAdult}) {
    setState(() {
      if (isAdult) {
        subtotalAdult = totalPersonAdult * unitPriceAdult;
      } else {
        subtotalChild = totalPersonChild * unitPriceChild;
      }
    });

    updateTotal();
  }

  updateTotal() {
    setState(() {
      total = subtotalAdult + subtotalChild;
      // ScopedModel.of<TransactionHistoryModel>(context)
      //     .updateTotalPurchase(idx: widget.idx, price: total);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Card(
          color: widget.type == 1
              ? Colors.red[100]
              : widget.type == 2 ? Colors.green[100] : Colors.grey[200],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                children: <Widget>[
                  
                  Padding(
                    padding: const EdgeInsets.only(top:10.0, bottom: 10),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/kat1.png',
                      ),
                      title: Text('Wisata Arung Jeram', style: Helper().formatText(3),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Sukamulya Desa Cikole'),
                          Text('Sukabumi, Jawa Barat')
                        ],
                      ),
                    ),
                  ),
                  Container(
                color: Colors.grey,
                height: 1,
              ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Date',
                              style: Helper().formatText(4),
                            ),
                            Text('20 Agustus 2019'),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'PIC',
                              style: Helper().formatText(4),
                            ),
                            Text('Agus Dahono'),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Mobile',
                              style: Helper().formatText(4),
                            ),
                            Text('087967463736'),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Detail Paket',
                              style: Helper().formatText(4),
                            ),
                            Text('Nama Paket : Paket 10 Km'),
                            Text('Jumlah Peserta : 10 orang'),
                            SizedBox(
                              height: 10,
                            ),
                            Text('No. Invoice : INV-007-09',
                                style: Helper().formatText(4)),
                            Text('No. Voucher : 007',
                                style: Helper().formatText(4)),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.grey,
                height: 1,
              ),
              Container(
                // decoration: BoxDecoration(color: Colors.grey[200]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Total',
                        style: Helper().formatText(3),
                      ),
                      Spacer(),
                      Text('Rp 1.800.000', style: Helper().formatText(3))
                    ],
                  ),
                ),
              ),
            ],
          ),
        )

        // Card(
        //   color: widget.type==1 ? Colors.red[100] : widget.type==2 ? Colors.green[100] : Colors.grey[200],
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.circular(10),
        //     child: Column(
        //       children: <Widget>[
        //         Container(
        //           child: Row(children: <Widget>[
        //             Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: Text(widget.title, style: TextStyle(fontSize: 15)),
        //               ),
        //               Spacer(flex: 1,),
        //               IconButton(icon: widget.type==1 ? Icon(Icons.warning) : widget.type==2 ? Icon(Icons.timelapse) : Icon(Icons.check), onPressed: (){},)
        //           ],),
        //           height: 40,

        //         ),
        //         Container(

        //           child: Column(
        //             children: <Widget>[
        //               Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: _settingRow(isAdult:true)),
        //               Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: _settingRow(isAdult: false))
        //             ],
        //           ),
        //         ),
        //         Container(
        //           height: 40,

        //           child: Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Row(
        //               children: <Widget>[
        //                 Text(
        //                   'Total',
        //                   style: TextStyle(
        //                       fontSize: 15, fontWeight: FontWeight.bold),
        //                 ),
        //                 SizedBox(
        //                   width: 150,
        //                   child: Align(
        //                     alignment: Alignment.centerRight,
        //                                             child: Text('Rp', style: TextStyle(
        //                         fontSize: 15, fontWeight: FontWeight.bold)),
        //                   ), ),
        //                 Spacer(
        //                   flex: 1,
        //                 ),
        //                 Text(
        //                   '$total',
        //                   style: TextStyle(
        //                       fontSize: 15, fontWeight: FontWeight.bold),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        );
  }

  Widget _settingRow({bool isAdult}) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 70,
          child: Text(isAdult ? 'Dewasa' : 'Anak-anak'),
        ),
        SizedBox(
            width: 30,
            child: Center(
                child: Text(isAdult ? '$totalPersonAdult' : '$totalPersonChild',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))),
        SizedBox(
          width: 20,
        ),
        Text('Rp '),
        Spacer(
          flex: 1,
        ),
        Text(isAdult ? '$subtotalAdult' : '$subtotalChild')
      ],
    );
  }
}
