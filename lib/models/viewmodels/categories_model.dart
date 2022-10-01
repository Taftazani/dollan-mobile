import 'package:dollan/models/catmood/cat_mood_response.dart';
import 'package:dollan/templates/RouteArguments.dart';
import 'package:dollan/utilities/services.dart';
import 'package:scoped_model/scoped_model.dart';

class CategoriesModel extends Model {
  
  bool _busy = false;
  List<CatMoodItem> _categories = [];
  CatMoodResponse _catMoodResponse;
  CatMoodResponse get catMoodResponse => _catMoodResponse;
  List<CatMoodItem> get categories => _categories;

  bool get busy => _busy;

  getContent(RouteArguments args) async {
    _busy = true;
    notifyListeners();

    print('catmod: ${args.id}');

    await Services().getCatMood(

        // id: id, search: search, adventure: adventure, price: price, kota: kota, page: page

        args).then((res) {
      _busy = false;
      notifyListeners();

      if (res.statusCode == 200) {
        _catMoodResponse = catMoodResponseFromJson(res.body);
        _categories = catMoodResponse.data;
        notifyListeners();
        print(_categories);
      } else {
        print(res.statusCode);
      }
    }).catchError((err) {
      _busy = false;
      notifyListeners();
    });
  }
}
