import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  TextEditingController _rekAsal = TextEditingController();
  TextEditingController _rekTujuan = TextEditingController();
  TextEditingController _nominal = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: GestureDetector(
        onTap: () {
          print('ontap');
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: _rekAsal,
                        decoration: InputDecoration(labelText: 'Rekening Asal'),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: _rekTujuan,
                        decoration:
                            InputDecoration(labelText: 'Rekening Tujuan'),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: _nominal,
                        decoration: InputDecoration(labelText: 'Nominal'),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: <Widget>[
                          Text('Foto Struk'),
                          Spacer(flex: 1),
                          IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.file_upload),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: Center(
                          child: Text(
                              'Tambahkan foto struk\nbukti pembayaran Anda.'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.exit_to_app),
                              Text('Checkout'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
