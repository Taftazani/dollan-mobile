import 'package:dollan/utilities/helper.dart';
import 'package:flutter/material.dart';

class OperatorProfilePage extends StatefulWidget {
  @override
  _OperatorProfilePageState createState() => _OperatorProfilePageState();
}

class _OperatorProfilePageState extends State<OperatorProfilePage> {
  bool isLoadMore = false;
  ScrollController scrollController = ScrollController();
  int totalGridItem = 4;

  showLoadMore(bool load) {
    setState(() {
      isLoadMore = load;
    });
  }

  scrollListener() {
    if (scrollController.offset == scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange && !isLoadMore) {
      setState(() {
        isLoadMore = true;        
      });
      simulateLoadMore();
    }
  }

  simulateLoadMore() async{
    await Future.delayed(Duration(seconds: 3)).then((data){
      setState((){
        totalGridItem += 2;
        print('===>>> total grid item: $totalGridItem');
        isLoadMore = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Operator'),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: size.height * 0.3,
              width: size.width,
              child: Image.asset(
                'assets/kat2.png',
                fit: BoxFit.cover,
              ),
            ),

            /// deskripsi
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'PT Nama Operator',
                    style: Helper().formatText(3),
                  ),
                  Text(
                    Helper().dummyTextShort,
                  ),
                  Helper().spacer(isVertical: true),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                      Helper().spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Jl Pegangsaan Timur No. 43'),
                          Text('Jakarta 10293'),
                        ],
                      )
                    ],
                  ),
                  Helper().spacer(isVertical: true, dist: 10),
                  Divider(),
                  Helper().spacer(isVertical: true, dist: 10),

                  /// wisata tersedia
                  Text(
                    'Wisata Yang Tersedia',
                    style: Helper().formatText(3),
                  ),
                  Helper().spacer(isVertical: true, dist: 10),
                  GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                    children: List.generate(totalGridItem, (idx) {
                      return Card(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5)),
                                child: Image.asset(
                                  'assets/images/3.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Kategori'),
                                    Helper().spacer(isVertical: true),
                                    Text(
                                      Helper().dummyTextShort,
                                      style: Helper().formatText(4),
                                      maxLines: 3,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                  ),

                  /// Load More
                  isLoadMore ?
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                      CircularProgressIndicator()
                    ],),
                  ) : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
