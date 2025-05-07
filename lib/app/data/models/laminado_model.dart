import 'package:cloud_firestore/cloud_firestore.dart';
import 'material_model.dart';

enum TipoLaminado {
  mate,
  brillante,
  texturizado
}

class LaminadoModel extends MaterialModel {
  TipoLaminado tipoLaminado;
  String grosor; // Grosor del laminado
  
  LaminadoModel({
    required String id,
    required String nombre,
    required String descripcion,
    required double precioUnitario,
    required int cantidadDisponible,
    required int cantidadMinima,
    required String proveedorId,
    required DateTime fechaCompra,
    required this.tipoLaminado,
    required this.grosor,
  }) : super(
    id: id,
    nombre: nombre,
    descripcion: descripcion,
    tipo: TipoMaterial.laminado,
    precioUnitario: precioUnitario,
    cantidadDisponible: cantidadDisponible,
    cantidadMinima: cantidadMinima,
    proveedorId: proveedorId,
    fechaCompra: fechaCompra,
  );
  
  // Constructor desde Firestore
  factory LaminadoModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    
    return LaminadoModel(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      precioUnitario: (data['precioUnitario'] ?? 0).toDouble(),
      cantidadDisponible: data['cantidadDisponible'] ?? 0,
      cantidadMinima: data['cantidadMinima'] ?? 5,
      proveedorId: data['proveedorId'] ?? '',
      fechaCompra: (data['fechaCompra'] as Timestamp).toDate(),
      tipoLaminado: TipoLaminado.values.firstWhere(
        (e) => e.toString() == 'TipoLaminado.${data['tipoLaminado']}',
        orElse: () => TipoLaminado.mate
      ),
      grosor: data['grosor'] ?? 'Normal',
    );
  }
  
  // Sobreescribir toMap para incluir campos específicos
  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map.addAll({
      'tipoLaminado': tipoLaminado.toString().split('.').last,
      'grosor': grosor,
    });
    return map;
  }
  
  // Crear copia con campos actualizados
  LaminadoModel copyWithLaminado({
    String? nombre,
    String? descripcion,
    double? precioUnitario,
    int? cantidadDisponible,
    int? cantidadMinima,
    String? proveedorId,
    DateTime? fechaCompra,
    TipoLaminado? tipoLaminado,
    String? grosor,
  }) {
    return LaminadoModel(
      id: this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      cantidadDisponible: cantidadDisponible ?? this.cantidadDisponible,
      cantidadMinima: cantidadMinima ?? this.cantidadMinima,
      proveedorId: proveedorId ?? this.proveedorId,
      fechaCompra: fechaCompra ?? this.fechaCompra,
      tipoLaminado: tipoLaminado ?? this.tipoLaminado,
      grosor: grosor ?? this.grosor,
    );
  }
}