import 'dart:io';
import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/helpers/loading/loading_screen.dart';
import 'package:acopiatech/services/cloud/address/address.dart';
import 'package:acopiatech/services/cloud/address/address_storage.dart';
import 'package:acopiatech/services/cloud/address/bloc/address_bloc.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_bloc.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_event.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_state.dart';
import 'package:acopiatech/services/cloud/storage_exceptions.dart';
import 'package:acopiatech/utilities/dialogs/error_dialog.dart';
import 'package:acopiatech/utilities/enums/collection_status.dart';
import 'package:acopiatech/utilities/generics/validate_field.dart';
import 'package:acopiatech/utilities/permission/permissions.dart';
import 'package:acopiatech/views/user/address/collection_address_view.dart';
import 'package:acopiatech/widgets/user/user_date_picker.dart';
import 'package:acopiatech/widgets/user/user_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreateCollectionView extends StatefulWidget {
  const CreateCollectionView({super.key});

  @override
  State<CreateCollectionView> createState() => _CreateCollectionViewState();
}

class _CreateCollectionViewState extends State<CreateCollectionView> {
  late String _selectedScheduled;
  late final DateTime _earliestSelectableDate;
  late DateTime _pickedDate;

  late final ImagePicker _picker;
  late final List<String> _selectedImages;

  String? _description;
  final _formKey = GlobalKey<FormState>();

  Address? _selectedAddress;

  void pickMultiImages() async {
    final isPermissionGranted = await requestPhotosPermission();

    if (isPermissionGranted) {
      final List<XFile> pickedImages = await _picker.pickMultiImage();
      if (pickedImages.isNotEmpty) {
        setState(() {
          for (XFile image in pickedImages) {
            _selectedImages.add(image.path);
          }
        });
      }
    }
  }

  void removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _getSelectedDate(DateTime date) => setState(() {
    _pickedDate = date;
  });

  @override
  void initState() {
    _selectedScheduled = 'Matutino';
    _selectedImages = [];
    _earliestSelectableDate = DateTime.now().add(const Duration(days: 2));
    _pickedDate = _earliestSelectableDate;
    _picker = ImagePicker();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CollectionBloc, CollectionState>(
      listener: (context, state) {
        if (state is CollectionStateCreatingCollection) {
          if (state.isLoading) {
            LoadingScreen().show(context: context, text: 'Espere un momento');
          } else {
            LoadingScreen().hide();
            context.read<CollectionBloc>().add(
              CollectionEventLoadCollections(),
            );
            Navigator.pop(context);
          }

          if (state.exception is CouldNotCreateAddressException) {
            showErrorDialog(
              context,
              'Error al crear la recolección. Intente de nuevo.',
            );
          }
        }
      },
      child: Scaffold(
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
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Turno
                  const Text(
                    'Turno',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                  SegmentedButton<String>(
                    multiSelectionEnabled: false,
                    segments: const <ButtonSegment<String>>[
                      ButtonSegment<String>(
                        value: 'Matutino',
                        label: Text('Matutino'),
                      ),
                      ButtonSegment<String>(
                        value: 'Vespertino',
                        label: Text('Vespertino'),
                      ),
                    ],
                    selected: <String>{_selectedScheduled},
                    onSelectionChanged: (Set<String> newTurno) {
                      setState(() {
                        _selectedScheduled = newTurno.first;
                      });
                    },
                  ),
                  // Fecha
                  Container(
                    decoration: const BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(width: 0.5),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        UserDatePicker(
                          earliestSelectableDate: _earliestSelectableDate,
                          onDateSelected: _getSelectedDate,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  // Datos de recolección
                  Padding(
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
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  _selectedImages.isNotEmpty
                                      // Creamos una cuadrícula de 3 columnas y filas
                                      ? GridView.builder(
                                        scrollDirection: Axis.horizontal,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 1,
                                              mainAxisSpacing: 8,
                                              crossAxisSpacing: 8,
                                            ),
                                        itemCount: _selectedImages.length,
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
                                                        _selectedImages[index],
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Stack(
                                              children: [
                                                Image.file(
                                                  File(_selectedImages[index]),
                                                  fit: BoxFit.cover,
                                                ),
                                                Positioned(
                                                  top: 1,
                                                  right: 1,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons
                                                          .disabled_by_default_rounded,
                                                    ),
                                                    onPressed: () {
                                                      removeImage(index);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                      : const Center(
                                        child: Text(
                                          'Adjunta evidencias',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
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
                          validator: (value) => validateField(value),
                          numberOfLines: 5,
                          onSaved:
                              (description) =>
                                  _description = description!.trim(),
                        ),
                      ],
                    ),
                  ),
                  // Dirección
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(width: 0.5),
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
                                'Selecciona una dirección.',
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
                                        '${_selectedAddress!.street} ${_selectedAddress!.extNumber}, ${_selectedAddress!.neighborhood}',
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
                                        (_) => BlocProvider(
                                          create:
                                              (context) =>
                                                  AddressBloc(AddressStorage()),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsPalette.darkCian,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (_selectedImages.isEmpty) {
                          showErrorDialog(
                            context,
                            'Por favor, adjunta las evidencias para crear una recolección.',
                          );
                        } else if (_selectedAddress == null) {
                          showErrorDialog(
                            context,
                            'Por favor, selecciona una dirección para crear una recolección.',
                          );
                        } else {
                          final List<String?> address = [
                            _selectedAddress!.street,
                            _selectedAddress!.extNumber,
                            _selectedAddress!.intNumber,
                            _selectedAddress!.neighborhood,
                          ];
                          context.read<CollectionBloc>().add(
                            CollectionEventCreateCollection(
                              schedule: _selectedScheduled,
                              date: _pickedDate,
                              description: _description!,
                              images: _selectedImages,
                              address: address,
                              status: CollectionStatus.recibida,
                              mode: 'Recolección a domicilio',
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Enviar solicitud de recolección',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
