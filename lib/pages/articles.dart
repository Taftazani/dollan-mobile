import 'package:cached_network_image/cached_network_image.dart';
import 'package:dollan/models/home/articles_model.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:dollan/utilities/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ArticlesPage extends StatefulWidget {
  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  List<ArticleItem> _articles;
  bool busy = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadArticles();
  }

  _loadArticles() async {
    setState(() {
      busy = true;
    });
    http.Response res = await Services().getArticles();
    if (res.statusCode == 200) {
      setState(() {
        busy = false;
      });
      var data = articleResponseFromJson(res.body);
      if (data.success == 'true') {
        setState(() {
          _articles = data.data;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Voice of Community'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: busy
            ? Helper().busyIndicator(context, size)
            : GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
                children: List.generate(_articles.length, (pos) {
                  ArticleItem item = _articles[pos];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('detail',
                          arguments: RouteArguments(id: item.dataId));
                    },
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5)),
                              child: CachedNetworkImage(
                                imageUrl: '${item.image}',
                                placeholder: (context, url) => Center(
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                ),
                                height: 100,
                                width: double.infinity,
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      item.title,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
      ),
    );
  }
}
