class ShopModel {
  int? id;
  String? shopId;
  String? shopName;
  double? shopLatitude;
  double? shopLongitude;
  int? distance;

  ShopModel(
      {this.id,
      this.shopId,
      this.shopName,
      this.shopLatitude,
      this.shopLongitude,
      this.distance});

  ShopModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    shopName = json['shop_name'];
    shopLatitude = json['shop_latitude'];
    shopLongitude = json['shop_longitude'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shop_id'] = this.shopId;
    data['shop_name'] = this.shopName;
    data['shop_latitude'] = this.shopLatitude;
    data['shop_longitude'] = this.shopLongitude;
    data['distance'] = this.distance;
    return data;
  }
}
