import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final Function()? onPressed;
  final Icon icon;

  const ControlButton({Key? key, required this.onPressed, required this.icon}): super(key: key) ;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: SizedBox(
        width: 60.0,
        height: 60.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.indigo,
            elevation: 0.0,
            child: icon,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

