// To parse this JSON data, do
//
//     final cartResponse = cartResponseFromJson(jsonString);

import 'dart:convert';

CartResponse cartResponseFromJson(String str) => CartResponse.fromJson(json.decode(str));

String cartResponseToJson(CartResponse data) => json.encode(data.toJson());

class CartResponse {
    String success;
    String message;
    List<CartItem> data;

    CartResponse({
        this.success,
        this.message,
        this.data,
    });

    factory CartResponse.fromJson(Map<String, dynamic> json) => new CartResponse(
        success: json["success"],
        message: json["message"],
        data: new List<CartItem>.from(json["data"].map((x) => CartItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": new List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class CartItem {
    String id;
    String soNo;
    dynamic voucherNo;
    dynamic invoiceNo;
    String clientId;
    String travelDate;
    dynamic pic;
    dynamic mobile;
    dynamic email;
    String status;
    String datumOperator;
    String wisata;
    String images;
    String propinsi;
    String kabupaten;
    List<Paket> paket;
    String postId;

    CartItem({
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
        this.wisata,
        this.images,
        this.propinsi,
        this.kabupaten,
        this.paket,
        this.postId,
    });

    factory CartItem.fromJson(Map<String, dynamic> json) => new CartItem(
        id: json["id"],
        soNo: json["so_no"],
        voucherNo: json["voucher_no"],
        invoiceNo: json["invoice_no"],
        clientId: json["client_id"],
        travelDate: json["travel_date"],
        pic: json["pic"],
        mobile: json["mobile"],
        email: json["email"],
        status: json["status"],
        datumOperator: json["operator"],
        wisata: json["wisata"],
        images: json["images"],
        propinsi: json["propinsi"],
        kabupaten: json["kabupaten"],
        paket: new List<Paket>.from(json["paket"].map((x) => Paket.fromJson(x))),
        postId: json["postid"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "so_no": soNo,
        "voucher_no": voucherNo,
        "invoice_no": invoiceNo,
        "client_id": clientId,
        "travel_date": travelDate,
        "pic": pic,
        "mobile": mobile,
        "email": email,
        "status": status,
        "operator": datumOperator,
        "wisata": wisata,
        "images": images,
        "propinsi": propinsi,
        "kabupaten": kabupaten,
        "paket": new List<dynamic>.from(paket.map((x) => x.toJson())),
        "postid":postId,
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
    String packagename;
    String quota;

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
    });

    factory Paket.fromJson(Map<String, dynamic> json) => new Paket(
        id: json["id"],
        headerId: json["header_id"],
        postid: json["postid"],
        packageId: json["package_id"],
        price: json["price"],
        qty: json["qty"],
        totPrice: json["tot_price"],
        packagename: json["packagename"] == null ? null : json["packagename"],
        quota: json["quota"] == null ? null : json["quota"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "header_id": headerId,
        "postid": postid,
        "package_id": packageId,
        "price": price,
        "qty": qty,
        "tot_price": totPrice,
        "packagename": packagename == null ? null : packagename,
        "quota": quota == null ? null : quota,
    };
}
