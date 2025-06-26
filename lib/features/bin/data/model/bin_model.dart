class BinModel {
  String? status;
  String? message;
  List<Data?>? data;

  BinModel({this.status, this.message, this.data});

  BinModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v?.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  String? binType;
  String? bodyColor;
  String? headColor;
  String? lastCollectionDate;
  int? collectionInterval;
  String? nextCollectionDate;
  bool? notificationEnabled;
  int? notifyDaysBefore;
  String? lastNotificationTime;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.userId,
    this.binType,
    this.bodyColor,
    this.headColor,
    this.lastCollectionDate,
    this.collectionInterval,
    this.nextCollectionDate,
    this.notificationEnabled,
    this.notifyDaysBefore,
    this.lastNotificationTime,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    binType = json['binType'];
    bodyColor = json['bodyColor'];
    headColor = json['headColor'];
    lastCollectionDate = json['lastCollectionDate'];
    collectionInterval = json['collectionInterval'];
    nextCollectionDate = json['nextCollectionDate'];
    notificationEnabled = json['notificationEnabled'];
    notifyDaysBefore = json['notifyDaysBefore'];
    lastNotificationTime = json['lastNotificationTime'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['binType'] = this.binType;
    data['bodyColor'] = this.bodyColor;
    data['headColor'] = this.headColor;
    data['lastCollectionDate'] = this.lastCollectionDate;
    data['collectionInterval'] = this.collectionInterval;
    data['nextCollectionDate'] = this.nextCollectionDate;
    data['notificationEnabled'] = this.notificationEnabled;
    data['notifyDaysBefore'] = this.notifyDaysBefore;
    data['lastNotificationTime'] = this.lastNotificationTime;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
