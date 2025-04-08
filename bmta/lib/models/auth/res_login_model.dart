import 'package:json_annotation/json_annotation.dart';

part 'res_login_model.g.dart';

@JsonSerializable()
class ResLoginModel {
  final bool isSuccess;
  final String message;
  final Data data;

  ResLoginModel({
    required this.isSuccess,
    required this.message,
     required this.data,
  });

  factory ResLoginModel.fromJson(Map<String, dynamic> json) {
    return ResLoginModel(
      isSuccess: json['isSuccess'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'message': message,
      'data': data.toJson(),
    };
  }
}
@JsonSerializable()
class Data {
  final String token;
  final String refreshToken;
  final String expiration;
  final User user;

  Data({
    required this.token,
    required this.refreshToken,
    required this.expiration,
    required this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      token: json['token'] ?? '', // Provide default empty string if 'token' is null
      refreshToken: json['refreshToken'] ?? '', // Provide default empty string if 'refreshToken' is null
      expiration: json['expiration'] ?? '', // Provide default empty string if 'expiration' is null
      user: json['user'] != null ? User.fromJson(json['user']) : User.empty(), // Handle case where 'user' is null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'expiration': expiration,
      'user': user.toJson(),
    };
  }
}
@JsonSerializable()
class User {
  final int userId;
  final String userName;
  final String firstName;
  final String lastName;
  final String fullName;
  final String phoneNumber;
  final String position;
  final String profileId;
  final int organizationId;

  User({
    required this.userId,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.phoneNumber,
    required this.position,
    required this.profileId,
    required this.organizationId,
  });

  // Empty constructor to handle null user data
  factory User.empty() {
    return User(
      userId: 0,
      userName: '',
      firstName: '',
      lastName: '',
      fullName: '',
      phoneNumber: '',
      position: '',
      profileId: '',
      organizationId: 0,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] ?? 0, // Provide default value if null
      userName: json['userName'] ?? '', // Provide default value if null
      firstName: json['firstName'] ?? '', // Provide default value if null
      lastName: json['lastName'] ?? '', // Provide default value if null
      fullName: json['fullName'] ?? '', // Provide default value if null
      phoneNumber: json['phoneNumber'] ?? '', // Provide default value if null
      position: json['position'] ?? '', // Provide default value if null
      profileId: json['profileId'] ?? '', // Provide default value if null
      organizationId: json['organizationId'] ?? 0, // Provide default value if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'position': position,
      'profileId': profileId,
      'organizationId': organizationId,
    };
  }
}