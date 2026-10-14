import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class CustomDottedButton extends StatelessWidget {
  final String customText;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final double height;
  const CustomDottedButton({
    super.key,
    required this.customText,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: padding,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: const [6, 3],
          strokeWidth: 1.5,
          radius: const Radius.circular(16),
          color: colorScheme.primary,
          padding: EdgeInsets.zero,
        ),
        child: SizedBox(
          width: double.infinity,
          height: height,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: colorScheme.primary.withValues(alpha: 0.06),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: BorderSide.none,
            ),
            child: Text(
              customText,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}