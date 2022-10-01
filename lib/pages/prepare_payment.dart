import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class PreparePaymentPage extends StatefulWidget {
  @override
  _PreparePaymentPageState createState() => _PreparePaymentPageState();
}

class _PreparePaymentPageState extends State<PreparePaymentPage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  _init() async {
    if (mounted) {
      ScopedModel.of<MainModel>(context).getItems(context);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return 
    
    ScopedModelDescendant<MainModel>(
      builder: (context, widget, model) {
        return Scaffold(
          // appBar: AppBar(
          //   title: Text('Title'),
          // ),
          body: Container(),
        );
      });
  }
}