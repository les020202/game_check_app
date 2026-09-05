import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class CustomDottedButton extends StatelessWidget {
  final String customText;
  final VoidCallback? onPressed;
  const CustomDottedButton({
    super.key,
    required this.customText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: [6, 3],
          strokeWidth: 1.5,
          radius: Radius.circular(12),
          color: Colors.blue,
          padding: EdgeInsets.zero, 
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide.none,
            ),
            child: Text(customText)
          ),
        ),
      ),
    );
  }
}