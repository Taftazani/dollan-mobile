import 'package:dollan/models/viewmodels/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CartItemCell extends StatefulWidget {
  CartItemCell({this.title, this.adult, this.child, this.idx});

  final String title;
  final int adult;
  final int child;
  final int idx;

  @override
  _CartItemCellState createState() => _CartItemCellState();
}

class _CartItemCellState extends State<CartItemCell> {
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

  updateTotal(){
    setState(() {
      total = subtotalAdult + subtotalChild;
      ScopedModel.of<CartModel>(context).updateTotalPurchase(idx: widget.idx, price: total);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            children: <Widget>[
              Container(
                child: Row(children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.title, style: TextStyle(fontSize: 15)),
                    ),
                    Spacer(flex: 1,),
                    IconButton(icon: Icon(Icons.delete), onPressed: (){},)
                ],),
                height: 40,
                color: Colors.grey[200],
              ),
              Container(
                color: Colors.grey[300],
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _settingRow(isAdult:true)),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _settingRow(isAdult: false))
                  ],
                ),
              ),
              Container(
                height: 40,
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Subtotal',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                                                  child: Text('Rp', style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                        ), ),
                      Spacer(
                        flex: 1,
                      ),
                      Text(
                        '$total',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingRow({bool isAdult}) {
    return Row(
      children: <Widget>[
        
        SizedBox(width: 70, child: Text(isAdult ? 'Dewasa' : 'Anak-anak'),),
        _stepper(add: true, isAdult: isAdult),
        SizedBox(
            width: 30,
            child: Center(
                child: Text( isAdult ? '$totalPersonAdult' : '$totalPersonChild',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))),
        _stepper(add: false, isAdult: isAdult),
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

  Widget _childField() {
    return Row(
      children: <Widget>[
        Text('Anak-anak'),
        _stepper(add: true, isAdult: false),
        SizedBox(
            width: 30,
            child: Center(
                child: Text('$totalPersonChild',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))),
        _stepper(add: false, isAdult: false),
        SizedBox(
          width: 20,
        ),
        Text('Rp '),
        Spacer(
          flex: 1,
        ),
        Text('$subtotalAdult')
      ],
    );
  }

  Widget _stepper({bool isAdult, bool add}) {
    return Card(
        color: Theme.of(context).primaryColor,
        child: Container(
          width: 30,
          height: 30,
          child: InkWell(
              onTap: () {
                // add
                if (add) {
                  updateTotalPerson(add: true, isAdult: isAdult);
                } else {
                  updateTotalPerson(add: false, isAdult: isAdult);
                }
              },
              child: Center(child: add ? Icon(Icons.add) : Text('-'))),
        ));
  }
}
