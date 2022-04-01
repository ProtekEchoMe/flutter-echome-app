import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:flutter/material.dart';

class BodyTitle extends StatelessWidget {
  String? title;
  String? clipTitle;
  BodyTitle({Key? key, this.title, this.clipTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.horizontal_padding),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  child: Text(
                    title ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 35),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                width: 130,
                height: 30,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text(
                  clipTitle ?? "",
                  style: TextStyle(
                      color: Theme.of(context).cardTheme.color),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
