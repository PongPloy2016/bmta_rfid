// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_supplies_model_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchSerachSuppliesModelResponse _$BranchSerachSuppliesModelResponseFromJson(
  Map<String, dynamic> json,
) => BranchSerachSuppliesModelResponse(
  success: json['success'] as bool?,
  total: (json['total'] as num?)?.toInt(),
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => Branch.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$BranchSerachSuppliesModelResponseToJson(
  BranchSerachSuppliesModelResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'total': instance.total,
  'data': instance.data,
};

Branch _$BranchFromJson(Map<String, dynamic> json) =>
    Branch(id: json['id'] as String?, desc: json['desc'] as String?);

Map<String, dynamic> _$BranchToJson(Branch instance) => <String, dynamic>{
  'id': instance.id,
  'desc': instance.desc,
};
