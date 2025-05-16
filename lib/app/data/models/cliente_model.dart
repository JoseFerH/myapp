import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteModel {
  String id;
  String nombre;
  String direccion;
  String tipoCliente; // NUEVO, Regular, Frecuente, VIP
  String zona; // Zona de ubicación en Guatemala
  double totalGastado;
  int comprasRealizadas; // Nuevo campo para contar compras

  ClienteModel({
    this.id = '',
    required this.nombre,
    required this.direccion,
    this.tipoCliente = 'NUEVO', // Por defecto ahora es NUEVO
    required this.zona,
    this.totalGastado = 0.0,
    this.comprasRealizadas = 0, // Inicializado en 0
  });

  // Constructor desde Firestore
  factory ClienteModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ClienteModel(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      direccion: data['direccion'] ?? '',
      tipoCliente: data['tipoCliente'] ?? 'NUEVO',
      zona: data['zona'] ?? '',
      totalGastado: (data['totalGastado'] ?? 0).toDouble(),
      comprasRealizadas: data['comprasRealizadas'] ?? 0,
    );
  }

  // Convertir a mapa para Firestore
  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'direccion': direccion,
    'tipoCliente': tipoCliente,
    'zona': zona,
    'totalGastado': totalGastado,
    'comprasRealizadas': comprasRealizadas,
  };

  // Crear copia con campos actualizados
  ClienteModel copyWith({
    String? nombre,
    String? direccion,
    String? tipoCliente,
    String? zona,
    double? totalGastado,
    int? comprasRealizadas,
  }) {
    return ClienteModel(
      id: this.id,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      tipoCliente: tipoCliente ?? this.tipoCliente,
      zona: zona ?? this.zona,
      totalGastado: totalGastado ?? this.totalGastado,
      comprasRealizadas: comprasRealizadas ?? this.comprasRealizadas,
    );
  }

  // Método estático para determinar el tipo de cliente según cantidad de compras
  static String determinarTipoCliente(int compras) {
    if (compras >= 100) return 'VIP';
    if (compras >= 18) return 'Frecuente';
    if (compras >= 3) return 'Regular';
    return 'NUEVO';
  }

  // Comprobar si debería actualizarse el estado del cliente
  bool deberiaActualizarEstado() {
    String nuevoTipo = determinarTipoCliente(comprasRealizadas);
    return nuevoTipo != tipoCliente;
  }

  // Obtener el próximo nivel y cuántas compras faltan
  Map<String, dynamic> proximoNivel() {
    if (tipoCliente == 'VIP') {
      return {'nivel': 'VIP', 'faltantes': 0};
    } else if (tipoCliente == 'Frecuente') {
      return {'nivel': 'VIP', 'faltantes': 100 - comprasRealizadas};
    } else if (tipoCliente == 'Regular') {
      return {'nivel': 'Frecuente', 'faltantes': 18 - comprasRealizadas};
    } else {
      return {'nivel': 'Regular', 'faltantes': 3 - comprasRealizadas};
    }
  }
}
