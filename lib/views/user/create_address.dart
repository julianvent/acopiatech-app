import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/widgets/user_text_field.dart';
import 'package:flutter/material.dart';

class CreateAddress extends StatefulWidget {
  const CreateAddress({super.key});

  @override
  State<CreateAddress> createState() => _CreateAddressState();
}

class _CreateAddressState extends State<CreateAddress> {
  final _formKey = GlobalKey<FormState>();
  late final String _street;
  late final String _extNumber;
  String? _intNumber;
  late final String _neighborhood;
  late final String _zipCode;
  String? _reference;
  late final String _city;
  late final String _state;

  String? _validateField(String? value) =>
      (value == null || value.isEmpty) ? 'Requerido' : null;

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agregar nueva dirección',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                UserTextField(
                  fieldName: 'Calle',
                  myIcon: Icons.location_on_outlined,
                  filled: false,
                  validator: (value) => _validateField(value),
                  onSaved: (street) => _street = street!,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: UserTextField(
                        fieldName: 'No. ext',
                        myIcon: Icons.numbers_rounded,
                        filled: false,
                        validator: (value) => _validateField(value),
                        onSaved: (extNumber) => _extNumber = extNumber!,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: UserTextField(
                        fieldName: 'No. int(opcional)',
                        myIcon: Icons.numbers_rounded,
                        filled: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                UserTextField(
                  fieldName: 'Colonia',
                  myIcon: Icons.location_on_outlined,
                  filled: false,
                  validator: (value) => _validateField(value),
                  onSaved: (neighborhood) => _neighborhood = neighborhood!,
                ),
                const SizedBox(height: 10),
                UserTextField(
                  fieldName: 'Código postal',
                  myIcon: Icons.local_post_office_outlined,
                  filled: false,
                  validator: (value) => _validateField(value),
                  onSaved: (zip) => _zipCode = zip!,
                ),
                const SizedBox(height: 10),
                UserTextField(
                  fieldName: 'Referencias (opcional)',
                  myIcon: Icons.home_work_outlined,
                  filled: false,
                  numberOfLines: 3,
                  onSaved: (reference) => _reference = reference,
                ),
                const SizedBox(height: 10),
                UserTextField(
                  fieldName: 'Ciudad',
                  myIcon: Icons.location_city,
                  filled: false,
                  validator: (value) => _validateField(value),
                  onSaved: (city) => _city = city!,
                ),
                const SizedBox(height: 10),
                UserTextField(
                  fieldName: 'Estado',
                  myIcon: Icons.location_city,
                  filled: false,
                  validator: (value) => _validateField(value),
                  onSaved: (state) => _state = state!,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.pop(context, {
                        'street': _street,
                        'extNumber': _extNumber,
                        'intNumber': _intNumber,
                        'neighborhood': _neighborhood,
                        'zipCode': _zipCode,
                        'reference': _reference,
                        'city': _city,
                        'state': _state,
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsPalette.lightGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    fixedSize: Size(200, 50),
                  ),
                  child: const Text(
                    'Guardar dirección',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
