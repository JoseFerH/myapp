// lib/app/data/models/nota_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' show Color;

class NotaModel {
  String id;
  String titulo;
  String contenido;
  String icono;
  String categoria;
  Color color;
  DateTime fechaCreacion;
  DateTime fechaModificacion;

  NotaModel({
    this.id = '',
    required this.titulo,
    required this.contenido,
    required this.icono,
    this.categoria = 'General',
    required this.color,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });

  // Constructor desde Firestore
  factory NotaModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return NotaModel(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      contenido: data['contenido'] ?? '',
      icono: data['icono'] ?? 'text_note',
      categoria: data['categoria'] ?? 'General',
      color: Color(data['color'] ?? 0xFF9E9E9E),
      fechaCreacion: (data['fechaCreacion'] as Timestamp).toDate(),
      fechaModificacion: (data['fechaModificacion'] as Timestamp).toDate(),
    );
  }

  // Convertir a mapa para Firestore
  Map<String, dynamic> toMap() => {
    'titulo': titulo,
    'contenido': contenido,
    'icono': icono,
    'categoria': categoria,
    'color': color.value,
    'fechaCreacion': Timestamp.fromDate(fechaCreacion),
    'fechaModificacion': Timestamp.fromDate(fechaModificacion),
  };
}
