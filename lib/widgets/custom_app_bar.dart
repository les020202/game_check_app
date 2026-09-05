
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  const CustomAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return AppBar(
      title: Text(title,style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new),
        onPressed: () => context.pop(),
      ),
      actions: actions,
      actionsPadding: EdgeInsets.only(right: 20),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}