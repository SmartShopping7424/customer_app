class CartModel {
  int? id;
  String? productBarcode;
  String? productName;
  String? productCategory;
  String? productSubCategory;
  int? productMrp;
  int? productSellingPrice;
  String? productImage;
  int? productOffer;
  int? productOfferType;
  String? productDiscount;
  int? productPackCount;
  int? productPackPrice;
  int? productQuantity;

  CartModel(
      {this.id,
      this.productBarcode,
      this.productName,
      this.productCategory,
      this.productSubCategory,
      this.productMrp,
      this.productSellingPrice,
      this.productImage,
      this.productOffer,
      this.productOfferType,
      this.productDiscount,
      this.productPackCount,
      this.productPackPrice,
      this.productQuantity});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productBarcode = json['product_barcode'];
    productName = json['product_name'];
    productCategory = json['product_category'];
    productSubCategory = json['product_sub_category'];
    productMrp = json['product_mrp'];
    productSellingPrice = json['product_selling_price'];
    productImage = json['product_image'];
    productOffer = json['product_offer'];
    productOfferType = json['product_offer_type'];
    productDiscount = json['product_discount'];
    productPackCount = json['product_pack_count'];
    productPackPrice = json['product_pack_price'];
    productQuantity = json['product_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_barcode'] = this.productBarcode;
    data['product_name'] = this.productName;
    data['product_category'] = this.productCategory;
    data['product_sub_category'] = this.productSubCategory;
    data['product_mrp'] = this.productMrp;
    data['product_selling_price'] = this.productSellingPrice;
    data['product_image'] = this.productImage;
    data['product_offer'] = this.productOffer;
    data['product_offer_type'] = this.productOfferType;
    data['product_discount'] = this.productDiscount;
    data['product_pack_count'] = this.productPackCount;
    data['product_pack_price'] = this.productPackPrice;
    data['product_quantity'] = this.productQuantity;
    return data;
  }
}
