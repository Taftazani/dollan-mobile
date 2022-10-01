import 'package:scoped_model/scoped_model.dart';

class MapModel extends Model{
  bool _getLocation = false;
  double _lat = 0.0;
  double _lng = 0.0;

  bool get getLocation => _getLocation;
  double get lat => _lat;
  double get lng => _lng;

  updateLocationStatus({double lat, double lng}){
    _lat = lat;
    _lng = lng;
    _getLocation = true;
    notifyListeners();
  }

}