import 'package:flutter/material.dart';

class ComponentCustomTextfield extends StatelessWidget {
  final TextEditingController fieldController;
  final String label;
  const ComponentCustomTextfield({super.key, required this.fieldController, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: fieldController,
      minLines: 1,
      maxLines: 2,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}