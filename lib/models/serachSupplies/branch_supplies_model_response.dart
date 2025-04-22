import 'package:json_annotation/json_annotation.dart';

part 'branch_supplies_model_response.g.dart';

@JsonSerializable()
class BranchSerachSuppliesModelResponse {
  final bool? success;
  final int? total;
  final List<Branch>? data;

  BranchSerachSuppliesModelResponse({
     this.success,
     this.total,
     this.data,
  });

  factory BranchSerachSuppliesModelResponse.fromJson(Map<String, dynamic> json) =>
      _$BranchSerachSuppliesModelResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BranchSerachSuppliesModelResponseToJson(this);
}

@JsonSerializable()
class Branch {
  final String? id;
  final String? desc;

  Branch({
     this.id,
     this.desc,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);

  Map<String, dynamic> toJson() => _$BranchToJson(this);
}