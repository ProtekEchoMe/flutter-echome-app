import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  String? title;
  String? description;
  bool? isThreeLines;
  Widget? leading;
  Widget? trailing;

  ListItem(
      {Key? key,
      this.title,
      this.description,
      this.isThreeLines,
      this.leading,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade400))
      ),
      child: Card(
        margin: const EdgeInsets.all(0),
        elevation: 0,
        child: Center(
          child: ListTile(
            leading: leading,
            title: Text(
              title ?? "",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(description ?? ""),
            trailing: trailing,
            isThreeLine: isThreeLines != null ? isThreeLines! : false,
          ),
        ),
      ),
    );
  }
}
