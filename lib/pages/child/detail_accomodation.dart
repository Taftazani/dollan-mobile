import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/detail/comments_response.dart';
import 'package:dollan/models/detail/detail_product_model.dart';
import 'package:dollan/models/detail/kamusuka_response.dart';
import 'package:dollan/models/detail/wisatasejenis_response.dart';
import 'package:dollan/models/viewmodels/main_model.dart';
import 'package:dollan/pages/detail.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/templates/list_item.dart';
import 'package:dollan/templates/list_item_accomodation.dart';
import 'package:dollan/templates/list_item_col_simple.dart';
import 'package:dollan/templates/list_item_detail.dart';
import 'package:dollan/templates/list_item_kamusuka.dart';
import 'package:dollan/utilities/apis.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:dollan/utilities/styles.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:scoped_model/scoped_model.dart';

class DetailAccomodation extends StatefulWidget {
  DetailAccomodation({this.id, this.item, this.func});

  final String id;
  final DetailProductItem item;
  final Function func;

  @override
  _DetailAccomodationState createState() => _DetailAccomodationState();
}

class _DetailAccomodationState extends State<DetailAccomodation> {
  bool showMore = false;
  String showMoreText = 'lebih banyak...';
  int _totalItems = 2;
  double _itemHeight = 120;
  bool adadata = false;
  bool belumLogin = false;
  bool _pernahKomen = false;

  List<WisataSejenisItem> items = [];
  List<CommentItem> comments = [];
  List<KamuSukaItem> kamusukas = [];

  TextEditingController _reviewController = TextEditingController();
  int rate = 3;
  String userid;

  bool sendingReview;

  _showMoreText() {
    setState(() {
      showMore = !showMore;
      print('----> showMore: $showMore');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _itemHeight = _itemHeight * _totalItems;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  _init() async {
    print('xxx catId: ${widget.item.catid}');
    userid = await Helper().getUserPrefs('userid');
    if (userid == null) {
      setState(() {
        belumLogin = true;
      });
    }

    if(mounted){
      _getWisataSejenis();
      _getKamuSuka();
      if (userid != null) _getCheckComment();
      _getComments();
    }

  }

  _getWisataSejenis() {
    print('_getWisataSejenis catname: ${widget.item.catname}');
    Services().getDetailAccomodation(widget.item.catname).then((res) {
      if (res.statusCode == 200) {
        WisataSejenisResponse response =
            wisataSejenisResponseFromJson(res.body);
        if (response.success == 'true') {
          setState(() {
            items = response.data;
          });
        }
      }
    });
  }

  _getKamuSuka() async {
    var userid = await Helper().getUserPrefs('userid');
    Services().getKamuSuka(userid).then((res) {
      if (res.statusCode == 200) {
        KamuSukaResponse response = kamuSukaResponseFromJson(res.body);
        if (response.success == 'true') {
          setState(() {
            kamusukas = response.data;
          });
        }
      }
    });
  }

  _getComments() {
    Services().getComments(widget.id).then((res) {
      if (res.statusCode == 200) {
        CommentsResponse response = commentsResponseFromJson(res.body);
        if (response.success == 'true') {
          setState(() {
            comments = response.data;
          });
          _getKamuSuka();
        }
      }
    });
  }

  _getCheckComment() {
    Services().checkUserComment(userid, widget.id).then((res) {
      print('cek user $userid pernah komen di post ${widget.id} $res');
      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        print(body);
        if (body['success'] == 'true') {
          print('pernah komen');
          setState(() {
            _pernahKomen = true;
          });
        } else {
          print('belum pernah komen');
        }
      }
    });
  }

  // review
  Widget _rate({double stars, bool ignore, double size = 15}) {
    return Row(
      children: <Widget>[
        FlutterRatingBar(
          itemSize: size,
          ignoreGestures: ignore,
          initialRating: stars,
          fillColor: Colors.amber,
          borderColor: Colors.amber.withAlpha(50),
          allowHalfRating: false,
          onRatingUpdate: (rating) {
            setState(() {
              rate = rating.toInt();
            });
          },
        )
      ],
    );
  }

  Widget _review() {
    return TextField(
      decoration: InputDecoration(labelText: 'Berikan ulasan Anda'),
      controller: _reviewController,
      maxLength: 200,
      maxLines: 3,
    );
  }

  _writeReview() async {
    var userid = await Helper().getUserPrefs('userid');
    if (userid == null) {
      Helper().showAlert(context, 'Harap Login Terlebih Dahulu').then((res) {
        if (res) {
          Navigator.of(context).pushReplacementNamed('login');
        }
      });
    }

    bool saveReview = false;
    await EasyDialog(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.35,
        contentList: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _rate(stars: 3, ignore: false, size: 30),
                ],
              ),
              _review(),
            ],
          ),
          Expanded(
            child: Container(),
          ),
          Row(
            children: <Widget>[
              FlatButton(
                child: Text('Simpan', style: Styles().button()),
                onPressed: () {
                  saveReview = true;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  'Batal',
                  style: Styles().button(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
//                _sendReview();
                },
              ),
            ],
          ),
        ]).show(context);
    if (saveReview) {
      _sendReview();
    }
  }

  _sendReview() async {
    var userid = await Helper().getUserPrefs('userid');
    var username = await Helper().getUserPrefs('username');

    print(username);

    Map<String, dynamic> review = {
      'iduser': userid,
      'postid': widget.id,
      'rating': rate.toString(),
      'message': _reviewController.text,
      'commentparent': ''
    };

    setState(() {
      sendingReview = true;
    });

    await Services().sendComment(review).then((res) {
      setState(() {
        sendingReview = false;
      });
      print(res.body);
      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        if (body["success"] == "true") {
          Helper()
              .showAlert(context, 'Terima kasih atas review Anda.')
              .then((_) {
            _getCheckComment();
            _getComments();
          });
        }
      }
    });
  }

  //

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Review',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          comments == null || comments.length == 0
              ? Container(
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: <Widget>[
                          Text('Belum ada review. '),
                          // _pernahKomen
                          //     ? Container()
                          //     : FlatButton(
                          //         child: Text(
                          //           'Review Sekarang',
                          //           style: TextStyle(color: Colors.red),
                          //         ),
                          //         onPressed: () {
                          //           _writeReview();
                          //         },
                          //       )
                        ],
                      )),
                )
              : Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: IgnorePointer(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: comments.length > 2 ? 2 : comments.length,
                      itemBuilder: (context, pos) {
                        CommentItem item = comments[pos];
                        String photo = item.photo;
//                        print('photo reviewer: ${Apis.baseUrl}${item.photo}');
                        // print('reiewer photo: ${Apis.baseUrl}${item.photo}');
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, bottom: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      width: 50,
                                      height: 50,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: item.photo == null
                                            ? Helper().noImage()
                                            : CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: '${item.photo}',
                                                width: 35,
                                                height: 35,
                                                errorWidget:
                                                    (context, string, obj) {
                                                  return Icon(
                                                    Icons.person,
                                                    size: 35,
                                                  );
                                                },
                                              ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(item.namauser,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption,
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            Text(item.comment,
                                                maxLines: 4,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ],
                                        )),
                                  )
                                ],
                              ),
