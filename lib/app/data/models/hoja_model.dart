import 'package:cloud_firestore/cloud_firestore.dart';
import 'material_model.dart';

enum TipoHoja {
  normal,
  premium,
  especial
}

class HojaModel extends MaterialModel {
  TipoHoja tipoHoja;
  String tamano; // Tamaño de la hoja (carta, cuarto, etc.)
  
  HojaModel({
    required String id,
    required String nombre,
    required String descripcion,
    required double precioUnitario,
    required int cantidadDisponible,
    required int cantidadMinima,
    required String proveedorId,
    required DateTime fechaCompra,
    required this.tipoHoja,
    required this.tamano,
  }) : super(
    id: id,
    nombre: nombre,
    descripcion: descripcion,
    tipo: TipoMaterial.hoja,
    precioUnitario: precioUnitario,
    cantidadDisponible: cantidadDisponible,
    cantidadMinima: cantidadMinima,
    proveedorId: proveedorId,
    fechaCompra: fechaCompra,
  );
  
  // Constructor desde Firestore
  factory HojaModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    
    return HojaModel(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      precioUnitario: (data['precioUnitario'] ?? 0).toDouble(),
      cantidadDisponible: data['cantidadDisponible'] ?? 0,
      cantidadMinima: data['cantidadMinima'] ?? 5,
      proveedorId: data['proveedorId'] ?? '',
      fechaCompra: (data['fechaCompra'] as Timestamp).toDate(),
      tipoHoja: TipoHoja.values.firstWhere(
        (e) => e.toString() == 'TipoHoja.${data['tipoHoja']}',
        orElse: () => TipoHoja.normal
      ),
      tamano: data['tamano'] ?? 'Carta',
    );
  }
  
  // Sobreescribir toMap para incluir campos específicos
  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map.addAll({
      'tipoHoja': tipoHoja.toString().split('.').last,
      'tamano': tamano,
    });
    return map;
  }
  
  // Crear copia con campos actualizados
  HojaModel copyWithHoja({
    String? nombre,
    String? descripcion,
    double? precioUnitario,
    int? cantidadDisponible,
    int? cantidadMinima,
    String? proveedorId,
    DateTime? fechaCompra,
    TipoHoja? tipoHoja,
    String? tamano,
  }) {
    return HojaModel(
      id: this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      cantidadDisponible: cantidadDisponible ?? this.cantidadDisponible,
      cantidadMinima: cantidadMinima ?? this.cantidadMinima,
      proveedorId: proveedorId ?? this.proveedorId,
      fechaCompra: fechaCompra ?? this.fechaCompra,
      tipoHoja: tipoHoja ?? this.tipoHoja,
      tamano: tamano ?? this.tamano,
    );
  }
}