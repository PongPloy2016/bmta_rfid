import 'dart:async';
import 'dart:convert';
import 'package:bmta/themes/colors.dart';
import 'package:bmta/themes/fontsize.dart';
import 'package:bmta/widgets/widgets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdownFormField extends StatelessWidget {
  const CustomDropdownFormField({
    super.key,
    this.controller,
    this.labelText,
    this.dropDownList,
    this.itemCount,
    this.enabled,
    this.validator,
    this.onChanged, 
    this.inputDecoration,
  });

  final SingleValueDropDownController? controller;
  final List<DropDownValueModel>? dropDownList;
  final int? itemCount;
  final String? labelText;
  final bool? enabled;
  final String? Function(String?)? validator;
  final void Function(dynamic)? onChanged;
  final InputDecoration? inputDecoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(10, 3, 20, 0),
      margin: EdgeInsets.only(left: 5, right: 5),
      child: DropDownTextField(
        controller: controller,
        dropDownItemCount: itemCount ?? 0,
        dropDownList: dropDownList ?? [],
        clearOption: true,
        isEnabled: enabled ?? true,
        clearIconProperty: IconProperty(color: Colors.black),
        dropDownIconProperty: IconProperty(color: Colors.black),
        textFieldDecoration: inputDecoration ?? InputDecoration(
          isDense: true,
          border: InputBorder.none,
          errorStyle: TextStyle(
            color: Colors.red,
            fontSize: fontSize9_SmallText.sp,
          ),
        ),
        // onChanged: (val) {
        //   if (onChanged != null) {
        //     onChanged!(val);
        //   }
        // },
        onChanged: onChanged,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textStyle: TextStyle(fontSize: fontSize6_Detail.sp),
        listTextStyle: (defaultTargetPlatform == TargetPlatform.android)
            ? TextStyle(fontSize: fontSize6_Detail.sp)
            : null,
      ),
    );
  }
}

class CustomDropdownFormFieldTwo extends StatelessWidget {
  const CustomDropdownFormFieldTwo({
    super.key,
    this.controller,
    this.labelText,
    this.dropDownList,
    this.itemCount,
    this.enabled,
    this.validator,
    this.onChanged,
    this.leadingIcon, // ใช้ SvgPicture สำหรับไอคอนด้านซ้าย
  });

