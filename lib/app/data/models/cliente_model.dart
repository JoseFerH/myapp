import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteModel {
  String id;
  String nombre;
  String direccion;
  String tipoCliente; // Regular, Frecuente, VIP, etc.
  String zona; // Zona de ubicación en Guatemala
  double totalGastado;
  
  ClienteModel({
    this.id = '',
    required this.nombre,
    required this.direccion,
    required this.tipoCliente,
    required this.zona,
    this.totalGastado = 0.0,
  });
  
  // Constructor desde Firestore
  factory ClienteModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ClienteModel(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      direccion: data['direccion'] ?? '',
      tipoCliente: data['tipoCliente'] ?? '',
      zona: data['zona'] ?? '',
      totalGastado: (data['totalGastado'] ?? 0).toDouble(),
    );
  }
  
  // Convertir a mapa para Firestore
  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'direccion': direccion,
    'tipoCliente': tipoCliente,
    'zona': zona,
    'totalGastado': totalGastado,
  };
  
  // Crear copia con campos actualizados
  ClienteModel copyWith({
    String? nombre,
    String? direccion,
    String? tipoCliente,
    String? zona,
    double? totalGastado,
  }) {
    return ClienteModel(
      id: this.id,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      tipoCliente: tipoCliente ?? this.tipoCliente,
      zona: zona ?? this.zona,
      totalGastado: totalGastado ?? this.totalGastado,
    );
  }
}