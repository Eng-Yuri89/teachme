import 'package:flutter/material.dart';

/// Main button that is used throughout
/// the application for different actions,
/// with different colors and texts.
class MainButton extends StatefulWidget {
  //Disable color.
  final Color disableColor;
  //Enable color
  final Color enabledColor;
  //Border color
  final Color borderColor;
  //Function of calback.
  final Function onTap;
  //Button text.
  final Widget child;
  //Status indicator.
  final bool enabled;
  //Width of button.
  final double width;
  //Heigth of button.
  final double height;
  // Loading indicator.
  final bool isLoading;
  //Custom border radius.
  final double borderRadius;

  MainButton({
    this.disableColor,
    @required this.enabledColor,
    this.borderColor,
    @required this.onTap,
    @required this.child,
    @required this.enabled,
    this.width,
    @required this.height,
    @required this.isLoading,
    @required this.borderRadius,
  });

  @override
  _MainButtonState createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  @override
  Widget build(BuildContext context) {
    Color _borderColor;

    if (widget.borderColor == null) {
      if (widget.enabled) {
        _borderColor = widget.enabledColor;
      } else {
        _borderColor = widget.disableColor;
      }
    } else {
      _borderColor = widget.borderColor;
    }

    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height,
      child: RaisedButton(
        elevation: 0,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(widget.borderRadius),
          side: BorderSide(color: _borderColor),
        ),
        child: widget.isLoading
            ? SizedBox(
                width: widget.height - 25,
                height: widget.height - 25,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              )
            : widget.child,
        color: widget.enabled ? widget.enabledColor : widget.disableColor,
        onPressed: widget.enabled ? widget.onTap : () {},
      ),
    );
  }
}
