import 'package:bmta_rfid_app/models/serachSupplies/branch_supplies_model_response.dart';
import 'package:equatable/equatable.dart';

class PropertBulidingState extends Equatable {
  final BranchSerachSuppliesModelResponse? branchSerachSuppliesModelResponse;
  final bool isLoading;
  final bool isError;
  final String errorMessage;

  const PropertBulidingState({
    this.branchSerachSuppliesModelResponse,
    this.isLoading = false,
    this.isError = false,
    this.errorMessage = '',
  });

  factory PropertBulidingState.initial() => const PropertBulidingState();

  @override
  List<Object?> get props => [isLoading, isError, errorMessage];
}