  final SingleValueDropDownController? controller;
  final List<DropDownValueModel>? dropDownList;
  final int? itemCount;
  final String? labelText;
  final bool? enabled;
  final String? Function(String?)? validator;
  final void Function(dynamic)? onChanged;
  final SvgPicture? leadingIcon; // ใช้ SvgPicture สำหรับไอคอนด้านซ้าย

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null) // แสดง label ด้านบน
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                  child: Text(
                    labelText!,
                    style: TextStyle(
                      fontSize: fontSize6_Detail.sp,
                    ),
                  ),
                ),
                if (leadingIcon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: leadingIcon!,
                  ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: DropDownTextField(
                  controller: controller,
                  dropDownItemCount: itemCount ?? 0,
                  dropDownList: dropDownList ?? [],
                  clearOption: false,
                  isEnabled: enabled ?? true,
                  dropDownIconProperty: IconProperty(color: Colors.black),
                  textFieldDecoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    errorStyle: TextStyle(
                      color: Colors.red,
                      fontSize: fontSize9_SmallText.sp,
                    ),
                  ),
                  onChanged: onChanged,
                  validator: validator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textStyle: TextStyle(
                    fontSize: fontSize6_Detail.sp,
                    fontWeight: fontBold,
                    color: Colors.black,
                  ),
                  listTextStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomDropdownFormFieldThree extends StatelessWidget {
  const CustomDropdownFormFieldThree({
    super.key,
    this.controller,
    this.labelText,
    this.dropDownList,
    this.itemCount,
    this.enabled,
    this.validator,
    this.onChanged,
    this.leadingIcon, // ใช้ SvgPicture สำหรับไอคอนด้านซ้าย
  });

  final SingleValueDropDownController? controller;
  final List<DropDownValueModel>? dropDownList;
  final int? itemCount;
  final String? labelText;
  final bool? enabled;
  final String? Function(String?)? validator;
  final void Function(DropDownValueModel)? onChanged;
  final SvgPicture? leadingIcon; // ใช้ SvgPicture สำหรับไอคอนด้านซ้าย

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
            color: enabled! ? Color(textColorBlack) : const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (labelText != null) // แสดง label ด้านบน
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                  child: Text(
                    labelText!,
                    style: TextStyle(
                      fontSize: fontSize6_Detail.sp,
                    ),
                  ),
                ),
                if (leadingIcon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: leadingIcon!,
                  ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: DropDownTextField(
                  controller: controller,
                  dropDownItemCount: itemCount ?? 0,
                  dropDownList: dropDownList ?? [],
                  clearOption: false,
                  isEnabled: enabled ?? true,
                  dropDownIconProperty: IconProperty(color: Colors.black),
                  textFieldDecoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    errorStyle: TextStyle(
                      color: Colors.red,
                      fontSize: fontSize9_SmallText.sp,
                    ),
                  ),
                  onChanged: (val) {
                    onChanged!(val);
                  },
                  validator: validator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textStyle: TextStyle(
                    fontSize: fontSize6_Detail.sp,
                    fontWeight: FontWeight.normal,
                    color:
                        enabled! ? Color(textColorBlack) : Color(textColorGrey),
                  ),
                  listTextStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomDropdownButton2 extends StatelessWidget {
  const CustomDropdownButton2({
    required this.hint,
    required this.value,
    required this.dropdownItems,
    required this.onChanged,
    this.selectedItemBuilder,
    this.hintAlignment,
    this.valueAlignment,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonPadding,
    this.buttonDecoration,
    this.buttonElevation,
    this.icon,
    this.iconSize,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.itemHeight,
    this.itemPadding,
    this.dropdownHeight,
    this.dropdownWidth,
    this.dropdownPadding,
    this.dropdownDecoration,
    this.dropdownElevation,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.scrollbarAlwaysShow,
    this.offset = Offset.zero,
    super.key,
  });
  final String hint;
  final String? value;
  final List<DropDownValueModel> dropdownItems;
  final ValueChanged<String?>? onChanged;
  final DropdownButtonBuilder? selectedItemBuilder;
  final Alignment? hintAlignment;
  final Alignment? valueAlignment;
  final double? buttonHeight, buttonWidth;
  final EdgeInsetsGeometry? buttonPadding;
  final BoxDecoration? buttonDecoration;
  final int? buttonElevation;
  final Widget? icon;
  final double? iconSize;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final double? itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final double? dropdownHeight, dropdownWidth;
  final EdgeInsetsGeometry? dropdownPadding;
  final BoxDecoration? dropdownDecoration;
  final int? dropdownElevation;
  final Radius? scrollbarRadius;
  final double? scrollbarThickness;
  final bool? scrollbarAlwaysShow;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    // Ensure unique values in dropdownItems
    final uniqueDropdownItems = dropdownItems.toSet().toList();

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        //To avoid long text overflowing.
        isExpanded: true,
        hint: Container(
          alignment: hintAlignment,
          child: Text(
            hint,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: fontSize6_Detail.sp,
              color: Theme.of(context).hintColor,
            ),
          ),
        ),
        value: value,
        items: uniqueDropdownItems
            .map((DropDownValueModel item) => DropdownMenuItem<String>(
                  value: item.value.toString(),
                  child: Container(
                    alignment: valueAlignment,
                    child: Text(
                      item.name,
                      overflow: TextOverflow.visible,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: item.name.length < 50
                            ? fontSize7_Caption.sp
                            : fontSize7_Caption.sp,
                      ),
                    ),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        selectedItemBuilder: selectedItemBuilder,
        buttonStyleData: ButtonStyleData(
          height: buttonHeight ?? 50.h,
          width: buttonWidth ?? ScreenUtil().screenWidth.w,
          padding: buttonPadding ?? EdgeInsets.only(left: 14.w, right: 14.w),
          decoration: buttonDecoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                border: Border.all(
                  color: Colors.black45,
                ),
              ),
          elevation: buttonElevation,
        ),
        iconStyleData: IconStyleData(
          icon: icon ?? const Icon(Icons.arrow_forward_ios_outlined),
          iconSize: iconSize ?? 12,
          iconEnabledColor: iconEnabledColor,
          iconDisabledColor: iconDisabledColor,
        ),
        dropdownStyleData: DropdownStyleData(
          //Max height for the dropdown menu & becoming scrollable if there are more items. If you pass Null it will take max height possible for the items.
          maxHeight: dropdownHeight ?? 500.h,
          width: buttonWidth,
          padding: dropdownPadding,
          decoration: dropdownDecoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
              ),
          elevation: dropdownElevation ?? 2,
          //Null or Offset(0, 0) will open just under the button. You can edit as you want.
          offset: offset,
          scrollbarTheme: ScrollbarThemeData(
            radius: scrollbarRadius ?? Radius.circular(20.r),
            thickness: scrollbarThickness != null
                ? MaterialStateProperty.all<double>(scrollbarThickness!)
                : null,
            thumbVisibility: scrollbarAlwaysShow != null
                ? MaterialStateProperty.all<bool>(scrollbarAlwaysShow!)
                : null,
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: itemHeight ?? 50.h,
          padding: itemPadding ?? EdgeInsets.only(left: 14.w, right: 14.w),
        ),
      ),
    );
  }
}

