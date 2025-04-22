
import 'dart:math';

import 'package:bmta_rfid_app/models/equipmentItemModel/equipmentItem.dart';
import 'package:bmta_rfid_app/models/equipmentItemModel/reqMemoList.dart';
import 'package:bmta_rfid_app/provider/data_provider.dart';
import 'package:bmta_rfid_app/provider/state/equipment_list_state.dart';
import 'package:bmta_rfid_app/repository/rfid_meno_list_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EquipmentListhController extends StateNotifier<EquipmentListState> {
  final RFIDMenoListRepository repository;
  int currentPage = 1;
  final int limit = 15;

  EquipmentListhController(this.repository) : super(EquipmentListState.initial());

  // Load equipment list
  Future<void> loadEquipmentList({bool isLoadMore = false}) async {
    // Prevent multiple simultaneous loading requests
    if (state.isLoading || state.isLoadingMore) return;

    if (isLoadMore) {
      state = EquipmentListState(
        items: state.items,
        isLoading: false,
        isError: false,
        errorMessage: '',
        isLoadingMore: true, // Set loading more state
      );
    } else {
      state = EquipmentListState(
        items: state.items,
        isLoading: true,
        isError: false,
        errorMessage: '',
        isLoadingMore: false,
      );
    }

    try {
      final response = await repository.getMenoList(
        ReqMemoList(order: "asc", orderBy: "id", page: currentPage, limit: limit),
      );

      print("Response currentPage: $currentPage");

      if (response.isSuccess) {
        final randomImage = [
          "lib/assets/images/ic_list-table_01.png",
          "lib/assets/images/ic_list-pc_screen_01.png",
          "lib/assets/images/ic_list_laptop-01.png",
          "lib/assets/images/ic_list_building-01.png",
        ][Random().nextInt(4)];

        List<EquipmentItem> newItems = response.data.data.map((data) {
          return EquipmentItem(
            name: data.memoCode,
            category: data.bookRegister,
            description: data.memoDataClassDescription,
            location: data.memoTypeDescription,
            nameImage: randomImage,
          );
        }).toList();

        state = EquipmentListState(
          items: isLoadMore ? state.items + newItems : newItems,  // Concatenate new items for load more
          isLoading: false,
          isError: false,
          errorMessage: '',
          isLoadingMore: false,
        );
        currentPage++; // Increase page for the next load
      } else {
        state = EquipmentListState(
          items: state.items,
          isLoading: false,
          isError: true,
          errorMessage: response.message,
          isLoadingMore: false,
        );
      }
    } catch (e) {
      state = EquipmentListState(
        items: state.items,
        isLoading: false,
        isError: true,
        errorMessage: 'Failed to load data: $e',
        isLoadingMore: false,
      );
    }
  }
}

final equipmentListProvider =
    StateNotifierProvider<EquipmentListhController, EquipmentListState>((ref) {
  final repository = ref.watch(userProvider);
  return EquipmentListhController(repository);
});