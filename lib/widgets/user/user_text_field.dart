import 'package:acopiatech/constants/colors_palette.dart';
import 'package:flutter/material.dart';

class UserTextField extends StatelessWidget {
  const UserTextField({
    super.key,
    this.validator,
    this.onSaved,
    this.controller,
    required this.fieldName,
    this.myIcon = Icons.verified_user_outlined,
    this.prefixiedIconColor = ColorsPalette.hardGreen,
    required this.filled,
    this.numberOfLines = 1,
    this.maxLength,
    this.keyboardType,
    this.initialValue,
  });

  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final String fieldName;
  final IconData myIcon;
  final Color prefixiedIconColor;
  final bool filled;
  final int numberOfLines;
  final FormFieldSetter<String>? onSaved;
  final int? maxLength;
  final TextInputType? keyboardType;
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
        keyboardType: keyboardType,
        initialValue: initialValue,
        onSaved: onSaved,
        maxLines: numberOfLines, // Allows the text field to expand to 5 lines
        maxLength: maxLength, // Limits the input to 200 characters
        decoration: InputDecoration(
          labelText: fieldName,
          prefixIcon: Icon(myIcon, color: prefixiedIconColor),
          border: OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorsPalette.hardGreen, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          labelStyle: const TextStyle(
            color: ColorsPalette.darkCian,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
          filled: filled,
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
