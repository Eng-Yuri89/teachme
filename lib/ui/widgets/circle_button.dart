import 'package:flutter/material.dart';
/// Circle button.
class CircleButton extends StatelessWidget {
  // Color of button.
  final Color backgroundColor;
  // On tap action button.
  final Function onTap;
  // Child button.
  final Widget child;
  // Radius button.
  final double radius;

  CircleButton({this.backgroundColor, @required this.onTap, this.child, this.radius});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: InkWell(
        child: Container(
          color: backgroundColor ?? Color(0xffed8332),
          width: radius,
          height: radius,
          child: child
        ),
        onTap: onTap
      )
    );
  }
}