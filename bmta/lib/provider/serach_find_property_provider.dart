import 'package:bmta/models/serachSupplies/branch_supplies_model_response.dart';
import 'package:bmta/repository/rfid_serach_supplies_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BranchState extends Equatable {
  final BranchSerachSuppliesModelResponse? branchSerachSuppliesModelResponse;
  final bool isLoading;
  final bool isError;
  final String errorMessage;

  const BranchState({
    this.branchSerachSuppliesModelResponse,
    this.isLoading = false,
    this.isError = false,
    this.errorMessage = '',
  });

  factory BranchState.initial() => const BranchState();

  @override
  List<Object?> get props => [isLoading, isError, errorMessage];
}


class BranchController extends Notifier<BranchState> {
  late final RFIDSerachSuppliesRepository _repo;

  @override
  BranchState build() {
    _repo = ref.read(branchRepositoryProvider); // ดึงจาก provider
    return BranchState.initial();
  }

  Future<void> fetchBranches() async {
    state = BranchState(isLoading: true);
    try {
      final response = await _repo.getBranch();

      state = BranchState(
        branchSerachSuppliesModelResponse: response,
        isLoading: false,
      );
    } catch (e) {
      state = BranchState(
        isError: true,
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }
}



final branchRepositoryProvider = Provider<RFIDSerachSuppliesRepository>((ref) {
  return RFIDSerachSuppliesRepository();
});

final branchControllerProvider =
    NotifierProvider<BranchController, BranchState>(() => BranchController());

