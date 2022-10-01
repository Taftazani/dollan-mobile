import 'package:dollan/models/city_response.dart';
import 'package:dollan/models/home/mood_model.dart';
import 'package:dollan/models/propinsi_response.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:dollan/models/viewmodels/search_model.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;

class SearchPage extends StatefulWidget {
  SearchPage({this.args});
  // final String title;
  final RouteArguments args;
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _searchKotaController = TextEditingController();
  String filter = '';
  bool showkota = false;
  final formatter = new NumberFormat('#,###', 'id_ID');
  RangeValues _values = RangeValues(500000.0, 2500000.0);

  // double slideValue = 10.0;
  // double slideValuePrice = 100000.0;
  // String kota;
  // List<bool> moodState = [];

  @override
  void initState() {
    super.initState();
    _searchKotaController.addListener(() {
      ScopedModel.of<MainModel>(context)
          .updateFilter(_searchKotaController.text);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _initSearch());
  }

  @override
  void dispose() {
    super.dispose();
    _searchKotaController.dispose();
    _cityController.dispose();
    _searchController.dispose();
  }

  _initSearch() async {
//    Intl.defaultLocale = 'id_ID';

    ScopedModel.of<MainModel>(context).initSearch();
  }

  _clearSearch() {
    setState(() {
      _searchController.text = "";
    });
  }

  _reset() {
    // Navigator.of(context).pushReplacementNamed('search');
    ScopedModel.of<MainModel>(context).resetFilter();
  }

  

  // showProvinces(MainModel model) {
  //   print('show propinsi');
  //   showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: context,
  //       builder: (builder) {
  //         return Container(
  //           child: SingleChildScrollView(
  //             child: ListView.builder(
  //                 physics: NeverScrollableScrollPhysics(),
  //                 shrinkWrap: true,
  //                 itemCount: model.provinces.length,
  //                 itemBuilder: (context, pos) {
  //                   PropinsiResponse item = model.provinces[pos];
  //                   return ListTile(
  //                     title: Text(item.name),
  //                     onTap: () {
  //                       model.setPropinsi(item.id, pos);
  //                       Navigator.of(context).pop();
  //                     },
  //                   );
  //                 }),
  //           ),
  //           padding: EdgeInsets.all(40.0),
  //         );
  //       });
  // }

  showCities(MainModel model) {
    // print('show kota');
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Column(
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 30),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onChanged: (s){
                          setState(() {
                            
                          });
                        },
                        controller: _searchKotaController,
                        decoration: InputDecoration(labelText: 'Cari Kota'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(  
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: model.cities.length,
                      itemBuilder: (context, pos) {
                        CityResponse item = model.cities[pos];
                        return filter == null || filter == ''
                            ? ListTile(
                                title: Text(item.name),
                                onTap: () {
                                  model.setKota(item.id, pos);
                                  Navigator.of(context).pop();
                                },
                              )
                            : item.name.contains(filter)
                                ? ListTile(
                                    title: Text(item.name),
                                    onTap: () {
                                      model.setKota(item.id, pos);
                                      Navigator.of(context).pop();
                                    },
                                  )
                                : Container();
                      }),
                ),
                // padding: EdgeInsets.all(40.0),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return model.moodStates == null || model.moodStates.length == 0
            ? Container()
            : Scaffold(
                backgroundColor: Colors.grey[100],
                body: SafeArea(
                    minimum: EdgeInsets.only(top: 32),
                    top: true,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Column(
                          children: <Widget>[
                            // _searchBox(),
                            _moods(model),
                            _adventureLevel(model),
                            _priceLevel(model),
                            // _propinsi(model),
                            _kota(model),
                            SizedBox(
                              height: 100,
                            ),
                            //

                            //
                          ],
                        ),
                      ),
                    )),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[_filter(model), _resetfilter(model)],
                  ),
                ),
              );
      },
    );
  }

  Widget _filter(MainModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        // model.useFilter(context, widget.args.title);
      },
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        height: 35,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color(0x33000000),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 3)),
            ],
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(context).primaryColor),
        child: Center(
            child: Text('Gunakan Filter', style: TextStyle(fontSize: 16))),
      ),
    );
  }

  Widget _resetfilter(MainModel model) {
    return GestureDetector(
      onTap: () {
        _reset();
//        ScopedModel.of<MainModel>(context).init();
      },
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        height: 35,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color(0x33000000),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 3)),
            ],
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(context).primaryColor),
        child:
            Center(child: Text('Reset Filter', style: TextStyle(fontSize: 16))),
      ),
    );
  }

  Widget _moods(MainModel model) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 12),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Text(
                    'Jenis Aktivitas',
                    style: TextStyle(fontSize: 18),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              )),
        ),
        model.moods == null ? Container() : _categories(model),
      ],
    );
  }

  Widget _adventureLevel(MainModel model) {
    return Card(
      margin: EdgeInsets.only(left: 12, right: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Adventure',
                  style: TextStyle(fontSize: 18),
                ),
                Spacer(),
                Text(
                  '${model.slideValue.round()}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Slider(
              min: 0,
              max: 5,
              value: model.adventure.toDouble(),
              onChanged: (pos) {
                print('--->>> pos: $pos');
                model.setAdventure(pos.toInt());
                // setState(() => slideValue = pos);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Ringan',
                    style: TextStyle(color: Colors.blue),
                  ),
                  Spacer(),
                  Text(
                    'Menantang',
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _priceLevel(MainModel model) {
    return Card(
      margin: EdgeInsets.only(top: 20, left: 12, right: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Harga',
                  style: TextStyle(fontSize: 18),
                ),
                // Spacer(),
                // Text(
                //   'Rp ${formatter.format(model.slideValuePrice.round())}',
                //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                // )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            // Slider(
            //   min: 0,
            //   max: 5000000,
            //   value: model.slideValuePrice.toDouble(),
            //   onChanged: (pos) {
            //     print('--->>> pos: $pos');
            //     // updatePos(pos);
            //     model.setPrice(pos.toInt());
            //     // setState(() => slideValuePrice = pos);
            //   },
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Rp ${formatter.format(_values.start.round())}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  ' - ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp ${formatter.format(_values.end.round())}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )
              ],
            ),
            RangeSlider(
              min: 0,
              max: 5000000,
              values: _values,
              onChanged: (values) {
                setState(() {
                  _values = values;
                  model.setPrice(_values.start.round().toInt(),
                      _values.end.round().toInt());
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Murah',
                  ),
                  Spacer(),
                  Text(
                    'Mahal',
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _circle(int idx, MoodItem item, MainModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          // Container(
          //   decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       // color: Colors.white,
          //       border: Border.all(
          //           width: 1, color: Theme.of(context).primaryColor)),
          //   width: 60,
          //   height: 60,
          //   child: ClipRRect(
          //       borderRadius: BorderRadius.circular(50),
          //       child: Image.asset(
          //         'assets/$id',
          //         fit: BoxFit.cover,
          //       )),
          // ),
          Chip(
            backgroundColor: model.moodStates[idx] == true
                ? Theme.of(context).primaryColor
                : Colors.grey[200],
            label: Text(
              item.title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          // SizedBox(
          //   height: 8,
          // ),
          // Text(
          //   title,
          //   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          // )
        ],
      ),
    );
  }

  Widget _categories(MainModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: List.generate(model.moods.length, (idx) {
          MoodItem item = model.moods[idx];
          return GestureDetector(
              onTap: () {
                model.setMood(idx);
              },
              child: _circle(idx, item, model));
        })),
      ),
    );
  }

  //_circle('Anak', 'kat6.png'),

  // Widget _propinsi(MainModel model) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 12.0, right: 12, top: 24),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Text(
  //           'Propinsi',
  //           style: TextStyle(fontSize: 18),
  //         ),
  //         Helper().spacer(isVertical: true),
  //         Row(
  //           children: <Widget>[
  //             Expanded(
  //               child: GestureDetector(
  //                 child: Container(
  //                   padding: EdgeInsets.all(10),
  //                   decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       border: Border.all(color: Colors.grey),
  //                       borderRadius: BorderRadius.circular(10)),
  //                   child: Row(
  //                     children: <Widget>[
  //                       Text(
  //                         '${model.propinsi}',
  //                         style: TextStyle(fontSize: 18),
  //                       ),
  //                       Spacer(),
  //                       Icon(
  //                         Icons.arrow_drop_down,
  //                         size: 30,
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 onTap: () {
  //                   if(model.provinces.length>0) {
  //                     showProvinces(model);
  //                   }

  //                   // func(model);
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _kota(MainModel model) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12, top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Kota',
            style: TextStyle(fontSize: 18),
          ),
          Helper().spacer(isVertical: true),
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '${model.kota}',
                          style: TextStyle(fontSize: 18),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    if (model.cities.length > 0) {
                      showCities(model);
                    }
                    // func(model);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
