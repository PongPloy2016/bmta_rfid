
class MockupMemoModel {
  bool isSuccess;
  String message;
  MemoData data;

  MockupMemoModel({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  // Factory constructor to create MemoModel from JSON
  factory MockupMemoModel.fromJson(Map<String, dynamic> json) {
    return MockupMemoModel(
      isSuccess: json['isSuccess'],
      message: json['message'],
      data: MemoData.fromJson(json['data']),
    );
  }

  // Method to convert MemoModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class MemoData {
  int total;
  int count;
  List<Memo> data;

  MemoData({
    required this.total,
    required this.count,
    required this.data,
  });

  // Factory constructor to create MemoData from JSON
  factory MemoData.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Memo> memoList = list.map((i) => Memo.fromJson(i)).toList();

    return MemoData(
      total: json['total'],
      count: json['count'],
      data: memoList,
    );
  }

  // Method to convert MemoData to JSON
  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'count': count,
      'data': data.map((memo) => memo.toJson()).toList(),
    };
  }
}

class Memo {
  String memoCode;
  String? memoNo;
  int memoGroupId;
  int memoTypeId;
  int memoDataClassId;
  int memoUrgentId;
  String memoDataClassDescription;
  String memoGroupDescription;
  String memoTypeDescription;
  String memoUrgentDescription;
  int status;
  String bookRegister;
  String subject;
  int id;
  int page;
  int limit;
  String order;

  Memo({
    required this.memoCode,
    this.memoNo,
    required this.memoGroupId,
    required this.memoTypeId,
    required this.memoDataClassId,
    required this.memoUrgentId,
    required this.memoDataClassDescription,
    required this.memoGroupDescription,
    required this.memoTypeDescription,
    required this.memoUrgentDescription,
    required this.status,
    required this.bookRegister,
    required this.subject,
    required this.id,
    required this.page,
    required this.limit,
    required this.order,
  });

  // Factory constructor to create Memo from JSON
  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      memoCode: json['memoCode'],
      memoNo: json['memoNo'],
      memoGroupId: json['memoGroupId'],
      memoTypeId: json['memoTypeId'],
      memoDataClassId: json['memoDataClassId'],
      memoUrgentId: json['memoUrgentId'],
      memoDataClassDescription: json['memoDataClassDescription'],
      memoGroupDescription: json['memoGroupDescription'],
      memoTypeDescription: json['memoTypeDescription'],
      memoUrgentDescription: json['memoUrgentDescription'],
      status: json['status'],
      bookRegister: json['bookRegister'],
      subject: json['subject'],
      id: json['id'],
      page: json['page'],
      limit: json['limit'],
      order: json['order'],
    );
  }

  // Method to convert Memo to JSON
  Map<String, dynamic> toJson() {
    return {
      'memoCode': memoCode,
      'memoNo': memoNo,
      'memoGroupId': memoGroupId,
      'memoTypeId': memoTypeId,
      'memoDataClassId': memoDataClassId,
      'memoUrgentId': memoUrgentId,
      'memoDataClassDescription': memoDataClassDescription,
      'memoGroupDescription': memoGroupDescription,
      'memoTypeDescription': memoTypeDescription,
      'memoUrgentDescription': memoUrgentDescription,
      'status': status,
      'bookRegister': bookRegister,
      'subject': subject,
      'id': id,
      'page': page,
      'limit': limit,
      'order': order,
    };
  }
}