// lib/app/modules/home/components/app_bar.dart

import 'package:flutter/cupertino.dart';

class CustomAppBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      middle: Text(title),
      trailing: actions != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!,
            )
          : null,
      leading: leading,
      border: const Border(
        bottom: BorderSide(
          color: CupertinoColors.systemGrey4,
          width: 0.5,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44.0);

  @override
  bool shouldFullyObstruct(BuildContext context) => true;
}