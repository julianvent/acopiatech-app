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
import 'package:acopiatech/widgets/address_tile.dart';
import 'package:acopiatech/widgets/custom_button.dart';
import 'package:acopiatech/widgets/custom_detail.dart';
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
            LoadingScreen().show(
              context: context,
              text: 'Creando solicitud...',
            );
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
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          backgroundColor: ColorsPalette.neutralGray,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 2,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Turno
                CustomDetail(
                  children: [
                    Center(
                      child: const Text(
                        'Turno',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Center(
                      child: SegmentedButton<String>(
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
                    ),
                  ],
                ),
                // Fecha
                CustomDetail(
                  spacing: 5,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'Fecha de recolección',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    UserDatePicker(
                      earliestSelectableDate: _earliestSelectableDate,
                      onDateSelected: _getSelectedDate,
                    ),
                  ],
                ),
                // Datos de recolección
                CustomDetail(
                  children: [
                    Center(
                      child: Text(
                        'Datos de recolección',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 300,
                          width: double.maxFinite,
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
                                                  File(_selectedImages[index]),
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
                                      'Las evidencias son requeridas para continuar con la solicitud',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                      textAlign: TextAlign.center,
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
                            backgroundColor: ColorsPalette.darkCian,
                            foregroundColor: Colors.white,
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
                      numberOfLines: 4,
                      onSaved:
                          (description) => _description = description!.trim(),
                    ),
                  ],
                ),
                // Dirección
                CustomDetail(
                  children: [
                    Center(
                      child: const Text(
                        'Dirección',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    _selectedAddress == null
                        ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 15,
                          ),
                          child: Text(
                            'Selecciona una dirección para continuar con la solicitud',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                        : Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AddressTile(address: _selectedAddress!),
                          ),
                        ),
                    Center(
                      child: CustomButton(
                        title: 'Cambiar dirección',
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
                        icon: Icon(Icons.location_on_outlined, size: 20),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CustomButton(
                    title: 'Solicitar recolección',
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
                          context.read<CollectionBloc>().add(
                            CollectionEventCreateCollection(
                              schedule: _selectedScheduled,
                              date: _pickedDate,
                              description: _description!,
                              images: _selectedImages,
                              address: _selectedAddress.toString(),
                              status: CollectionStatus.recibida,
                              mode: 'Recolección a domicilio',
                            ),
                          );
                        }
                      }
                    },
                    backgroundColor: ColorsPalette.darkCian,
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
