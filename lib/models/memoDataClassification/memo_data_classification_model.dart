class MemoDataClassificationModel {
  bool isSuccess;
  String message;
  Data data;

  MemoDataClassificationModel({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory MemoDataClassificationModel.fromJson(Map<String, dynamic> json) {
    return MemoDataClassificationModel(
      isSuccess: json['isSuccess'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  int total;
  int count;
  List<MemoData> data;

  Data({
    required this.total,
    required this.count,
    required this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      total: json['total'],
      count: json['count'],
      data: List<MemoData>.from(
          json['data'].map((item) => MemoData.fromJson(item))),
    );
  }
}

class MemoData {
  bool isActive;
  String createdDate;
  int createdBy;
  int memoDataClassId;
  String description;
  bool isSecret;

  MemoData({
    required this.isActive,
    required this.createdDate,
    required this.createdBy,
    required this.memoDataClassId,
    required this.description,
    required this.isSecret,
  });

  factory MemoData.fromJson(Map<String, dynamic> json) {
    return MemoData(
      isActive: json['isActive'],
      createdDate: json['createdDate'],
      createdBy: json['createdBy'],
      memoDataClassId: json['memoDataClassId'],
      description: json['description'],
      isSecret: json['isSecret'],
    );
  }
}