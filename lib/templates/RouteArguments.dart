import 'package:dollan/models/booking/voucher_list_response.dart';
import 'package:dollan/models/detail/detail_product_model.dart';

class RouteArguments {
  final bool poi;
  final String id;
  final String title;
  final String type;
  final String url;
  final String companyId;
  final String mood;
  final String search;
  final String adventure;
  final String price;
  final String kota;
  final String page;
  final String catmod;
  final String linkType;
  final String sort;
  final VoucherItem voucherItem;
  final bool viewCart;
  final String userid;
  final DetailProductItem detail;
  final Map map;
  final int tabIndex;

  RouteArguments({this.tabIndex, this.map, this.detail, this.userid,this.viewCart=false,this.voucherItem,this.sort,this.linkType,this.poi, this.id, this.title, this.type, this.url, this.companyId, this.mood, this.search, this.adventure, this.price, this.kota, this.page, this.catmod});
}