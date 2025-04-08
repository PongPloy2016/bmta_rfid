// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'res_login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResLoginModel _$ResLoginModelFromJson(Map<String, dynamic> json) =>
    ResLoginModel(
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResLoginModelToJson(ResLoginModel instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  token: json['token'] as String,
  refreshToken: json['refreshToken'] as String,
  expiration: json['expiration'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'token': instance.token,
  'refreshToken': instance.refreshToken,
  'expiration': instance.expiration,
  'user': instance.user,
};

User _$UserFromJson(Map<String, dynamic> json) => User(
  userId: (json['userId'] as num).toInt(),
  userName: json['userName'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  fullName: json['fullName'] as String,
  phoneNumber: json['phoneNumber'] as String,
  position: json['position'] as String,
  profileId: json['profileId'] as String,
  organizationId: (json['organizationId'] as num).toInt(),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'userId': instance.userId,
  'userName': instance.userName,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'fullName': instance.fullName,
  'phoneNumber': instance.phoneNumber,
  'position': instance.position,
  'profileId': instance.profileId,
  'organizationId': instance.organizationId,
};
