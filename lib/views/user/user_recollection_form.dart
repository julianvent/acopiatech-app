import 'dart:io';

import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/views/user/create_address.dart';
import 'package:acopiatech/widgets/user_date_picker.dart';
import 'package:acopiatech/widgets/user_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserRecollectionForm extends StatefulWidget {
  const UserRecollectionForm({super.key});

  @override
  State<UserRecollectionForm> createState() => _UserRecollectionFormState();
}

enum Turno { matutino, vespertino }

class _UserRecollectionFormState extends State<UserRecollectionForm> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  List<XFile>? _evidences = [];
 

  pickImage() async {
    final List<XFile> pickedFile = await _picker.pickMultiImage();
    if (_evidences!.isNotEmpty) {
      _evidences!.addAll(pickedFile);
      setState(() {});
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                // Datos de recolección
                Text(
                  'Datos de recolección',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                Text(
                  'Evidencias',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
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
                          _evidences != null && _evidences!.isNotEmpty
                              // Creamos una cuadrícula de 3 columnas y filas
                              ? GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 4.0,
                                      mainAxisSpacing: 4.0,
                                    ),
                                itemCount: _evidences!.length,
                                itemBuilder: (context, index) {
                                  return Image.file(
                                    File(_evidences![index].path),
                                    fit: BoxFit.cover,
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
                          pickImage();
                        },
                        mini: true,
                        child: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Descripción
                UserTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una descripción';
                    }
                    return null;
                  },
                  controller: _descriptionController,
                  fieldName: 'Descripción',
                  myIcon: Icons.description_outlined,
                  prefixiedIconColor: ColorsPalette.hardGreen,
                  filled: true,
                  numberOfLines: 5,
                ),
                const SizedBox(height: 20),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dirección',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateAddress(),
                              ),
                            );
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
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _evidences != null) {
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
