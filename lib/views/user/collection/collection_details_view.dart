import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/cloud/collections/bloc/collection_bloc.dart';
import 'package:acopiatech/services/cloud/collections/collection.dart';
import 'package:acopiatech/utilities/enums/collection_status.dart';
import 'package:acopiatech/views/user/collection/images/collection_gallery_view.dart';
import 'package:acopiatech/views/user/help/user_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionDetailsView extends StatelessWidget {
  final Collection collection;

  const CollectionDetailsView({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    // collection data
    final status = collection.status.status;
    final statusDescription = collection.status.description;
    final description = collection.description;

    // address data
    final String? street = collection.address.elementAt(0);
    final String number =
        '${collection.address.elementAt(1)} ${collection.address.elementAt(2)}'
            .trim();
    final String? neighborhood = collection.address.elementAt(3);

    // date
    final date =
        '${collection.dateScheduled.day}-${collection.dateScheduled.month}-${collection.dateScheduled.year} ${collection.schedule}';

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
            child:
                collection.status == CollectionStatus.enCamino
                    ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => BlocProvider.value(
                                    value: BlocProvider.of<CollectionBloc>(
                                      context,
                                    ),
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
                                  "Ayuda",
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
                    )
                    : SizedBox(),
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
                  alignment: Alignment.centerLeft,
                  child: Text(
                    collection.mode,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                // Mapa & Estado de la recolección
                Container(
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
                // ------ Detalles de la recolección ------
                Container(
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
                                Flexible(
                                  child: Text('$street $number, $neighborhood'),
                                ),
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
                SizedBox(
                  width: 170,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => BlocProvider.value(
                                value: BlocProvider.of<CollectionBloc>(context),
                                child: CollectionGalleryView(
                                  // Cambiar por la lista de imágenes de la recolección
                                  // images: collection.images,
                                  images: ['assets/images/LogoAcopiaTech.png'],
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
                            "Ver fotos",
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
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            surfaceTintColor: ColorsPalette.darkCian,
                            title: Text("Cancelar recolección"),
                            content: Text(
                              "¿Estás seguro de que deseas cancelar la recolección?",
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("No"),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Implementar la lógica para cancelar la recolección
                                  Navigator.of(context).pop();
                                },
                                child: Text("Sí"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Cancelar recolección'),
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
}
