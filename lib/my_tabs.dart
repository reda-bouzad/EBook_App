import 'package:flutter/material.dart';
import 'app_colors.dart' as AppColors;

class AppTabs extends StatelessWidget {
  const AppTabs({super.key, required this.tabText, required this.tabColor});
  final String tabText;
  final Color tabColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 50,
      alignment: Alignment.center,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
        BoxShadow(
          color: tabColor,
        ),
      ]),
      child: Text(
        tabText,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
