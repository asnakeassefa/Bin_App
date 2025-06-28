class ProfileModel {
  String? status;
  String? message;
  Data? data;

  ProfileModel({this.status, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? fullName;
  String? email;
  String? deviceToken;
  String? country;
  bool? isAdmin;
  bool? isEmailVerified;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.fullName,
      this.email,
      this.deviceToken,
      this.country,
      this.isAdmin,
      this.isEmailVerified,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    email = json['email'];
    deviceToken = json['deviceToken'];
    country = json['country'];
    isAdmin = json['isAdmin'];
    isEmailVerified = json['isEmailVerified'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    data['deviceToken'] = this.deviceToken;
    data['country'] = this.country;
    data['isAdmin'] = this.isAdmin;
    data['isEmailVerified'] = this.isEmailVerified;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}