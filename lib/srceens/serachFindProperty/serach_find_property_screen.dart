import 'package:bmta_rfid_app/app_router.dart';
import 'package:bmta_rfid_app/provider/serach_find_property_provider.dart';
import 'package:bmta_rfid_app/widgets/appbar/custom_app_bar.dart';
import 'package:bmta_rfid_app/widgets/dropdown/custom_dropdown_form_field.dart';
import 'package:bmta_rfid_app/widgets/widgets.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

// Define your models (DropDown, DataList, etc.)
class DropDown {
  final String id;
  final String desc;

  DropDown({required this.id, required this.desc});

  factory DropDown.fromJson(Map<String, dynamic> json) {
    return DropDown(
      id: json['id'] ?? '',
      desc: json['desc'] ?? '',
    );
  }
}

class DataList {
  final bool success;
  final List<DropDownValueModel> data;

  DataList({required this.success, required this.data});

  factory DataList.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<DropDownValueModel> dropDownList = list.map((i) => DropDownValueModel.fromJson(i)).toList();

    return DataList(
      success: json['success'] ?? false,
      data: dropDownList,
    );
  }
}

class SerachFindPropertyScreen extends ConsumerStatefulWidget {
  const SerachFindPropertyScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return SerachFindPropertyScreenState();
  }
}

class SerachFindPropertyScreenState extends ConsumerState<SerachFindPropertyScreen> {
  final Dio dio = Dio();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<DropDownValueModel> dropDownBranchList = [];
  List<DropDownValueModel> dropDownBuildingList = [];
  List<DropDownValueModel> dropDownFloorList = [];
  List<DropDownValueModel> dropDownRoomList = [];

  String? branchSelect;
  String? buildingSelect;
  String? floorSelect;
  String? roomSelect;

  bool _isBranchLoaded = false;

  late final ProviderSubscription branchListener;

  @override
  void initState() {
    super.initState();

    // เรียก API + ตั้ง listener เมื่อ widget สร้างเสร็จ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(branchControllerProvider.notifier).fetchBranches();

      // ✅ ใช้ listenManual แทน ref.listen
      branchListener = ref.listenManual<BranchState>(
        branchControllerProvider,
        (previous, next) {
          if (!_isBranchLoaded && next.branchSerachSuppliesModelResponse != null) {
            final branchData = next.branchSerachSuppliesModelResponse!;
            //setState(() {
              dropDownBranchList = branchData.data!
                  .map((e) => DropDownValueModel(name: e.desc!, value: e.id))
                  .toList();
              _isBranchLoaded = true;
           // });
          }

          if (next.isError) {
            _showErrorDialog(next.errorMessage);
          }
        },
      );
    });
  }

  @override
  void dispose() {
    branchListener.close(); // ✅ ปิด listener เมื่อ widget ถูก dispose
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final branchState = ref.watch(branchControllerProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: "ค้นหาทรัพย์สิน",
        onSuccess: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          branchState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  alignment: Alignment.topCenter,
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 20),
                            CustomDropdownFormField(
                              labelText: "สาขา",
                              dropDownList: dropDownBranchList,
                              itemCount: 10,
                              enabled: true,
                              onChanged: (value) {
                                setState(() {
                                  branchSelect = value?.toString();
                                  buildingSelect = null;
                                  floorSelect = null;
                                  roomSelect = null;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a branch';
                                }
                                return null;
                              },
                              inputDecoration: inputDecoration(
                                nameImage: "lib/assets/icons/ic_svg_user.svg",
                                context,
                                hintText: "สาขา",
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomDropdownFormField(
                              labelText: "อาคาร",
                              dropDownList: dropDownBuildingList,
                              itemCount: dropDownBuildingList.length,
                              enabled: true,
                              onChanged: (value) {
                                setState(() {
                                  buildingSelect = value?.toString();
                                  floorSelect = null;
                                  roomSelect = null;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a building';
                                }
                                return null;
                              },
                              inputDecoration: inputDecoration(
                                nameImage: "lib/assets/icons/ic_svg_user.svg",
                                context,
                                hintText: "อาคาร",
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomDropdownFormField(
                              labelText: 'ชั้น',
                              dropDownList: dropDownFloorList,
                              itemCount: dropDownFloorList.length,
                              enabled: true,
                              onChanged: (value) {
                                setState(() {
                                  floorSelect = value?.toString();
                                  roomSelect = null;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a floor';
                                }
                                return null;
                              },
                              inputDecoration: inputDecoration(
                                nameImage: "lib/assets/icons/ic_svg_user.svg",
                                context,
                                hintText: "ชั้น",
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomDropdownFormField(
                              labelText: "พื้นที่/ห้อง",
                              dropDownList: dropDownRoomList,
                              itemCount: dropDownRoomList.length,
                              enabled: true,
                              onChanged: (value) {
                                setState(() {
                                  roomSelect = value?.toString();
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a room';
                                }
                                return null;
                              },
                              inputDecoration: inputDecoration(
                                nameImage: "lib/assets/icons/ic_svg_user.svg",
                                context,
                                hintText: "พื้นที่/ห้อง",
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('กำลังค้นหา...')),
                                    );
                                    Navigator.pushNamed(context, AppRouter.propertyList);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4CAF50),
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                ),
                                child: const Center(
                                  child: Text(
                                    'ค้นหา',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}