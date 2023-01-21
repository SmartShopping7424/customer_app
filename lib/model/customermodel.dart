class CustomerModel {
  int? id;
  String? mobile;
  String? name;
  String? email;
  String? gender;

  CustomerModel({this.id, this.mobile, this.name, this.email, this.gender});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobile = json['mobile'];
    name = json['name'];
    email = json['email'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobile'] = this.mobile;
    data['name'] = this.name;
    data['email'] = this.email;
    data['gender'] = this.gender;
    return data;
  }
}