//                              Align(
//                                alignment: Alignment.centerRight,
//                                child: Helper().createStars(context, 3),
//                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child:
//                comments == null || comments.length == 0
//                    ? Container(
//                        height: 15,
//                      )
//                    :

//                _pernahKomen
//                        ? Container()
//                        :

                    Row(
                  children: <Widget>[
                    belumLogin||_pernahKomen?Container():
                    FlatButton(
                      padding: EdgeInsets.only(left: 20),
                      onPressed: () {
                        _writeReview();
                      },
                      child: Text(
                        'Berikan Review Anda',
                        style: TextStyle(color: Colors.red, fontSize: size.width*0.035),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    comments.length==0 || comments==null ? Container() : FlatButton(
                      padding: EdgeInsets.only(left: 20),
                      onPressed: () {
                        Navigator.of(context).pushNamed('review',
                            arguments: RouteArguments(id: widget.id, userid: userid ));
                      },
                      child: Text(
                        'Lihat Review Lainnya',
                        style: TextStyle(color: Colors.blue, fontSize: size.width*0.035),
                      ),
                    ),
                  ],
                ),
              )),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Helper().separator(isHorizontal: true, height: 0),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: _wisataSejenis('Wisata Sejenis', size, widget.func),
          ),
          _kamusuka('Kamu Suka')
        ],
      ),
    );
  }

  Widget _kamusuka(String title) {
    var titles = [
      'Arung Jeram',
      'Paralayang',
      'Camping',
      'Flying Fox',
      'Canoe',
      'Balon Udara'
    ];
    return Column(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 20, bottom: 0, top: 20, right: 10),
          child: Row(
            children: <Widget>[
              Text(
                '$title',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        kamusukas.length == 0 || kamusukas == null
            ? Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Tidak ada data saat ini'),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(kamusukas.length, (index) {
                        KamuSukaItem item = kamusukas[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0, left: 10),
                          child: Container(
                            width: 100,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: ListItemKamuSuka(
                                index: index,
                                item: item,
                              ),
                            ),
                          ),
                        );
                      })),
                ),
              ),
      ],
    );
  }

  Widget _wisataSejenis(String title, Size size, Function func) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '$title',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          items == null || items.length == 0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Tidak ada data saat ini'),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 10),
                    childAspectRatio: 0.5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: List.generate(items.length > 4 ? 4 : items.length,
                        (_index) {
                      return InkWell(
                        onTap: () {
//                    Navigator.of(context).pushNamed('categories',
//                        arguments: RouteArguments(page:0, id: items[_index].catname, title: items[_index].catname));
                          // Navigator.of(context).pushNamed('detail',
                          //     arguments: RouteArguments(id: items[_index].id));

                          func();

                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=>DetailPage(id: items[_index].id,))
                              );
                        },
                        child: Container(
                          color: Colors.white,
                          child: ListItemAccomodation(_index, items[_index], size),
                        ),
                      );
                    }),
                  ),
                ),
          items == null || items.length == 0
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'Lainnya',
                        style: TextStyle(
                            color: Color(0xff5764fc),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        ScopedModel.of<MainModel>(context).setSearchCatmod(widget.item.catid);
                        Navigator.of(context).pushNamed('categories',
                            arguments: RouteArguments(
                              page: '',
                              id: widget.item.catid,
                              title: 'Lainnya',
                            ));
                      },
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Color(0xff5764fc),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
