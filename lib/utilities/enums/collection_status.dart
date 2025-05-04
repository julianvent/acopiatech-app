import 'dart:ui';

import 'package:acopiatech/constants/colors_palette.dart';

enum CollectionStatus {
  recibida(
    'Recibida',
    'Tu solicitud de recolección ha sido recibida por el equipo de AcopiaTech. Te notificaremos cuando sea aprobada para recolección.',
    ColorsPalette.statusRecibida,
  ),
  lista(
    'Aprobada para recolección',
    'Tu recolección ha sido aprobada por el equipo de AcopiaTech. Te notificaremos cuando estemos en camino',
    ColorsPalette.statusLista,
  ),
  enCamino(
    'En camino',
    'Nuestro equipo de recolectores está dirigiéndose a tu dirección. Sigue su ubicación en tiempo real.',
    ColorsPalette.statusEnCamino,
  ),
  enEvaluacion(
    'En evaluación',
    'Tus dispositivos fueron recolectados por el equipo de AcopiaTech y se encuentran en proceso de evaluación.',
    ColorsPalette.statusEvaluacion,
  ),
  finalizada(
    'Finalizada',
    'El equipo de AcopiaTech te agradece por tu donación. Te hemos otorgado puntos por la recolección. ¡Gracias!',
    ColorsPalette.statusFinalizada,
  ),
  cancelada(
    'Cancelada',
    'La recolección ha sido cancelada. Contacta con el equipo de AcopiaTech para más información.',
    ColorsPalette.statusCancelada,
  );

  final String status;
  final String description;
  final Color color;

  const CollectionStatus(this.status, this.description, this.color);
}
