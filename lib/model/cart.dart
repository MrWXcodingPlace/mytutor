class Cart {
  String? cartid;
  String? subjectname;
  String? subjectqty;
  String? price;
  String? cartqty;
  String? subjectid;
  String? pricetotal;

  Cart(
      {this.cartid,
      this.subjectname,
      this.subjectqty,
      this.price,
      this.cartqty,
      this.subjectid,
      this.pricetotal});

  Cart.fromJson(Map<String, dynamic> json) {
    cartid = json['cartid'];
    subjectname = json['subjectname'];
    subjectqty = json['subjectqty'];
    price = json['price'];
    cartqty = json['cartqty'];
    subjectid = json['subjectid'];
    pricetotal = json['pricetotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cartid'] = cartid;
    data['subjectname'] = subjectname;
    data['subjectqty'] = subjectqty;
    data['price'] = price;
    data['cartqty'] = cartqty;
    data['subjectid'] = subjectid;
    data['pricetotal'] = pricetotal;
    return data;
  }
}
