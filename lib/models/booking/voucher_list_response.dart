// To parse this JSON data, do
//
//     final voucherListResponse = voucherListResponseFromJson(jsonString);

import 'dart:convert';

VoucherListResponse voucherListResponseFromJson(String str) => VoucherListResponse.fromJson(json.decode(str));

String voucherListResponseToJson(VoucherListResponse data) => json.encode(data.toJson());

class VoucherListResponse {
    String success;
    String message;
    List<VoucherItem> data;

    VoucherListResponse({
        this.success,
        this.message,
        this.data,
    });

    factory VoucherListResponse.fromJson(Map<String, dynamic> json) => VoucherListResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : List<VoucherItem>.from(json["data"].map((x) => VoucherItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class VoucherItem {
    String id;
    String soNo;
    dynamic voucherNo;
    dynamic invoiceNo;
    String clientId;
    String travelDate;
    String pic;
    String mobile;
    String email;
    String status;
    String VoucherItemOperator;
    String postid;
    String wisata;
    String images;
    String propinsi;
    String kabupaten;
    List<Paket> paket;

    VoucherItem({
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
        this.VoucherItemOperator,
        this.postid,
        this.wisata,
        this.images,
        this.propinsi,
        this.kabupaten,
        this.paket,
    });

    factory VoucherItem.fromJson(Map<String, dynamic> json) => VoucherItem(
        id: json["id"] == null ? null : json["id"],
        soNo: json["so_no"] == null ? null : json["so_no"],
        voucherNo: json["voucher_no"],
        invoiceNo: json["invoice_no"],
        clientId: json["client_id"] == null ? null : json["client_id"],
        travelDate: json["travel_date"] == null ? null : json["travel_date"],
        pic: json["pic"] == null ? null : json["pic"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        email: json["email"] == null ? null : json["email"],
        status: json["status"] == null ? null : json["status"],
        VoucherItemOperator: json["operator"] == null ? null : json["operator"],
        postid: json["postid"] == null ? null : json["postid"],
        wisata: json["wisata"] == null ? null : json["wisata"],
        images: json["images"] == null ? null : json["images"],
        propinsi: json["propinsi"] == null ? null : json["propinsi"],
        kabupaten: json["kabupaten"] == null ? null : json["kabupaten"],
        paket: json["paket"] == null ? null : List<Paket>.from(json["paket"].map((x) => Paket.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "so_no": soNo == null ? null : soNo,
        "voucher_no": voucherNo,
        "invoice_no": invoiceNo,
        "client_id": clientId == null ? null : clientId,
        "travel_date": travelDate == null ? null : travelDate,
        "pic": pic == null ? null : pic,
        "mobile": mobile == null ? null : mobile,
        "email": email == null ? null : email,
        "status": status == null ? null : status,
        "operator": VoucherItemOperator == null ? null : VoucherItemOperator,
        "postid": postid == null ? null : postid,
        "wisata": wisata == null ? null : wisata,
        "images": images == null ? null : images,
        "propinsi": propinsi == null ? null : propinsi,
        "kabupaten": kabupaten == null ? null : kabupaten,
        "paket": paket == null ? null : List<dynamic>.from(paket.map((x) => x.toJson())),
    };
}

class Paket {
    String id;
    String headerId;
    String postid;
    String packageId;
    String price;
    String qty;
    String totPrice;
    dynamic packagename;
    dynamic quota;
    String productname;

    Paket({
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

    factory Paket.fromJson(Map<String, dynamic> json) => Paket(
        id: json["id"] == null ? null : json["id"],
        headerId: json["header_id"] == null ? null : json["header_id"],
        postid: json["postid"] == null ? null : json["postid"],
        packageId: json["package_id"] == null ? null : json["package_id"],
        price: json["price"] == null ? null : json["price"],
        qty: json["qty"] == null ? null : json["qty"],
        totPrice: json["tot_price"] == null ? null : json["tot_price"],
        packagename: json["packagename"],
        quota: json["quota"],
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
        "packagename": packagename,
        "quota": quota,
        "productname": productname == null ? null : productname,
    };
}
