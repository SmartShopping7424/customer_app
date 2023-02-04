class OrderModal {
  int? id;
  String? orderId;
  int? totalItem;
  int? totalAmount;
  String? createdAt;

  OrderModal(
      {this.id,
      this.orderId,
      this.totalItem,
      this.totalAmount,
      this.createdAt});

  OrderModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    totalItem = json['total_item'];
    totalAmount = json['total_amount'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['total_item'] = this.totalItem;
    data['total_amount'] = this.totalAmount;
    data['created_at'] = this.createdAt;
    return data;
  }
}