class CustomDropdownSearch extends StatefulWidget {
  const CustomDropdownSearch({
    required this.hint,
    required this.value,
    required this.dropdownItems,
    required this.onChanged,
    this.selectedItemBuilder,
    this.hintAlignment,
    this.valueAlignment,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonPadding,
    this.buttonDecoration,
    this.buttonElevation,
    this.icon,
    this.iconSize,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.itemHeight,
    this.itemPadding,
    this.dropdownHeight,
    this.dropdownWidth,
    this.dropdownPadding,
    this.dropdownDecoration,
    this.dropdownElevation,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.scrollbarAlwaysShow,
    this.offset = Offset.zero,
    this.isSearchEnabled = true, // เพิ่มตัวเลือกเปิด/ปิดช่องค้นหา
    this.onSearchChanged,
    super.key,
    this.getDataFromSearch,
  });

  final String hint;
  final String? value;
  final List<DropDownValueModel> dropdownItems;
  final ValueChanged<String?>? onChanged;
  final DropdownButtonBuilder? selectedItemBuilder;
  final Alignment? hintAlignment;
  final Alignment? valueAlignment;
  final double? buttonHeight, buttonWidth;
  final EdgeInsetsGeometry? buttonPadding;
  final BoxDecoration? buttonDecoration;
  final int? buttonElevation;
  final Widget? icon;
  final double? iconSize;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final double? itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final double? dropdownHeight, dropdownWidth;
  final EdgeInsetsGeometry? dropdownPadding;
  final BoxDecoration? dropdownDecoration;
  final int? dropdownElevation;
  final Radius? scrollbarRadius;
  final double? scrollbarThickness;
  final bool? scrollbarAlwaysShow;
  final Offset offset;
  final bool isSearchEnabled; // เพิ่มตัวเลือกเปิด/ปิดช่องค้นหา
  final ValueChanged<String?>? onSearchChanged;
  final FutureOr<List<DropDownValueModel>> Function(String)? getDataFromSearch;

  @override
  _CustomDropdownSearchState createState() => _CustomDropdownSearchState();
}

