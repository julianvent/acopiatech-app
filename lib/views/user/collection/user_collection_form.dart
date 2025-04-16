import 'dart:io';
import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/auth/bloc/auth_state.dart';
import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_bloc.dart';
import 'package:acopiatech/views/user/address/collection_address_view.dart';
import 'package:acopiatech/services/auth/bloc/auth_bloc.dart';
import 'package:acopiatech/widgets/user/user_date_picker.dart';
import 'package:acopiatech/widgets/user/user_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UserCollectionForm extends StatefulWidget {
  const UserCollectionForm({super.key});

  @override
  State<UserCollectionForm> createState() => _UserCollectionFormState();
}

enum Turno { matutino, vespertino }

class _UserCollectionFormState extends State<UserCollectionForm> {
  Address? _selectedAddress;

  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  List<XFile>? _selectedImages = [];

  late final String _description;

  pickMultiImages() async {
    final List<XFile> pickedImages = await _picker.pickMultiImage();
    if (pickedImages.isNotEmpty) {
      setState(() {
        _selectedImages!.addAll(pickedImages);
      });
    }
  }

  Turno turnoSeleccionado = Turno.matutino;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateField(String? value) =>
      (value == null || value.isEmpty) ? 'Requerido' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nueva recolección',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              spacing: 30,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Turno
                const Text(
                  'Turno',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
                SegmentedButton<Turno>(
                  multiSelectionEnabled: false,
                  segments: const <ButtonSegment<Turno>>[
                    ButtonSegment<Turno>(
                      value: Turno.matutino,
                      label: Text('Matutino'),
                    ),
                    ButtonSegment<Turno>(
                      value: Turno.vespertino,
                      label: Text('Vespertino'),
                    ),
                  ],
                  selected: <Turno>{turnoSeleccionado},
                  onSelectionChanged: (Set<Turno> newTurno) {
                    setState(() {
                      turnoSeleccionado = newTurno.first;
                    });
                  },
                ),
                // Fecha
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 2.0),
                      bottom: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      UserDatePicker(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                // Datos de recolección
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Datos de recolección',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        // // Evidencias
                        Text(
                          'Evidencias',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Stack(
                          children: [
                            Container(
                              height: 250,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  _selectedImages != null &&
                                          _selectedImages!.isNotEmpty
                                      // Creamos una cuadrícula de 3 columnas y filas
                                      ? GridView.builder(
                                        scrollDirection: Axis.horizontal,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 1,
                                              mainAxisSpacing: 8,
                                              crossAxisSpacing: 8,
                                            ),
                                        itemCount: _selectedImages!.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              // Mostrar previsualización de la imagen
                                              showDialog(
                                                context: context,
                                                builder: (_) {
                                                  return Dialog(
                                                    child: Image.file(
                                                      File(
                                                        _selectedImages![index]
                                                            .path,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Image.file(
                                              File(
                                                _selectedImages![index].path,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                      )
                                      : const Center(
                                        child: Text(
                                          'No hay fotos seleccionadas',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: FloatingActionButton(
                                onPressed: () {
                                  pickMultiImages();
                                },
                                mini: true,
                                child: const Icon(Icons.add_a_photo),
                              ),
                            ),
                          ],
                        ),
                        // Descripción
                        UserTextField(
                          fieldName: 'Descripción',
                          myIcon: Icons.description_outlined,
                          prefixiedIconColor: ColorsPalette.hardGreen,
                          filled: true,
                          validator: (value) => _validateField(value),
                          numberOfLines: 5,
                          onSaved: (description) => _description = _description,
                        ),
                      ],
                    ),
                  ),
                ),
                // Dirección
                Container(
                  height: 200,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 2.0),
                      bottom: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dirección',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        _selectedAddress == null
                            ? const Text(
                              'No hay direcciones seleccionadas',
                              style: TextStyle(fontSize: 16),
                            )
                            : Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 10.0,
                                    ),
                                    child: Text(
                                      '${_selectedAddress!.street} #${_selectedAddress!.extNumber}, ${_selectedAddress!.neighborhood}',
                                    ),
                                  ),
                                  subtitle: Column(
                                    spacing: 5,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(_selectedAddress!.phoneNumber),
                                      Text(
                                        '${_selectedAddress!.city}, ${_selectedAddress!.state}',
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      final Address? selectedAddress;
                                      selectedAddress = await Navigator.push<
                                        Address
                                      >(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => BlocProvider.value(
                                                value:
                                                    context.read<AddressBloc>(),
                                                child:
                                                    const CollectionAddressView(),
                                              ),
                                        ),
                                      );
                                      if (selectedAddress != null) {
                                        setState(() {
                                          _selectedAddress = selectedAddress;
                                        });
                                      }
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                ),
                              ),
                            ),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final Address? selectedAddress;
                              selectedAddress = await Navigator.push<Address>(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => BlocProvider.value(
                                        value: context.read<AddressBloc>(),
                                        child: const CollectionAddressView(),
                                      ),
                                ),
                              );
                              if (selectedAddress != null) {
                                setState(() {
                                  _selectedAddress = selectedAddress;
                                });
                              }
                            },
                            icon: const Icon(Icons.location_on_outlined),
                            label: const Text(
                              'Cambiar dirección',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _selectedImages != null) {
                      // Process the data
                    }
                  },
                  child: const Text(
                    'Enviar solicitud de recolección',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
