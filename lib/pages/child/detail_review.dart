import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/detail/comments_response.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:dollan/utilities/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:easy_dialog/easy_dialog.dart';

class DetailReview extends StatefulWidget {
  DetailReview({this.id, this.userid});

  final String id;
  final String userid;

  @override
  _DetailReviewState createState() => _DetailReviewState();
}

class _DetailReviewState extends State<DetailReview> {
  TextEditingController _reviewController = TextEditingController();
  int rate = 3;
  List<CommentItem> comments = [];
  bool busy = false;
  bool logged = false;

  bool _pernahKomen = false;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
//    _init();
  }

  _init() {
    _checkUser();
    _getComments();
    _getCheckComment();
  }

  _checkUser() async {
//    print('userid: ${widget.userid}');
    var userid = await Helper().getUserPrefs('userid');
    if (userid == null) {
      print('user belum login');
    } else {
      print('user sudah login');
      setState(() {
        logged = true;
      });
      _getCheckComment();
    }
  }

  _getCheckComment()async {
    setState(() {
      busy=true;
    });
    await Services().checkUserComment(widget.userid, widget.id).then((res) {
//      print('cek user $userid pernah komen di post ${widget.id} $res');

      setState(() {
        busy=false;
      });

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

  _getComments() async{
    await Services().getComments(widget.id).then((res) {
      if (res.statusCode == 200) {
        CommentsResponse response = commentsResponseFromJson(res.body);
        if (response.success == 'true') {
          setState(() {
            comments = response.data;
          });
        }
      }
    });
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
      busy = true;
    });

    await Services().sendComment(review).then((res) {
      setState(() {
        busy = false;
      });
      print(res.body);
      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        if (body["success"] == "true") {
          Helper()
              .showAlert(context, 'Terima kasih atas review Anda.')
              .then((_) {
            _getComments();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review'),
      ),
      body: busy
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  logged==false?Container():
                  _pernahKomen?Container():
                  RaisedButton(
                    shape: StadiumBorder(),
                    onPressed: () => _writeReview(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.edit),
                        Text('Berikan Ulasan Anda Sekarang'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: comments.length,
                    itemBuilder: (context, pos) {
                      return _reviewItem(comments[pos]);
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _reviewItem(CommentItem item) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  width: 50,
                  height: 50,
//                  color: Colors.grey[200],
                  child: Center(
                    child:

                        // Icon(
                        //   Icons.person,
                        //   size: 40,
                        // ),

                        ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: item.photo == null
                          ? Helper().noImage()
                          : CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: '${item.photo}',
                              width: 35,
                              height: 35,
                              errorWidget: (context, string, obj) {
                                return Icon(
                                  Icons.person,
                                  size: 35,
                                );
                              },
                            ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${item.namauser}', overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.caption,),
                    Text('${item.comment}',
                        maxLines: 3, overflow: TextOverflow.ellipsis),
                        
                  ],
                ),
              )
            ],
          ),
//                        Align(
//                          alignment: Alignment.centerRight,
//                          child: Helper().createStars(context, 3),
//                        ),
        ],
      ),
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
    await
    EasyDialog(
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
}
