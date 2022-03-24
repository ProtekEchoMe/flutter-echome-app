import 'package:flutter/material.dart';

class EchoMeAppBar extends StatelessWidget with PreferredSizeWidget {
  String? titleText;

  EchoMeAppBar({Key? key, this.titleText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [Text(titleText ?? "EchoMe")],
      ),
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}