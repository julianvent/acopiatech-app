import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/helpers/loading/loading_screen.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_bloc.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_event.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_state.dart';
import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/utilities/generics/validate_field.dart';
import 'package:acopiatech/widgets/custom_app_bar.dart';
import 'package:acopiatech/widgets/custom_button.dart';
import 'package:acopiatech/widgets/custom_detail.dart';
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
          appBar:
              CustomAppBar(
                title:
                    _address == null
                        ? "Agregar dirección"
                        : "Actualizar dirección",
              ).navigatorAppBar,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  CustomDetail(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    borderRadius: BorderRadius.circular(12.0),
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            UserTextField(
                              initialValue: _address?.street,
                              fieldName: 'Calle',
                              myIcon: Icons.location_on_outlined,
                              filled: false,
                              validator: (value) => validateField(value),
                              onSaved: (street) => _street = street!.trim(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 10,
                              children: [
                                Expanded(
                                  child: UserTextField(
                                    initialValue: _address?.extNumber,
                                    fieldName: 'No. ext',
                                    myIcon: Icons.numbers_rounded,
                                    filled: false,
                                    validator: (value) => validateField(value),
                                    onSaved:
                                        (extNumber) =>
                                            _extNumber = extNumber!.trim(),
                                  ),
                                ),
                                Expanded(
                                  child: UserTextField(
                                    initialValue: _address?.intNumber,
                                    fieldName: 'No. int(opcional)',
                                    myIcon: Icons.numbers_rounded,
                                    filled: false,
                                    onSaved:
                                        (intNumber) =>
                                            _intNumber = intNumber?.trim(),
                                  ),
                                ),
                              ],
                            ),
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
                            UserTextField(
                              initialValue: _address?.zipCode,
                              fieldName: 'Código postal',
                              keyboardType: TextInputType.datetime,
                              myIcon: Icons.local_post_office_outlined,
                              filled: false,
                              validator: (value) => validateField(value),
                              onSaved: (zip) => _zipCode = zip!.trim(),
                            ),
                            UserTextField(
                              initialValue: _address?.phoneNumber,
                              fieldName: 'Número de teléfono',
                              keyboardType: TextInputType.phone,
                              myIcon: Icons.phone,
                              filled: false,
                              validator: (value) => validateField(value),
                              onSaved:
                                  (phoneNumber) =>
                                      _phoneNumber = phoneNumber!.trim(),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              child: UserTextField(
                                initialValue: _address?.reference,
                                fieldName: 'Referencias (opcional)',
                                maxLength: 200,
                                myIcon: Icons.home_work_outlined,
                                filled: false,
                                numberOfLines: 3,
                                onSaved:
                                    (reference) =>
                                        _reference = reference?.trim(),
                              ),
                            ),
                            UserTextField(
                              initialValue: _address?.city,
                              fieldName: 'Ciudad',
                              myIcon: Icons.location_city,
                              filled: false,
                              validator: (value) => validateField(value),
                              onSaved: (city) => _city = city!.trim(),
                            ),
                            UserTextField(
                              initialValue: _address?.state,
                              fieldName: 'Estado',
                              myIcon: Icons.location_city,
                              filled: false,
                              validator: (value) => validateField(value),
                              onSaved: (state) => _state = state!.trim(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: CustomButton(
                      title:
                          (_address != null)
                              ? 'Actualizar dirección'
                              : 'Guardar dirección',
                      onPressed: () {
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
                      backgroundColor: ColorsPalette.darkCian,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
