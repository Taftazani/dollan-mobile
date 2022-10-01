// To parse this JSON data, do
//
//     final voucherDetailResponse = voucherDetailResponseFromJson(jsonString);

import 'dart:convert';

VoucherDetailResponse voucherDetailResponseFromJson(String str) => VoucherDetailResponse.fromJson(json.decode(str));

String voucherDetailResponseToJson(VoucherDetailResponse data) => json.encode(data.toJson());

class VoucherDetailResponse {
  String success;
  String message;
  List<VoucherDetailItem> data;

  VoucherDetailResponse({
    this.success,
    this.message,
    this.data,
  });

  factory VoucherDetailResponse.fromJson(Map<String, dynamic> json) => VoucherDetailResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<VoucherDetailItem>.from(json["data"].map((x) => VoucherDetailItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class VoucherDetailItem {
  String id;
  String soNo;
  String voucherNo;
  dynamic invoiceNo;
  String clientId;
  String travelDate;
  String pic;
  String mobile;
  String email;
  String status;
  String datumOperator;
  String postid;
  String wisata;
  String images;
  dynamic propinsi;
  dynamic kabupaten;
  List<VoucherPaket> paket;

  VoucherDetailItem({
    this.id,
    this.soNo,
    this.voucherNo,
    this.invoiceNo,
    this.clientId,
    this.travelDate,
    this.pic,
    this.mobile,
    this.email,
    this.status,
    this.datumOperator,
    this.postid,
    this.wisata,
    this.images,
    this.propinsi,
    this.kabupaten,
    this.paket,
  });

  factory VoucherDetailItem.fromJson(Map<String, dynamic> json) => VoucherDetailItem(
    id: json["id"] == null ? null : json["id"],
    soNo: json["so_no"] == null ? null : json["so_no"],
    voucherNo: json["voucher_no"] == null ? null : json["voucher_no"],
    invoiceNo: json["invoice_no"],
    clientId: json["client_id"] == null ? null : json["client_id"],
    travelDate: json["travel_date"] == null ? null : json["travel_date"],
    pic: json["pic"] == null ? null : json["pic"],
    mobile: json["mobile"] == null ? null : json["mobile"],
    email: json["email"] == null ? null : json["email"],
    status: json["status"] == null ? null : json["status"],
    datumOperator: json["operator"] == null ? null : json["operator"],
    postid: json["postid"] == null ? null : json["postid"],
    wisata: json["wisata"] == null ? null : json["wisata"],
    images: json["images"] == null ? null : json["images"],
    propinsi: json["propinsi"],
    kabupaten: json["kabupaten"],
    paket: json["paket"] == null ? null : List<VoucherPaket>.from(json["paket"].map((x) => VoucherPaket.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "so_no": soNo == null ? null : soNo,
    "voucher_no": voucherNo == null ? null : voucherNo,
    "invoice_no": invoiceNo,
    "client_id": clientId == null ? null : clientId,
    "travel_date": travelDate == null ? null : travelDate,
    "pic": pic == null ? null : pic,
    "mobile": mobile == null ? null : mobile,
    "email": email == null ? null : email,
    "status": status == null ? null : status,
    "operator": datumOperator == null ? null : datumOperator,
    "postid": postid == null ? null : postid,
    "wisata": wisata == null ? null : wisata,
    "images": images == null ? null : images,
    "propinsi": propinsi,
    "kabupaten": kabupaten,
    "paket": paket == null ? null : List<dynamic>.from(paket.map((x) => x.toJson())),
  };
}

class VoucherPaket {
  String id;
  String headerId;
  String postid;
  String packageId;
  String price;
  String qty;
  String totPrice;
  String packagename;
  String quota;
  String productname;

  VoucherPaket({
    this.id,
    this.headerId,
    this.postid,
    this.packageId,
    this.price,
    this.qty,
    this.totPrice,
    this.packagename,
    this.quota,
    this.productname,
  });

  factory VoucherPaket.fromJson(Map<String, dynamic> json) => VoucherPaket(
    id: json["id"] == null ? null : json["id"],
    headerId: json["header_id"] == null ? null : json["header_id"],
    postid: json["postid"] == null ? null : json["postid"],
    packageId: json["package_id"] == null ? null : json["package_id"],
    price: json["price"] == null ? null : json["price"],
    qty: json["qty"] == null ? null : json["qty"],
    totPrice: json["tot_price"] == null ? null : json["tot_price"],
    packagename: json["packagename"] == null ? null : json["packagename"],
    quota: json["quota"] == null ? null : json["quota"],
    productname: json["productname"] == null ? null : json["productname"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "header_id": headerId == null ? null : headerId,
    "postid": postid == null ? null : postid,
    "package_id": packageId == null ? null : packageId,
    "price": price == null ? null : price,
    "qty": qty == null ? null : qty,
    "tot_price": totPrice == null ? null : totPrice,
    "packagename": packagename == null ? null : packagename,
    "quota": quota == null ? null : quota,
    "productname": productname == null ? null : productname,
  };
}
