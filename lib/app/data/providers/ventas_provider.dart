import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/venta_model.dart';
import '../models/item_venta_model.dart';
import 'db_provider.dart';
import 'clientes_provider.dart';

class VentasProvider {
  final DBProvider _dbProvider = DBProvider();
  final ClientesProvider _clientesProvider = ClientesProvider();
  
  // Obtener todas las ventas
  Future<List<VentaModel>> obtenerVentas() async {
    try {
      final QuerySnapshot snapshot = await _dbProvider.ventasRef
          .orderBy('fecha', descending: true)
          .get();
          
      return snapshot.docs
          .map((doc) => VentaModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      print('Error al obtener ventas: $e');
      rethrow;
    }
  }
  
  // Obtener ventas por fecha
  Future<List<VentaModel>> obtenerVentasPorFecha(DateTime fechaInicio, DateTime fechaFin) async {
    try {
      // Asegurar que fechaFin incluye todo el día
      fechaFin = DateTime(fechaFin.year, fechaFin.month, fechaFin.day, 23, 59, 59);
      
      final QuerySnapshot snapshot = await _dbProvider.ventasRef
          .where('fecha', isGreaterThanOrEqualTo: Timestamp.fromDate(fechaInicio))
          .where('fecha', isLessThanOrEqualTo: Timestamp.fromDate(fechaFin))
          .orderBy('fecha', descending: true)
          .get();
          
      return snapshot.docs
          .map((doc) => VentaModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      print('Error al obtener ventas por fecha: $e');
      rethrow;
    }
  }
  
  // Obtener ventas por cliente
  Future<List<VentaModel>> obtenerVentasPorCliente(String clienteId) async {
    try {
      final QuerySnapshot snapshot = await _dbProvider.ventasRef
          .where('clienteId', isEqualTo: clienteId)
          .orderBy('fecha', descending: true)
          .get();
          
      return snapshot.docs
          .map((doc) => VentaModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      print('Error al obtener ventas por cliente: $e');
      rethrow;
    }
  }
  
  // Obtener una venta específica por ID
  Future<VentaModel> obtenerVentaPorId(String id) async {
    try {
      final DocumentSnapshot doc = await _dbProvider.ventasRef.doc(id).get();
      
      if (!doc.exists) {
        throw Exception('Venta no encontrada');
      }
      
      return VentaModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      print('Error al obtener venta: $e');
      rethrow;
    }
  }
  
  // Crear una nueva venta
  Future<String> crearVenta(VentaModel venta) async {
    try {
      final docRef = _dbProvider.ventasRef.doc();
      venta.id = docRef.id;
      
      await docRef.set(venta.toMap());
      
      // Si la venta está completada, actualizar el total gastado del cliente
      if (venta.estado == EstadoVenta.completada) {
        await _clientesProvider.actualizarTotalGastado(venta.clienteId, venta.total);
      }
      
      return docRef.id;
    } catch (e) {
      print('Error al crear venta: $e');
      rethrow;
    }
  }
  
  // Actualizar una venta existente
  Future<void> actualizarVenta(VentaModel venta) async {
    try {
      // Obtener la venta anterior para comparar
      final DocumentSnapshot doc = await _dbProvider.ventasRef.doc(venta.id).get();
      
      if (!doc.exists) {
        throw Exception('Venta no encontrada');
      }
      
      VentaModel ventaAnterior = VentaModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      
      // Actualizar la venta
      await _dbProvider.ventasRef
          .doc(venta.id)
          .update(venta.toMap());
      
      // Si la venta cambió a completada, actualizar el total gastado del cliente
      if (ventaAnterior.estado != EstadoVenta.completada && venta.estado == EstadoVenta.completada) {
        await _clientesProvider.actualizarTotalGastado(venta.clienteId, venta.total);
      }
      
      // Si la venta cambió de completada a otro estado, restar el total
      if (ventaAnterior.estado == EstadoVenta.completada && venta.estado != EstadoVenta.completada) {
        await _clientesProvider.actualizarTotalGastado(venta.clienteId, -venta.total);
      }
      
      // Si tanto la venta anterior como la nueva están completadas, pero cambió el total
      if (ventaAnterior.estado == EstadoVenta.completada && 
          venta.estado == EstadoVenta.completada && 
          ventaAnterior.total != venta.total) {
        await _clientesProvider.actualizarTotalGastado(venta.clienteId, venta.total - ventaAnterior.total);
      }
    } catch (e) {
      print('Error al actualizar venta: $e');
      rethrow;
    }
  }
  
  // Eliminar una venta
  Future<void> eliminarVenta(String id) async {
    try {
      final DocumentSnapshot doc = await _dbProvider.ventasRef.doc(id).get();
      
      if (!doc.exists) {
        throw Exception('Venta no encontrada');
      }
      
      VentaModel venta = VentaModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      
      // Si la venta estaba completada, restar el total gastado del cliente
      if (venta.estado == EstadoVenta.completada) {
        await _clientesProvider.actualizarTotalGastado(venta.clienteId, -venta.total);
      }
      
      await _dbProvider.ventasRef.doc(id).delete();
    } catch (e) {
      print('Error al eliminar venta: $e');
      rethrow;
    }
  }
  
  // Cambiar estado de una venta
  Future<void> cambiarEstadoVenta(String id, EstadoVenta nuevoEstado) async {
    try {
      final DocumentSnapshot doc = await _dbProvider.ventasRef.doc(id).get();
      
      if (!doc.exists) {
        throw Exception('Venta no encontrada');
      }
      
      VentaModel venta = VentaModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      EstadoVenta estadoAnterior = venta.estado;
      venta.estado = nuevoEstado;
      
      await _dbProvider.ventasRef
          .doc(id)
          .update({'estado': nuevoEstado.toString().split('.').last});
      
      // Actualizar el total gastado del cliente según el cambio de estado
      if (estadoAnterior != EstadoVenta.completada && nuevoEstado == EstadoVenta.completada) {
        await _clientesProvider.actualizarTotalGastado(venta.clienteId, venta.total);
      }
      
      if (estadoAnterior == EstadoVenta.completada && nuevoEstado != EstadoVenta.completada) {
        await _clientesProvider.actualizarTotalGastado(venta.clienteId, -venta.total);
      }
    } catch (e) {
      print('Error al cambiar estado: $e');
      rethrow;
    }
  }
  
  // Obtener ventas del periodo (hoy, semana, mes)
  Future<List<VentaModel>> obtenerVentasPeriodo(String periodo) async {
    try {
      DateTime ahora = DateTime.now();
      DateTime fechaInicio;
      
      switch (periodo) {
        case 'hoy':
          fechaInicio = DateTime(ahora.year, ahora.month, ahora.day);
          break;
        case 'semana':
          // Obtener el lunes de esta semana
          int diasDesdeInicio = ahora.weekday - 1; // 0 = lunes
          fechaInicio = ahora.subtract(Duration(days: diasDesdeInicio));
          fechaInicio = DateTime(fechaInicio.year, fechaInicio.month, fechaInicio.day);
          break;
        case 'mes':
          fechaInicio = DateTime(ahora.year, ahora.month, 1);
          break;
        default:
          fechaInicio = DateTime(ahora.year, ahora.month, ahora.day);
      }
      
      return obtenerVentasPorFecha(fechaInicio, ahora);
    } catch (e) {
      print('Error al obtener ventas del periodo: $e');
      rethrow;
    }
  }
  
  // Obtener estadísticas de ventas por periodo (día, semana, mes)
  Future<Map<String, dynamic>> obtenerEstadisticasVentas(String periodo) async {
    try {
      List<VentaModel> ventas = await obtenerVentasPeriodo(periodo);
      
      // Solo contar ventas completadas
      ventas = ventas.where((venta) => venta.estado == EstadoVenta.completada).toList();
      
      double totalVentas = ventas.fold(0, (sum, venta) => sum + venta.total);
      int cantidadVentas = ventas.length;
      
      Map<String, dynamic> stats = {
        'totalVentas': totalVentas,
        'cantidadVentas': cantidadVentas,
        'promedioVenta': cantidadVentas > 0 ? totalVentas / cantidadVentas : 0,
      };
      
      return stats;
    } catch (e) {
      print('Error al obtener estadísticas: $e');
      rethrow;
    }
  }
  
  // Obtener datos para gráfico de ventas (últimos 7 días)
  Future<List<Map<String, dynamic>>> obtenerDatosGraficoVentas() async {
    try {
      DateTime ahora = DateTime.now();
      DateTime hace7Dias = ahora.subtract(Duration(days: 6));
      hace7Dias = DateTime(hace7Dias.year, hace7Dias.month, hace7Dias.day);
      
      List<VentaModel> ventas = await obtenerVentasPorFecha(hace7Dias, ahora);
      ventas = ventas.where((venta) => venta.estado == EstadoVenta.completada).toList();
      
      // Crear mapa para almacenar ventas por día
      Map<String, double> ventasPorDia = {};
      
      // Inicializar todos los días en 0
      for (int i = 0; i < 7; i++) {
        DateTime fecha = hace7Dias.add(Duration(days: i));
        String fechaStr = DateFormat('yyyy-MM-dd').format(fecha);
        ventasPorDia[fechaStr] = 0;
      }
      
      // Sumar ventas por día
      for (var venta in ventas) {
        String fechaStr = DateFormat('yyyy-MM-dd').format(venta.fecha);
        if (ventasPorDia.containsKey(fechaStr)) {
          ventasPorDia[fechaStr] = (ventasPorDia[fechaStr] ?? 0) + venta.total;
        }
      }
      
      // Convertir a formato para gráfico
      List<Map<String, dynamic>> datos = [];
      ventasPorDia.forEach((fecha, total) {
        DateTime fechaDt = DateFormat('yyyy-MM-dd').parse(fecha);
        String diaSemana = DateFormat('EEE').format(fechaDt); // Abreviación del día
        
        datos.add({
          'fecha': fecha,
          'dia': diaSemana,
          'total': total,
        });
      });
      
      // Ordenar por fecha
      datos.sort((a, b) => a['fecha'].compareTo(b['fecha']));
      
      return datos;
    } catch (e) {
      print('Error al obtener datos para gráfico: $e');
      rethrow;
    }
  }
}