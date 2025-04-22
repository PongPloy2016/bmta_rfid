import 'package:bmta_rfid_app/models/equipmentItemModel/equipmentItem.dart';

class EquipmentListState {
  final List<EquipmentItem> items;
  final bool isLoading;
  final bool isError;
  final String errorMessage;
  final bool isLoadingMore;

  EquipmentListState({
    required this.items,
    required this.isLoading,
    required this.isError,
    required this.errorMessage,
    required this.isLoadingMore,
  });

  EquipmentListState.initial()
      : items = [],
        isLoading = false,
        isError = false,
        errorMessage = "",
        isLoadingMore = false; // Add the isLoadingMore state
}