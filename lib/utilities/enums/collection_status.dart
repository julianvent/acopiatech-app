import 'dart:ui';

import 'package:acopiatech/constants/colors_palette.dart';

enum CollectionStatus {
  recibida(
    'Recibida',
    'Tu recolección ha sido recibida por el equipo de AcopiaTech. Te notificaremos cuando esté lista para recolección.',
    ColorsPalette.statusRecibida,
  ),
  lista('Lista para recolección', '', ColorsPalette.statusLista),
  enCamino(
    'En camino',
    'Nuestro equipo de recolectores está dirigiéndose a tu dirección. Sigue su ubicación en tiempo real.',
    ColorsPalette.statusEnCamino,
  ),
  enEvaluacion('En evaluación', '', ColorsPalette.statusEvaluacion),
  finalizada('Finalizada', '', ColorsPalette.statusFinalizada),
  cancelada('Cancelada', '', ColorsPalette.statusCancelada);

  final String status;
  final String description;
  final Color color;

  const CollectionStatus(this.status, this.description, this.color);
}
