import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/home/mood_all_model.dart';
import 'package:dollan/models/home/mood_model.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

class OtherCatPage extends StatefulWidget {
  @override
  _OtherCatPageState createState() => _OtherCatPageState();
}

class _OtherCatPageState extends State<OtherCatPage> {
  List<AllMoodItem> _moods;

  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  _init() async {
    http.Response res = await Services().getAllMoods();
    if (res.statusCode == 200) {
      var data = allMoodResponseFromJson(res.body);
      setState(() {
        _moods = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text('Mood (${_moods.length})'),
        ),
        body: _moods==null?Container(): bodyWidget(size));
  }

  Widget bodyWidget(Size size) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: GridView.count(
//            childAspectRatio: 0.7,
            crossAxisCount: 2,
            children: List.generate(_moods.length, (pos){
              AllMoodItem item = _moods[pos];
              return GestureDetector(
                  onTap: () {
                    model.setSearchCatmod(item.id);

                    Helper().goToPage(
                        context: context,
                        type: 'mood',
                        args: RouteArguments(
                            page: '',
                            linkType: 'mood',
                            id: '',
                            title: item.name));
                  },
                  child:
                  _circle(item.name, item.image, size));
            }),
          ),
        );
      },
    );



  }

  Widget _circle(String title, String img, Size size) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[850],
                    offset: Offset(1, 1),
                    blurRadius: 2)
              ],
            ),
            width: size.width*0.3,
            height: size.width*0.3,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: img == ''
                    ? Container()
                    : Padding(
                  padding: EdgeInsets.all(0),
                  child: CachedNetworkImage(
                    imageUrl: '$img',
                    fit: BoxFit.cover,
                    placeholder: (context, string) {
                      return Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                  'assets/logo-dolan-icon.png'),
                            ),
                          ));
                    },
                  ),

                  // Image.network(
                  //   '$img',
                  //   fit: BoxFit.cover,
                  // ),
                )),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: size.width*0.035,
                color: title == 'Lainnya' ? Colors.white : Colors.grey[600]),
          )
        ],
      ),
    );
  }
}
