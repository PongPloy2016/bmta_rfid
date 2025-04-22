

import 'package:bmta_rfid_app/provider/state/property_branch_state.dart';
import 'package:bmta_rfid_app/repository/rfid_serach_supplies_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PropertyBranchController extends Notifier<PropertBranchState> {
  late final RFIDSerachSuppliesRepository _repo;

  @override
  PropertBranchState build() {
    _repo = ref.read(branchRepositoryProvider); // ดึงจาก provider
    return PropertBranchState.initial();
  }

  Future<void> fetchBranches() async {
    state = const PropertBranchState(isLoading: true);
    try {
      final response = await _repo.getBranch();

      state = PropertBranchState(
        branchSerachSuppliesModelResponse: response,
        isLoading: false,
      );
    } catch (e) {
      state = PropertBranchState(
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
    NotifierProvider<PropertyBranchController, PropertBranchState>(() => PropertyBranchController());

