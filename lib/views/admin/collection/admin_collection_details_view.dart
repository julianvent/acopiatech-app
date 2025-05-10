import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/helpers/loading/loading_screen.dart';
import 'package:acopiatech/services/auth/bloc/auth_bloc.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_bloc.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_event.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_state.dart';
import 'package:acopiatech/services/cloud/collections/bloc/images/collection_images_bloc.dart';
import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:acopiatech/services/cloud/collections/collection_image_storage.dart';
import 'package:acopiatech/utilities/dialogs/error_dialog.dart';
import 'package:acopiatech/utilities/enums/collection_status.dart';
import 'package:acopiatech/utilities/generics/validate_field.dart';
import 'package:acopiatech/views/admin/chat/admin_chat_view.dart';
import 'package:acopiatech/views/user/collection/images/collection_gallery_view.dart';
import 'package:acopiatech/views/user/help/user_chat_view.dart';
import 'package:acopiatech/widgets/map_widget.dart';
import 'package:acopiatech/widgets/user/user_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminCollectionDetailsView extends StatefulWidget {
  final Collection collection;

  const AdminCollectionDetailsView({super.key, required this.collection});

  @override
  State<AdminCollectionDetailsView> createState() =>
      _AdminCollectionDetailsViewState();
}

class _AdminCollectionDetailsViewState
    extends State<AdminCollectionDetailsView> {
  final _formKey = GlobalKey<FormState>();
  late String _receiverCollectionId = widget.collection.documentId;
  late CollectionStatus _selectedStatus;
  int? _pointsEarned;

  void _changeCollectionStatus(CollectionStatus newStatus) {
    // mostrar snackbar??
  }

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.collection.status;
  }

  @override
  Widget build(BuildContext context) {
    final collection = widget.collection;
    // collection data
    final description = collection.description;

    // date
    final date =
        '${collection.dateScheduled.day}-${collection.dateScheduled.month}-${collection.dateScheduled.year} ${collection.schedule}';

    return BlocListener<CollectionBloc, CollectionState>(
      listener: (context, state) {
        if (state is CollectionStateUpdatingCollection) {
          if (state.isLoading) {
            LoadingScreen().show(context: context, text: state.loadingText!);
          } else {
            LoadingScreen().hide();
            context.read<CollectionBloc>().add(
              CollectionEventLoadCollections(),
            );
            Navigator.pop(context);
          }

          if (state.exception != null) {
            showErrorDialog(
              context,
              'No se pudo actualizar la recolección. Intente de nuevo.',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => BlocProvider.value(
                              value: BlocProvider.of<CollectionBloc>(context),
                              child: AdminChatView(
                                receiverCollectionId: _receiverCollectionId,
                              ),
                            ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2.0),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Contactar al donador",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.help_center_rounded,
                          color: Colors.black54,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                spacing: 20,
                children: [
                  Container(
                    width: double.maxFinite,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      collection.mode,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  // Mapa & Estado de la recolección
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.3),
                      ),
                    ),
                    // ------ Mapa ------
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 300,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            child: Center(
                              child: MapWidget(address: collection.address),
                            ),
                          ),
                          // ------ Estado de la recolección ------
                          Text(
                            "Estado de la recolección",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          DropdownButton<CollectionStatus>(
                            padding: const EdgeInsets.all(8),
                            value: _selectedStatus,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            items:
                                CollectionStatus.values
                                    .map<DropdownMenuItem<CollectionStatus>>((
                                      status,
                                    ) {
                                      return DropdownMenuItem<CollectionStatus>(
                                        value: status,
                                        child: Text(status.status),
                                      );
                                    })
                                    .toList(),
                            onChanged: (CollectionStatus? newStatus) {
                              setState(() {
                                _selectedStatus = newStatus!;
                              });
                              _changeCollectionStatus(_selectedStatus);
                            },
                          ),
                          Visibility(
                            visible:
                                _selectedStatus == CollectionStatus.finalizada,
                            child: Column(
                              children: [
                                Text('Asignar puntos a recolección'),
                                Form(
                                  key: _formKey,
                                  child: UserTextField(
                                    fieldName: 'Puntos',
                                    filled: false,
                                    initialValue:
                                        collection.pointsEarned == 0
                                            ? null
                                            : collection.pointsEarned
                                                .toString(),
                                    keyboardType: TextInputType.datetime,
                                    validator: (value) => validateField(value),
                                    onSaved: (newValue) {
                                      _pointsEarned = int.parse(newValue!);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _selectedStatus.description,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ------ Detalles de la recolección ------
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.3),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Detalles de la recolección",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Column(
                            spacing: 12,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  Icon(Icons.location_on_outlined),
                                  Flexible(child: Text(collection.address)),
                                ],
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  Icon(Icons.calendar_month),
                                  Flexible(child: Text(date)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ------ Descripción de la recolección ------
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.3),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Text(
                            "Descripción",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ------ Cambiar estado ------
                  SizedBox(
                    width: 190,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => BlocProvider(
                                  create:
                                      (context) => CollectionImagesBloc(
                                        CollectionImageStorage(),
                                      ),
                                  child: CollectionGalleryView(
                                    collection: widget.collection,
                                  ),
                                ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        spacing: 10,
                        children: [
                          Text(
                            "Ver evidencias",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Icon(
                            Icons.photo,
                            color: ColorsPalette.darkCian,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: Text('Confirmar cambios'),
                      onPressed: () {
                        if (_selectedStatus == CollectionStatus.finalizada) {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                          } else {
                            return;
                          }
                        }
                        context.read<CollectionBloc>().add(
                          CollectionEventUpdateStatus(
                            documentId: collection.documentId,
                            status: _selectedStatus,
                            pointsEarned: _pointsEarned,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
