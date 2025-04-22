import 'package:bmta_rfid_app/app_router.dart';
import 'package:bmta_rfid_app/provider/controller/equipment_list_controller.dart';
import 'package:bmta_rfid_app/widgets/equipmentListWidgets/equipmentItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Assuming this widget exists for displaying items

class EquipmentListScreen extends ConsumerStatefulWidget {
  const EquipmentListScreen({super.key});

  @override
  _EquipmentListScreenState createState() => _EquipmentListScreenState();
}

class _EquipmentListScreenState extends ConsumerState<EquipmentListScreen> {
  int currentPage = 1;
  final int limit = 15;
  final bool _isLoadingMore = false; // Loading state for loading more data

  @override
  void initState() {
    super.initState();
    // Load equipment list when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(equipmentListProvider.notifier).loadEquipmentList(isLoadMore: false);
    });
  }

 @override
Widget build(BuildContext context) {
  final equipmentState = ref.watch(equipmentListProvider);

  return Scaffold(
    appBar: AppBar(
      title: const Text("รายการครุภัณฑ์"),
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
    ),
    body: equipmentState.isLoading
        ? const Center(child: CircularProgressIndicator())
        : NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!_isLoadingMore && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(equipmentListProvider.notifier).loadEquipmentList(isLoadMore: true);
                });
                print("Load more data triggered");
                return true; // Prevent further processing of the notification
              }
              return false;
            },
            child: ListView.builder(
              itemCount: equipmentState.items.length + (equipmentState.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == equipmentState.items.length) {
                  // Add a loading indicator at the bottom
                  return const Center(child: CircularProgressIndicator());
                }
                final item = equipmentState.items[index];
                return EquipmentItemWidget(
                  item: item,
                  onClickTap: () {
                    // Navigate to equipment detail screen when item is tapped
                    Navigator.pushNamed(context, AppRouter.equipmentDetail, arguments: item);
                  },
                );
              },
            ),
          ),
  );
}
}