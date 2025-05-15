// lib/app/data/models/proyecto_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ProyectoModel {
  String id;
  String nombre;
  String descripcion;
  bool activo;

  ProyectoModel({
    this.id = '',
    required this.nombre,
    this.descripcion = '',
    this.activo = true,
  });

  // Constructor desde Firestore
  factory ProyectoModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ProyectoModel(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      activo: data['activo'] ?? true,
    );
  }

  // Convertir a mapa para Firestore
  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'descripcion': descripcion,
    'activo': activo,
  };

  // Crear copia con campos actualizados
  ProyectoModel copyWith({String? nombre, String? descripcion, bool? activo}) {
    return ProyectoModel(
      id: this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      activo: activo ?? this.activo,
    );
  }
}
