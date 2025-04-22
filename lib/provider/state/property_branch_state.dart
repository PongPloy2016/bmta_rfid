import 'package:bmta_rfid_app/models/serachSupplies/branch_supplies_model_response.dart';
import 'package:equatable/equatable.dart';

class PropertBranchState extends Equatable {
  final BranchSerachSuppliesModelResponse? branchSerachSuppliesModelResponse;
  final bool isLoading;
  final bool isError;
  final String errorMessage;

  const PropertBranchState({
    this.branchSerachSuppliesModelResponse,
    this.isLoading = false,
    this.isError = false,
    this.errorMessage = '',
  });

  factory PropertBranchState.initial() => const PropertBranchState();

  @override
  List<Object?> get props => [isLoading, isError, errorMessage];
}
