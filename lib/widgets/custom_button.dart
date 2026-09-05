import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String customText;
  final VoidCallback? onPressed;
  final Color backgroundColors;
  final TextStyle fontStyle;
  final BorderSide borderSide;
  const CustomButton({
    super.key,
    required this.customText,
    required this.onPressed,
    required this.backgroundColors,
    required this.fontStyle,
    this.borderSide = BorderSide.none,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: backgroundColors,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: borderSide,
          ),
          child: Text(customText,style:fontStyle)
        ),
      ),
    );
  }
}