import 'package:dollan/pages/profile_transaction_history.dart';
import 'package:scoped_model/scoped_model.dart';

class TransactionHistoryModel extends Model {
  int _totalPurchase = 0;
  // List<HistoryItem> _items = [];

  int get totalPurchase => _totalPurchase;
  // List<HistoryItem> get items => _items;

  // getItems() {
  //   _items.add(HistoryItem(
  //       title: 'Wisata Arung Jeram',
  //       adultTotal: 1,
  //       childTotal: 1,
  //       subtotal: 999,
  //       type: 1));
  //   notifyListeners();

  //   _items.add(HistoryItem(
  //       title: 'Wisata Camping', adultTotal: 3, childTotal: 0, subtotal: 999, type: 2));
    
  //   notifyListeners();

  //   _items.add(HistoryItem(
  //       title: 'Wisata Camping', adultTotal: 3, childTotal: 0, subtotal: 999, type: 3));
    
  //   notifyListeners();
  // }

  // updateTotalPurchase({int idx, int price}){
  //   _totalPurchase = 0;

  //   _items[idx].subtotal = price;

  //   for(int i=0; i<_items.length; i++){
  //     _totalPurchase += _items[i].subtotal;
  //   }

  //   notifyListeners();
  // }
}
