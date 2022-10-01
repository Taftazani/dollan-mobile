import 'package:flutter/material.dart';

class PaymentGateway extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Gateway'),
      ),
      body: Center(
        child: Text('Proses pembayaran disini...')
      ),
      bottomNavigationBar: Container(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(child: Text('TUTUP'), onPressed: (){
          Navigator.of(context).pushNamed('home');
        },),
      ),),
    );
  }
}