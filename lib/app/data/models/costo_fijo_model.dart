import 'package:cloud_firestore/cloud_firestore.dart';

class CostoFijoModel {
  String id;
  String nombre;
  String descripcion;
  double valor;
  bool activo;
  
  CostoFijoModel({
    this.id = '',
    required this.nombre,
    this.descripcion = '',
    required this.valor,
    this.activo = true,
  });
  
  // Constructor desde Firestore
  factory CostoFijoModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return CostoFijoModel(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      valor: (data['valor'] ?? 0).toDouble(),
      activo: data['activo'] ?? true,
    );
  }
  
  // Convertir a mapa para Firestore
  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'descripcion': descripcion,
    'valor': valor,
    'activo': activo,
  };
  
  // Crear copia con campos actualizados
  CostoFijoModel copyWith({
    String? nombre,
    String? descripcion,
    double? valor,
    bool? activo,
  }) {
    return CostoFijoModel(
      id: this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      valor: valor ?? this.valor,
      activo: activo ?? this.activo,
    );
  }
}