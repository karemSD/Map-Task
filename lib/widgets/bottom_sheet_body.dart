import 'dart:developer';

import 'package:apitask/utils/services/locations_api_service.dart';
import 'package:apitask/widgets/bottom_sheet_button_item.dart';
import 'package:flutter/material.dart';

import '../models/location_api_model.dart';

class BottomSheetBody extends StatelessWidget {
  BottomSheetBody({super.key, required this.locationApiModel});
  final ValueNotifier<int> _selectedButtonIndex = ValueNotifier<int>(-1);
  final ValueNotifier<IconData> _isSaveButtonSelected =
      ValueNotifier<IconData>(Icons.bookmark_border);
  final LocationApiModel locationApiModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dropped pin',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
            ),
            const SizedBox(height: 10.0), // Add some vertical spacing
            Row(
              children: [
                BottomSheetButtonItem(
                    selectedButtonIndex: _selectedButtonIndex,
                    index: 0,
                    onPressed: () {},
                    icon: Icons.directions,
                    title: "Directions",
                    iconTextColor: Colors.blue,
                    buttonColor: Colors.white),
                const Spacer(),
                ValueListenableBuilder<IconData>(
                  valueListenable: _isSaveButtonSelected,
                  builder: (context, isSaveButtonSelected, _) {
                    return BottomSheetButtonItem(
                      selectedButtonIndex: _selectedButtonIndex,
                      index: 1,
                      onPressed: () async {
                        if (_isSaveButtonSelected.value ==
                            Icons.bookmark_added) {
                          _isSaveButtonSelected.value = Icons.bookmark_border;
                        } else {
                          LocationApiModel loc =
                              await LocationsApiService.postData(
                                  locationApiModel);
                          log("saved");
                          _isSaveButtonSelected.value = Icons.bookmark_added;
                        }
                      },
                      icon: _isSaveButtonSelected.value,
                      selectedIcon: Icons.bookmark_added,
                      title:
                          (_isSaveButtonSelected.value == Icons.bookmark_added)
                              ? "Saved"
                              : "Save",
                      iconTextColor: Colors.blue,
                      buttonColor: Colors.white,
                    );
                  },
                ),
                const Spacer(),
                BottomSheetButtonItem(
                    index: 2,
                    selectedButtonIndex: _selectedButtonIndex,
                    onPressed: () => Navigator.pop(context),
                    icon: Icons.cancel,
                    title: "Close",
                    iconTextColor: Colors.blue,
                    buttonColor: Colors.white),
              ],
            )
          ],
        ),
      ),
    );
  }
}
