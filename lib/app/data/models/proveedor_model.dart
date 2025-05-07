import 'package:cloud_firestore/cloud_firestore.dart';

class ProveedorModel {
  String id;
  String nombre;
  String contacto; // Nombre de la persona de contacto
  String telefono;
  String email;
  String direccion;
  List<String> productos; // IDs de productos que suministra
  
  ProveedorModel({
    this.id = '',
    required this.nombre,
    required this.contacto,
    required this.telefono,
    this.email = '',
    required this.direccion,
    this.productos = const [],
  });
  
  // Constructor desde Firestore
  factory ProveedorModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ProveedorModel(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      contacto: data['contacto'] ?? '',
      telefono: data['telefono'] ?? '',
      email: data['email'] ?? '',
      direccion: data['direccion'] ?? '',
      productos: List<String>.from(data['productos'] ?? []),
    );
  }
  
  // Convertir a mapa para Firestore
  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'contacto': contacto,
    'telefono': telefono,
    'email': email,
    'direccion': direccion,
    'productos': productos,
  };
  
  // Crear copia con campos actualizados
  ProveedorModel copyWith({
    String? nombre,
    String? contacto,
    String? telefono,
    String? email,
    String? direccion,
    List<String>? productos,
  }) {
    return ProveedorModel(
      id: this.id,
      nombre: nombre ?? this.nombre,
      contacto: contacto ?? this.contacto,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      direccion: direccion ?? this.direccion,
      productos: productos ?? this.productos,
    );
  }
}