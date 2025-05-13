import 'package:flutter/material.dart';
import 'package:acopiatech/constants/colors_palette.dart';

class AdminPointAssignerTextField extends StatelessWidget {
  const AdminPointAssignerTextField({
    super.key,
    this.validator,
    this.onSaved,
    this.controller,
    this.initialValue,
  });

  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final FormFieldSetter<String>? onSaved;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        scrollPadding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).viewInsets.bottom,
        ),
        validator: validator,
        controller: controller,
        keyboardType: TextInputType.number,
        initialValue: initialValue,
        onSaved: onSaved,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorsPalette.darkCian,
              width: 2.0,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorsPalette.hardGreen, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          labelStyle: const TextStyle(
            color: ColorsPalette.darkCian,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 12.0,
          ),
        ),
      ),
    );
  }
}
