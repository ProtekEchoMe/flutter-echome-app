import 'package:flutter/material.dart';
import 'package:animated_button/animated_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  const CustomButton(
      {Key? key,
      required this.text,
      this.onPressed,
      this.isLoading = false,
      this.enabled = true, this.width = 200, this.height = 64})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
        enabled: !isLoading,
        color: Theme.of(context).colorScheme.primary,
        width: width,
        height: height,
        child: !isLoading
            ? Text(
                text,
                style: TextStyle(
                  fontSize: 22,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  fontWeight: FontWeight.w500,
                ),
              )
            : SpinKitChasingDots(
                itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    shape:BoxShape.circle,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                );
              }),
        onPressed: onPressed ?? () {});
  }
}
