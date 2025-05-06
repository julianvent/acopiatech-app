import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/helpers/loading/loading_screen.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_bloc.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_event.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_state.dart';
import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/utilities/generics/validate_field.dart';
import 'package:acopiatech/widgets/user/user_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateUpdateAddressView extends StatefulWidget {
  final Address? address;
  const CreateUpdateAddressView({super.key, this.address});

  @override
  State<CreateUpdateAddressView> createState() =>
      _CreateUpdateAddressViewState();
}

class _CreateUpdateAddressViewState extends State<CreateUpdateAddressView> {
  final _formKey = GlobalKey<FormState>();
  Address? _address;
  String? _street;
  String? _extNumber;
  String? _intNumber;
  String? _neighborhood;
  String? _zipCode;
  String? _phoneNumber;
  String? _reference;
  String? _city;
  String? _state;

  @override
  void initState() {
    _address = widget.address;
    super.initState();
  }

  @override
  Widget build(context) {
    return BlocConsumer<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: 'Actualizando direcciones...',
          );
        } else {
          LoadingScreen().hide();
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              _address == null
                  ? "Agregar una nueva dirección"
                  : "Actualizar una dirección",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
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
                      initialValue: _address?.street,
                      fieldName: 'Calle',
                      myIcon: Icons.location_on_outlined,
                      filled: false,
                      validator: (value) => validateField(value),
                      onSaved: (street) => _street = street!.trim(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: UserTextField(
                            initialValue: _address?.extNumber,
                            fieldName: 'No. ext',
                            myIcon: Icons.numbers_rounded,
                            filled: false,
                            validator: (value) => validateField(value),
                            onSaved:
                                (extNumber) => _extNumber = extNumber!.trim(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: UserTextField(
                            initialValue: _address?.intNumber,
                            fieldName: 'No. int(opcional)',
                            myIcon: Icons.numbers_rounded,
                            filled: false,
                            onSaved:
                                (intNumber) => _intNumber = intNumber?.trim(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    UserTextField(
                      initialValue: _address?.neighborhood,
                      fieldName: 'Colonia',
                      myIcon: Icons.location_on_outlined,
                      filled: false,
                      validator: (value) => validateField(value),
                      onSaved:
                          (neighborhood) =>
                              _neighborhood = neighborhood!.trim(),
                    ),
                    const SizedBox(height: 10),
                    UserTextField(
                      initialValue: _address?.zipCode,
                      fieldName: 'Código postal',
                      keyboardType: TextInputType.datetime,
                      myIcon: Icons.local_post_office_outlined,
                      filled: false,
                      validator: (value) => validateField(value),
                      onSaved: (zip) => _zipCode = zip!.trim(),
                    ),
                    const SizedBox(height: 10),
                    UserTextField(
                      initialValue: _address?.phoneNumber,
                      fieldName: 'Número de teléfono',
                      keyboardType: TextInputType.phone,
                      myIcon: Icons.phone,
                      filled: false,
                      validator: (value) => validateField(value),
                      onSaved:
                          (phoneNumber) => _phoneNumber = phoneNumber!.trim(),
                    ),
                    const SizedBox(height: 20),
                    UserTextField(
                      initialValue: _address?.reference,
                      fieldName: 'Referencias (opcional)',
                      maxLength: 200,
                      myIcon: Icons.home_work_outlined,
                      filled: false,
                      numberOfLines: 3,
                      onSaved: (reference) => _reference = reference?.trim(),
                    ),
                    const SizedBox(height: 10),
                    UserTextField(
                      initialValue: _address?.city,
                      fieldName: 'Ciudad',
                      myIcon: Icons.location_city,
                      filled: false,
                      validator: (value) => validateField(value),
                      onSaved: (city) => _city = city!.trim(),
                    ),
                    const SizedBox(height: 10),
                    UserTextField(
                      initialValue: _address?.state,
                      fieldName: 'Estado',
                      myIcon: Icons.location_city,
                      filled: false,
                      validator: (value) => validateField(value),
                      onSaved: (state) => _state = state!.trim(),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          context.read<AddressBloc>().add(
                            AddressEventCreateUpdateAddress(
                              _address,
                              _city!,
                              _extNumber!,
                              _intNumber,
                              _neighborhood!,
                              _reference,
                              _state!,
                              _street!,
                              _zipCode!,
                              _phoneNumber!,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsPalette.lightGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        fixedSize: Size(250, 50),
                      ),
                      child: Text(
                        (_address != null)
                            ? 'Actualizar dirección'
                            : 'Guardar dirección',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
