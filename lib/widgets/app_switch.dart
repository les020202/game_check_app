import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double scale;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Transform.scale(
      scale: scale,
      child: CupertinoSwitch(
        value: value,
        activeTrackColor: colorScheme.primary,
        onChanged: onChanged,
      ),
    );
  }
}