class _CustomDropdownSearchState extends State<CustomDropdownSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<DropDownValueModel> _filteredItems = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.dropdownItems;
  }

  void _filterItems(String searchTextInput) {
    String searchText = searchTextInput.trim().toLowerCase();
    if (searchText.length > 0) {
      setState(() async {
        _filteredItems = await widget.getDataFromSearch!(searchText);

        _filteredItems = _filteredItems
            .where((item) => item.name.toLowerCase().contains(searchText))
            .toList();
        _isSearching = true;
      });
    }
    if (widget.onSearchChanged != null) {
      widget.onSearchChanged!(searchTextInput);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            _searchController.clear();
          }
          if (isOpen) {
            setState(() {
              _filteredItems = widget.dropdownItems;
            });
          }
        },
        hint: Container(
          alignment: widget.hintAlignment,
          child: Text(
            widget.hint,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: fontSize6_Detail.sp,
              color: Theme.of(context).hintColor,
            ),
          ),
        ),
        value: _filteredItems.any((item) => item.value == widget.value)
            ? widget.value
            : null, // If value is invalid, set to null
        items: _isSearching
            ? // แสดงรายการที่กรองเฉพาะเมื่อกำลังค้นหา
            _filteredItems
                .map((DropDownValueModel item) => DropdownMenuItem<String>(
                      value: item.value.toString(),
                      child: Container(
                        alignment: widget.valueAlignment,
                        child: Text(
                          item.name,
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: item.name.length < 50
                                ? fontSize7_Caption.sp
                                : fontSize7_Caption.sp,
                          ),
                        ),
                      ),
                    ))
                .toList()
            : _filteredItems
                .map((DropDownValueModel item) => DropdownMenuItem<String>(
                      value: item.value.toString(),
                      child: Container(
                        alignment: widget.valueAlignment,
                        child: Text(
                          item.name,
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: item.name.length < 50
                                ? fontSize7_Caption.sp
                                : fontSize7_Caption.sp,
                          ),
                        ),
                      ),
                    ))
                .toList(),

        onChanged: widget.onChanged,
        selectedItemBuilder: widget.selectedItemBuilder,
        buttonStyleData: ButtonStyleData(
          height: widget.buttonHeight ?? 50.h,
          width: widget.buttonWidth ?? ScreenUtil().screenWidth.w,
          padding:
              widget.buttonPadding ?? EdgeInsets.only(left: 14.w, right: 14.w),
          decoration: widget.buttonDecoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                border: Border.all(color: Colors.black45),
              ),
          elevation: widget.buttonElevation,
        ),
        iconStyleData: IconStyleData(
          icon: widget.icon ?? const Icon(Icons.arrow_forward_ios_outlined),
          iconSize: widget.iconSize ?? 12,
          iconEnabledColor: widget.iconEnabledColor,
          iconDisabledColor: widget.iconDisabledColor,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: widget.dropdownHeight ?? 500.h,
          width: widget.buttonWidth,
          padding: widget.dropdownPadding,
          decoration: widget.dropdownDecoration ??
              BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
          elevation: widget.dropdownElevation ?? 2,
          offset: widget.offset,
          scrollbarTheme: ScrollbarThemeData(
            radius: widget.scrollbarRadius ?? Radius.circular(20.r),
            thickness: widget.scrollbarThickness != null
                ? MaterialStateProperty.all<double>(widget.scrollbarThickness!)
                : null,
            thumbVisibility: widget.scrollbarAlwaysShow != null
                ? MaterialStateProperty.all<bool>(widget.scrollbarAlwaysShow!)
                : null,
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: widget.itemHeight ?? 50.h,
          padding:
              widget.itemPadding ?? EdgeInsets.only(left: 14.w, right: 14.w),
        ),
        dropdownSearchData: widget.isSearchEnabled
            ? DropdownSearchData(
                searchController: _searchController,
                searchInnerWidget: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      _filterItems(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'ค้นหา...',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                searchInnerWidgetHeight: 60,
                searchMatchFn: (item, searchValue) {
                  return item.value
                      .toString()
                      .toLowerCase()
                      .contains(searchValue.toLowerCase());
                },
              )
            : null, // ปิดช่องค้นหาถ้า `isSearchEnabled` เป็น `false`
      ),
    );
  }

  @override
  void dispose() {
    // _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }
}
