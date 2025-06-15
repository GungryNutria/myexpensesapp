import 'package:flutter/material.dart';
import 'package:myexpensesapp/utils/theme_colors.dart';
class CustomButton extends StatelessWidget {
  final String? text;
  final Function()? onPressed;
  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => onPressed!(),
        style: ElevatedButton.styleFrom(
            backgroundColor: ThemeColors.BLUE_GREEN,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        child: Text(
          text!,
          textAlign: TextAlign.center,
          style: const TextStyle(color: ThemeColors.BLUE_WHITE, fontSize: 20),
        ),
      ),
    );;
  }
}