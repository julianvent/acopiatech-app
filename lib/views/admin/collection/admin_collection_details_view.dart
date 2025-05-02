import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_bloc.dart';
import 'package:acopiatech/services/cloud/collections/bloc/images/collection_images_bloc.dart';
import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:acopiatech/services/cloud/collections/collection_image_storage.dart';
import 'package:acopiatech/views/user/collection/images/collection_gallery_view.dart';
import 'package:acopiatech/views/user/help/user_chat_view.dart';
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
  late String _selectedStatus;

  final List<String> _statusList = [
    'En revisión',
    'Lista para recolección',
    'En camino',
    'En evaluación',
    'Finalizada',
  ];

  void _changeCollectionStatus(String newStatus) {
    // context.read<CollectionBloc>().add(
    //   CollectionEventUpdateCollectionStatus(
    //     collectionId: widget.collection.documentId,
    //     newStatus: newStatus,
    //   ),
    // );
  }

  @override
  void initState() {
    super.initState();
    _selectedStatus = "En revisión";
  }

  @override
  Widget build(BuildContext context) {
    // collection data
    final status = widget.collection.status.status;
    final statusDescription = widget.collection.status.description;
    final description = widget.collection.description;

    // address data
    final String? street = widget.collection.address.elementAt(0);
    final String number =
        '${widget.collection.address.elementAt(1)} ${widget.collection.address.elementAt(2)}'
            .trim();
    final String? neighborhood = widget.collection.address.elementAt(3);

    // date
    final date =
        '${widget.collection.dateScheduled.day}-${widget.collection.dateScheduled.month}-${widget.collection.dateScheduled.year} ${widget.collection.schedule}';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detalles de la recolección",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
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
                            child: UserChatView(),
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
                    widget.collection.mode,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.0),
                          ),
                          child: Center(
                            child: Text(
                              "Añadir mapa",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
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
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          statusDescription,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
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
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () => _showStatusSelectionSheet(context),
                    child: Text(
                      "Cambiar estado",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: 170,
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                ),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Confirmar cambios'),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Muestra un modal con una lista de estados para seleccionar
  // desde el botton de la pantalla
  void _showStatusSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Seleccionar Estado',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _selectedStatus,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                  Navigator.pop(context);
                },
                items:
                    _statusList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
