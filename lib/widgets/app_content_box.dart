import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:flutter/material.dart';

class AppContentBox extends StatelessWidget {
  final Widget? child;
  final Color? sideColor;
  const AppContentBox({Key? key, this.child, this.sideColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.horizontal_padding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          child: child ?? const SizedBox(),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.symmetric(
              vertical: BorderSide(
                color: sideColor ?? Theme.of(context).primaryColor, 
                width: 6),
            )
          ),
        ),
      ),
    );
  }
}