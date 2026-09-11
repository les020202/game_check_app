import 'package:flutter/material.dart';

class TagFilter extends StatelessWidget {
  const TagFilter({
    super.key,
    required this.isCheckeds,
    required this.typeNames,
    required this.onTap,
    required this.index,
  });
  final List<bool> isCheckeds;
  final List<String> typeNames;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isCheckeds[index] ? colorScheme.primary : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey),
          ),
          padding: const EdgeInsets.only(
            right: 15.0,
            left: 15.0,
            top: 5,
            bottom: 5,
          ),
          child: Center(
            child: Text(
              '${typeNames[index]}',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isCheckeds[index] ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
