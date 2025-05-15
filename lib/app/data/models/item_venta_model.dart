import 'package:cloud_firestore/cloud_firestore.dart';

enum TamanoSticker { cuarto, medio, tresQuartos, completo }

enum TipoDiseno { estandar, personalizado }

class ItemVentaModel {
  String id;
  String hojaId;
  String nombreHoja;
  String laminadoId;
  String nombreLaminado;
  String proyectoId;
  String nombreProyecto;
  TamanoSticker tamano;
  TipoDiseno tipoDiseno;
  double precioDiseno;
  bool aplicarDesperdicio;
  int cantidad;
  double precioUnitario;
  double precioTotal;

  ItemVentaModel({
    this.id = '',
    required this.hojaId,
    required this.nombreHoja,
    required this.laminadoId,
    required this.nombreLaminado,
    required this.tamano,
    required this.tipoDiseno,
    this.proyectoId = '',
    this.nombreProyecto = '',
    this.precioDiseno = 0.0,
    this.aplicarDesperdicio = true,
    required this.cantidad,
    required this.precioUnitario,
    required this.precioTotal,
  });

  // Constructor desde Firestore
  factory ItemVentaModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ItemVentaModel(
      id: doc.id,
      hojaId: data['hojaId'] ?? '',
      nombreHoja: data['nombreHoja'] ?? '',
      laminadoId: data['laminadoId'] ?? '',
      nombreLaminado: data['nombreLaminado'] ?? '',
      tamano: TamanoSticker.values.firstWhere(
        (e) => e.toString() == 'TamanoSticker.${data['tamano']}',
        orElse: () => TamanoSticker.cuarto,
      ),
      tipoDiseno: TipoDiseno.values.firstWhere(
        (e) => e.toString() == 'TipoDiseno.${data['tipoDiseno']}',
        orElse: () => TipoDiseno.estandar,
      ),
      precioDiseno: (data['precioDiseno'] ?? 0).toDouble(),
      aplicarDesperdicio: data['aplicarDesperdicio'] ?? true,
      cantidad: data['cantidad'] ?? 1,
      precioUnitario: (data['precioUnitario'] ?? 0).toDouble(),
      precioTotal: (data['precioTotal'] ?? 0).toDouble(),
      proyectoId: data['proyectoId'] ?? '',
      nombreProyecto: data['nombreProyecto'] ?? '',
    );
  }

  // Convertir a mapa para Firestore
  Map<String, dynamic> toMap() => {
    'hojaId': hojaId,
    'nombreHoja': nombreHoja,
    'laminadoId': laminadoId,
    'nombreLaminado': nombreLaminado,
    'tamano': tamano.toString().split('.').last,
    'tipoDiseno': tipoDiseno.toString().split('.').last,
    'precioDiseno': precioDiseno,
    'aplicarDesperdicio': aplicarDesperdicio,
    'cantidad': cantidad,
    'precioUnitario': precioUnitario,
    'precioTotal': precioTotal,
    'proyectoId': proyectoId,
    'nombreProyecto': nombreProyecto,
  };

  // Método para recalcular el precio total
  void recalcularPrecioTotal() {
    precioTotal = precioUnitario * cantidad;
  }

  // Crear copia con campos actualizados
  ItemVentaModel copyWith({
    String? hojaId,
    String? nombreHoja,
    String? laminadoId,
    String? nombreLaminado,
    TamanoSticker? tamano,
    TipoDiseno? tipoDiseno,
    double? precioDiseno,
    bool? aplicarDesperdicio,
    int? cantidad,
    double? precioUnitario,
    double? precioTotal,
    String? proyectoId,
    String? nombreProyecto,
  }) {
    return ItemVentaModel(
      id: this.id,
      hojaId: hojaId ?? this.hojaId,
      nombreHoja: nombreHoja ?? this.nombreHoja,
      laminadoId: laminadoId ?? this.laminadoId,
      nombreLaminado: nombreLaminado ?? this.nombreLaminado,
      tamano: tamano ?? this.tamano,
      tipoDiseno: tipoDiseno ?? this.tipoDiseno,
      precioDiseno: precioDiseno ?? this.precioDiseno,
      aplicarDesperdicio: aplicarDesperdicio ?? this.aplicarDesperdicio,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      precioTotal: precioTotal ?? this.precioTotal,
      proyectoId: proyectoId ?? this.proyectoId,
      nombreProyecto: nombreProyecto ?? this.nombreProyecto,
    );
  }
}
