import 'package:cloud_firestore/cloud_firestore.dart';
import 'item_venta_model.dart';

enum EstadoVenta {
  cotizacion,
  pendiente,
  completada,
  cancelada
}

enum TipoEnvio {
  normal,    // Q18
  express,   // Q30
  personalizado
}

class VentaModel {
  String id;
  String clienteId;
  String nombreCliente;
  DateTime fecha;
  EstadoVenta estado;
  List<ItemVentaModel> items;
  TipoEnvio tipoEnvio;
  double costoEnvio;
  double subtotal;
  double total;
  String notas;
  
  VentaModel({
    this.id = '',
    required this.clienteId,
    required this.nombreCliente,
    required this.fecha,
    this.estado = EstadoVenta.cotizacion,
    required this.items,
    required this.tipoEnvio,
    required this.costoEnvio,
    required this.subtotal,
    required this.total,
    this.notas = '',
  });
  
  // Constructor desde Firestore
  factory VentaModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    
    List<ItemVentaModel> itemsList = [];
    if (data['items'] != null) {
      for (var item in data['items']) {
        itemsList.add(
          ItemVentaModel(
            hojaId: item['hojaId'] ?? '',
            nombreHoja: item['nombreHoja'] ?? '',
            laminadoId: item['laminadoId'] ?? '',
            nombreLaminado: item['nombreLaminado'] ?? '',
            tamano: TamanoSticker.values.firstWhere(
              (e) => e.toString() == 'TamanoSticker.${item['tamano']}',
              orElse: () => TamanoSticker.cuarto
            ),
            tipoDiseno: TipoDiseno.values.firstWhere(
              (e) => e.toString() == 'TipoDiseno.${item['tipoDiseno']}',
              orElse: () => TipoDiseno.estandar
            ),
            precioDiseno: (item['precioDiseno'] ?? 0).toDouble(),
            aplicarDesperdicio: item['aplicarDesperdicio'] ?? true,
            cantidad: item['cantidad'] ?? 1,
            precioUnitario: (item['precioUnitario'] ?? 0).toDouble(),
            precioTotal: (item['precioTotal'] ?? 0).toDouble(),
          )
        );
      }
    }
    
    return VentaModel(
      id: doc.id,
      clienteId: data['clienteId'] ?? '',
      nombreCliente: data['nombreCliente'] ?? '',
      fecha: (data['fecha'] as Timestamp).toDate(),
      estado: EstadoVenta.values.firstWhere(
        (e) => e.toString() == 'EstadoVenta.${data['estado']}',
        orElse: () => EstadoVenta.cotizacion
      ),
      items: itemsList,
      tipoEnvio: TipoEnvio.values.firstWhere(
        (e) => e.toString() == 'TipoEnvio.${data['tipoEnvio']}',
        orElse: () => TipoEnvio.normal
      ),
      costoEnvio: (data['costoEnvio'] ?? 0).toDouble(),
      subtotal: (data['subtotal'] ?? 0).toDouble(),
      total: (data['total'] ?? 0).toDouble(),
      notas: data['notas'] ?? '',
    );
  }
  
  // Convertir a mapa para Firestore
  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> itemsMaps = items.map((item) => item.toMap()).toList();
    
    return {
      'clienteId': clienteId,
      'nombreCliente': nombreCliente,
      'fecha': Timestamp.fromDate(fecha),
      'estado': estado.toString().split('.').last,
      'items': itemsMaps,
      'tipoEnvio': tipoEnvio.toString().split('.').last,
      'costoEnvio': costoEnvio,
      'subtotal': subtotal,
      'total': total,
      'notas': notas,
    };
  }
  
  // Método para recalcular el total
  void recalcularTotal() {
    subtotal = items.fold(0, (sum, item) => sum + item.precioTotal);
    total = subtotal + costoEnvio;
  }
  
  // Agregar un ítem
  void agregarItem(ItemVentaModel item) {
    items.add(item);
    recalcularTotal();
  }
  
  // Eliminar un ítem
  void eliminarItem(String itemId) {
    items.removeWhere((item) => item.id == itemId);
    recalcularTotal();
  }
  
  // Crear copia con campos actualizados
  VentaModel copyWith({
    String? clienteId,
    String? nombreCliente,
    DateTime? fecha,
    EstadoVenta? estado,
    List<ItemVentaModel>? items,
    TipoEnvio? tipoEnvio,
    double? costoEnvio,
    double? subtotal,
    double? total,
    String? notas,
  }) {
    return VentaModel(
      id: this.id,
      clienteId: clienteId ?? this.clienteId,
      nombreCliente: nombreCliente ?? this.nombreCliente,
      fecha: fecha ?? this.fecha,
      estado: estado ?? this.estado,
      items: items ?? this.items,
      tipoEnvio: tipoEnvio ?? this.tipoEnvio,
      costoEnvio: costoEnvio ?? this.costoEnvio,
      subtotal: subtotal ?? this.subtotal,
      total: total ?? this.total,
      notas: notas ?? this.notas,
    );
  }
}