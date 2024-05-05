import 'package:flutter/material.dart';

class BottomSheetButtonItem extends StatelessWidget {
  const BottomSheetButtonItem({
    super.key,
    required this.title,
    required this.iconTextColor,
    required this.buttonColor,
    required this.icon,
    required this.onPressed,
    required this.index,
    required this.selectedButtonIndex,
    this.selectedIcon,
    this.isSelected = false, // New parameter
  });

  final String title;
  final Color iconTextColor, buttonColor;
  final IconData icon;
  final VoidCallback onPressed;
  final int index;
  final ValueNotifier<int> selectedButtonIndex;
  final IconData? selectedIcon; // New parameter
  final bool isSelected; // New parameter

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedButtonIndex,
      builder: (context, selectedIndex, _) {
        final isSelected = selectedIndex == index;
        final buttonColor = isSelected ? Colors.blue : this.buttonColor;
        final iconTextColor = isSelected ? Colors.white : this.iconTextColor;

        return MaterialButton(
          highlightColor: Colors.blue.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          elevation: 0,
          color: buttonColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5.0),
          onPressed: () {
            selectedButtonIndex.value = index;
            onPressed();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconTextColor),
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(color: iconTextColor),
              ),
            ],
          ),
        );
      },
    );
  }
}
