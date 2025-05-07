import 'package:cloud_firestore/cloud_firestore.dart';

enum TipoMaterial {
  hoja,
  laminado,
  tinta,
  otros
}

class MaterialModel {
  String id;
  String nombre;
  String descripcion;
  TipoMaterial tipo;
  double precioUnitario;
  int cantidadDisponible;
  int cantidadMinima; // Para alertas de inventario bajo
  String proveedorId;
  DateTime fechaCompra;
  
  MaterialModel({
    this.id = '',
    required this.nombre,
    required this.descripcion,
    required this.tipo,
    required this.precioUnitario,
    required this.cantidadDisponible,
    this.cantidadMinima = 5,
    required this.proveedorId,
    required this.fechaCompra,
  });
  
  // Constructor desde Firestore
  factory MaterialModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return MaterialModel(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      tipo: TipoMaterial.values.firstWhere(
        (e) => e.toString() == 'TipoMaterial.${data['tipo']}',
        orElse: () => TipoMaterial.otros
      ),
      precioUnitario: (data['precioUnitario'] ?? 0).toDouble(),
      cantidadDisponible: data['cantidadDisponible'] ?? 0,
      cantidadMinima: data['cantidadMinima'] ?? 5,
      proveedorId: data['proveedorId'] ?? '',
      fechaCompra: (data['fechaCompra'] as Timestamp).toDate(),
    );
  }
  
  // Convertir a mapa para Firestore
  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'descripcion': descripcion,
    'tipo': tipo.toString().split('.').last,
    'precioUnitario': precioUnitario,
    'cantidadDisponible': cantidadDisponible,
    'cantidadMinima': cantidadMinima,
    'proveedorId': proveedorId,
    'fechaCompra': Timestamp.fromDate(fechaCompra),
  };
  
  // Verificar si el stock es bajo
  bool get esBajoStock => cantidadDisponible <= cantidadMinima;
  
  // Crear copia con campos actualizados
  MaterialModel copyWith({
    String? nombre,
    String? descripcion,
    TipoMaterial? tipo,
    double? precioUnitario,
    int? cantidadDisponible,
    int? cantidadMinima,
    String? proveedorId,
    DateTime? fechaCompra,
  }) {
    return MaterialModel(
      id: this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      tipo: tipo ?? this.tipo,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      cantidadDisponible: cantidadDisponible ?? this.cantidadDisponible,
      cantidadMinima: cantidadMinima ?? this.cantidadMinima,
      proveedorId: proveedorId ?? this.proveedorId,
      fechaCompra: fechaCompra ?? this.fechaCompra,
    );
  }
}