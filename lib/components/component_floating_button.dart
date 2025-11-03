import 'package:flutter/material.dart';

class ComponentFloatingButton extends StatelessWidget {
  final VoidCallback buttonFunction;
  final bool isVisible;
  final IconData buttonIcon;
  const ComponentFloatingButton({
    super.key,
    required this.buttonFunction,
    required this.isVisible,
    required this.buttonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: FloatingActionButton(
        onPressed: buttonFunction,
        backgroundColor: Colors.blueGrey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(30),
        ),
        
        child: Icon(buttonIcon, color: Colors.greenAccent.shade700,),
      ),
    );
  }
}
