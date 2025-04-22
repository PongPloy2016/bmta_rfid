

import 'package:bmta_rfid_app/provider/state/property_building_state.dart';
import 'package:bmta_rfid_app/repository/rfid_serach_supplies_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PropertyBuildingController extends Notifier<PropertBulidingState> {
  late final RFIDSerachSuppliesRepository _repo;

  @override
  PropertBulidingState build() {
    _repo = ref.read(buildingRepositoryProvider); // ดึงจาก provider
    return PropertBulidingState.initial();
  }

  Future<void> fetchBuliding() async {
    state = const PropertBulidingState(isLoading: true);
    try {
      final response = await _repo.getBuilding();

      state = PropertBulidingState(
        branchSerachSuppliesModelResponse: response,
        isLoading: false,
      );
    } catch (e) {
      state = PropertBulidingState(
        isError: true,
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }
}



final buildingRepositoryProvider = Provider<RFIDSerachSuppliesRepository>((ref) {
  return RFIDSerachSuppliesRepository();
});

final buildingControllerProvider =
    NotifierProvider<PropertyBuildingController, PropertBulidingState>(() => PropertyBuildingController());

