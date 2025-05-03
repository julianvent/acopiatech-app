import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/helpers/loading/loading_screen.dart';
import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_bloc.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_event.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_state.dart';
import 'package:acopiatech/widgets/user/user_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateUpdateDropOffPoint extends StatefulWidget {
  const CreateUpdateDropOffPoint({super.key});

  @override
  State<CreateUpdateDropOffPoint> createState() =>
      _CreateUpdateDropOffPointState();
}

class _CreateUpdateDropOffPointState extends State<CreateUpdateDropOffPoint> {
  final _formKey = GlobalKey<FormState>();

  Address? _address;
  String? _dropOffPointName;
  String? _street;
  String? _neighborhood;
  String? _phoneNumber;
  String? _reference;
  String? _city;
  String? _state;

  String? _validateField(String? value) =>
      (value == null || value.isEmpty) ? 'Requerido' : null;

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
        }
      },
      builder: (context, state) {
        if (state is AddressStateCreatingUpdatingAddress) {
          _address = state.address;
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<AddressBloc>().add(
                        AddressEventLoadAdresses(),
                      );
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  Text(
                    (_address != null)
                        ? 'Actualizar dirección'
                        : 'Agregar nueva dirección',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      UserTextField(
                        initialValue: _dropOffPointName,
                        fieldName: 'Nombre',
                        myIcon: Icons.home_work_outlined,
                        filled: false,
                        validator: (value) => _validateField(value),
                        onSaved:
                            (dropOffPointName) =>
                                _dropOffPointName = dropOffPointName!.trim(),
                      ),
                      UserTextField(
                        initialValue: _address?.street,
                        fieldName: 'Calle',
                        myIcon: Icons.location_on_outlined,
                        filled: false,
                        validator: (value) => _validateField(value),
                        onSaved: (street) => _street = street!.trim(),
                      ),
                      UserTextField(
                        initialValue: _address?.neighborhood,
                        fieldName: 'Colonia',
                        myIcon: Icons.location_on_outlined,
                        filled: false,
                        validator: (value) => _validateField(value),
                        onSaved:
                            (neighborhood) =>
                                _neighborhood = neighborhood!.trim(),
                      ),

                      UserTextField(
                        initialValue: _address?.phoneNumber,
                        fieldName: 'Número de teléfono',
                        keyboardType: TextInputType.phone,
                        myIcon: Icons.phone,
                        filled: false,
                        validator: (value) => _validateField(value),
                        onSaved:
                            (phoneNumber) => _phoneNumber = phoneNumber!.trim(),
                      ),
                      UserTextField(
                        initialValue: _address?.reference,
                        fieldName: 'Referencias (opcional)',
                        maxLength: 200,
                        myIcon: Icons.home_work_outlined,
                        filled: false,
                        numberOfLines: 3,
                        onSaved: (reference) => _reference = reference?.trim(),
                      ),

                      UserTextField(
                        initialValue: _address?.city,
                        fieldName: 'Ciudad',
                        myIcon: Icons.location_city,
                        filled: false,
                        validator: (value) => _validateField(value),
                        onSaved: (city) => _city = city!.trim(),
                      ),

                      UserTextField(
                        initialValue: _address?.state,
                        fieldName: 'Estado',
                        myIcon: Icons.location_city,
                        filled: false,
                        validator: (value) => _validateField(value),
                        onSaved: (state) => _state = state!.trim(),
                      ),

                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            // context.read<AddressBloc>().add(
                            //   DropOffPointEventCreateUpdateDropOffPoint(
                            //     _address,
                            //     _city!,
                            //     _neighborhood!,
                            //     _reference,
                            //     _state!,
                            //     _street!,
                            //     _phoneNumber!,
                            //   ),
                            // );
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
                              ? 'Actualizar centro de acopio'
                              : 'Guardar centro de acopio',
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
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
