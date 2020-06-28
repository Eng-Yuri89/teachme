import 'package:flutter/material.dart';

class SuffixClearButton extends StatefulWidget {
  final TextEditingController controller;

  SuffixClearButton({@required this.controller});

  @override
  _SuffixClearButtonState createState() => _SuffixClearButtonState();
}

class _SuffixClearButtonState extends State<SuffixClearButton> {
  @override
  Widget build(BuildContext context) {
    return (widget.controller.text.runes.isNotEmpty)
        ? IconButton(
            icon: CircleAvatar(
              backgroundColor: Theme.of(context).disabledColor.withOpacity(0.7),
              radius: 10,
              child: Icon(Icons.clear,
                  color: Theme.of(context).backgroundColor, size: 14),
            ),
            onPressed: () {
              setState(() {
                widget.controller.text = '';
              });
            })
        : SizedBox();
  }
}
