import 'package:get/get.dart';
import '../models/venta_model.dart';
import '../models/item_venta_model.dart';
import '../providers/ventas_provider.dart';
import '../providers/materiales_provider.dart';
import '../services/cliente_service.dart'; // Importamos el servicio de cliente

class VentaService extends GetxService {
  final VentasProvider _ventasProvider = VentasProvider();
  final MaterialesProvider _materialesProvider = MaterialesProvider();

  // Rx Variables para el estado
  final RxBool cargando = false.obs;
  final RxString error = ''.obs;

  // Rx Variables para listas
  final RxList<VentaModel> ventas = <VentaModel>[].obs;

  // Venta actual
  final Rx<VentaModel?> ventaActual = Rx<VentaModel?>(null);

  // Inicializar servicio
  Future<VentaService> init() async {
    await cargarVentas();
    return this;
  }

  // Cargar todas las ventas
  Future<void> cargarVentas() async {
    try {
      cargando.value = true;
      error.value = '';

      List<VentaModel> listaVentas = await _ventasProvider.obtenerVentas();
      ventas.assignAll(listaVentas);
    } catch (e) {
      error.value = 'Error al cargar ventas: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }

  // Cargar ventas por período
  Future<List<VentaModel>> cargarVentasPorFecha(
    DateTime fechaInicio,
    DateTime fechaFin,
  ) async {
    try {
      cargando.value = true;
      error.value = '';

      List<VentaModel> listaVentas = await _ventasProvider
          .obtenerVentasPorFecha(fechaInicio, fechaFin);
      return listaVentas;
    } catch (e) {
      error.value = 'Error al cargar ventas por fecha: $e';
      print(error.value);
      return [];
    } finally {
      cargando.value = false;
    }
  }

  // Cargar ventas por cliente
  Future<List<VentaModel>> cargarVentasPorCliente(String clienteId) async {
    try {
      cargando.value = true;
      error.value = '';

      List<VentaModel> listaVentas = await _ventasProvider
          .obtenerVentasPorCliente(clienteId);
      return listaVentas;
    } catch (e) {
      error.value = 'Error al cargar ventas por cliente: $e';
      print(error.value);
      return [];
    } finally {
      cargando.value = false;
    }
  }

  // Cargar venta por ID
  Future<VentaModel?> cargarVentaPorId(String id) async {
    try {
      cargando.value = true;
      error.value = '';

      VentaModel venta = await _ventasProvider.obtenerVentaPorId(id);
      ventaActual.value = venta;
      return venta;
    } catch (e) {
      error.value = 'Error al cargar venta: $e';
      print(error.value);
      return null;
    } finally {
      cargando.value = false;
    }
  }

  // Crear nueva venta
  Future<String> crearVenta(VentaModel venta) async {
    try {
      cargando.value = true;
      error.value = '';

      // Si es una venta completada, reducir stock de materiales
      if (venta.estado == EstadoVenta.completada) {
        await _reducirStockMateriales(venta.items);

        // Actualizar estadísticas del cliente si tiene cliente asignado
        if (venta.clienteId.isNotEmpty) {
          await _actualizarEstadisticasCliente(venta);
        }
      }

      String id = await _ventasProvider.crearVenta(venta);

      // Actualizar lista local
      await cargarVentas();

      return id;
    } catch (e) {
      error.value = 'Error al crear venta: $e';
      print(error.value);
      return '';
    } finally {
      cargando.value = false;
    }
  }

  // Actualizar venta existente
  Future<bool> actualizarVenta(VentaModel venta) async {
    try {
      cargando.value = true;
      error.value = '';

      // Obtener estado anterior
      VentaModel? ventaAnterior = await _ventasProvider.obtenerVentaPorId(
        venta.id,
      );

      // Ajustar inventario según cambio de estado
      if (ventaAnterior.estado != EstadoVenta.completada &&
          venta.estado == EstadoVenta.completada) {
        // Si cambia a completada, reducir stock
        await _reducirStockMateriales(venta.items);

        // Actualizar estadísticas del cliente si tiene cliente asignado
        if (venta.clienteId.isNotEmpty) {
          await _actualizarEstadisticasCliente(venta);
        }
      } else if (ventaAnterior.estado == EstadoVenta.completada &&
          venta.estado != EstadoVenta.completada) {
        // Si cambia de completada a otro estado, aumentar stock
        await _aumentarStockMateriales(venta.items);

        // Posible código para revertir las estadísticas del cliente
        // No implementado para evitar complejidad excesiva
      }

      await _ventasProvider.actualizarVenta(venta);

      // Actualizar lista local
      await cargarVentas();

      // Actualizar venta actual si es la misma
      if (ventaActual.value != null && ventaActual.value!.id == venta.id) {
        ventaActual.value = venta;
      }

      return true;
    } catch (e) {
      error.value = 'Error al actualizar venta: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }

  // Eliminar venta
  Future<bool> eliminarVenta(String id) async {
    try {
      cargando.value = true;
      error.value = '';

      // Verificar si es una venta completada para devolver stock
      VentaModel? venta = await _ventasProvider.obtenerVentaPorId(id);
      if (venta.estado == EstadoVenta.completada) {
        await _aumentarStockMateriales(venta.items);
      }

      await _ventasProvider.eliminarVenta(id);

      // Actualizar lista local
      await cargarVentas();

      // Limpiar venta actual si es la misma
      if (ventaActual.value != null && ventaActual.value!.id == id) {
        ventaActual.value = null;
      }

      return true;
    } catch (e) {
      error.value = 'Error al eliminar venta: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }

  // Cambiar estado de una venta
  Future<bool> cambiarEstadoVenta(String id, EstadoVenta nuevoEstado) async {
    try {
      cargando.value = true;
      error.value = '';

      // Obtener estado anterior
      VentaModel? venta = await _ventasProvider.obtenerVentaPorId(id);
      EstadoVenta estadoAnterior = venta.estado;

      // Ajustar inventario según cambio de estado
      if (estadoAnterior != EstadoVenta.completada &&
          nuevoEstado == EstadoVenta.completada) {
        // Si cambia a completada, reducir stock
        await _reducirStockMateriales(venta.items);

        // Actualizar estadísticas del cliente si tiene cliente asignado
        if (venta.clienteId.isNotEmpty) {
          await _actualizarEstadisticasCliente(venta);
        }
      } else if (estadoAnterior == EstadoVenta.completada &&
          nuevoEstado != EstadoVenta.completada) {
        // Si cambia de completada a otro estado, aumentar stock
        await _aumentarStockMateriales(venta.items);

        // Posible código para revertir las estadísticas del cliente
        // No implementado para evitar complejidad excesiva
      }

      await _ventasProvider.cambiarEstadoVenta(id, nuevoEstado);

      // Actualizar lista local
      await cargarVentas();

      // Actualizar venta actual si es la misma
      if (ventaActual.value != null && ventaActual.value!.id == id) {
        await cargarVentaPorId(id);
      }

      return true;
    } catch (e) {
      error.value = 'Error al cambiar estado: $e';
      print(error.value);
      return false;
    } finally {
      cargando.value = false;
    }
  }

  // Reducir stock de materiales al completar una venta
  Future<void> _reducirStockMateriales(List<ItemVentaModel> items) async {
    for (var item in items) {
      // Calcular cantidad de hojas a reducir según tamaño
      double factorHoja;
      switch (item.tamano) {
        case TamanoSticker.cuarto:
          factorHoja = 0.25;
          break;
        case TamanoSticker.medio:
          factorHoja = 0.5;
          break;
        case TamanoSticker.tresQuartos:
          factorHoja = 0.75;
          break;
        case TamanoSticker.completo:
          factorHoja = 1.0;
          break;
      }

      int cantidadHojas = (item.cantidad * factorHoja).ceil();

      // Reducir stock de hojas
      await _materialesProvider.reducirStock(item.hojaId, cantidadHojas);

      // Reducir stock de laminado (mismo cálculo que hojas)
      await _materialesProvider.reducirStock(item.laminadoId, cantidadHojas);
    }
  }

  // Aumentar stock de materiales al cancelar una venta completada
  Future<void> _aumentarStockMateriales(List<ItemVentaModel> items) async {
    for (var item in items) {
      // Calcular cantidad de hojas a devolver según tamaño
      double factorHoja;
      switch (item.tamano) {
        case TamanoSticker.cuarto:
          factorHoja = 0.25;
          break;
        case TamanoSticker.medio:
          factorHoja = 0.5;
          break;
        case TamanoSticker.tresQuartos:
          factorHoja = 0.75;
          break;
        case TamanoSticker.completo:
          factorHoja = 1.0;
          break;
      }

      int cantidadHojas = (item.cantidad * factorHoja).ceil();

      // Aumentar stock de hojas
      await _materialesProvider.aumentarStock(item.hojaId, cantidadHojas);

      // Aumentar stock de laminado (mismo cálculo que hojas)
      await _materialesProvider.aumentarStock(item.laminadoId, cantidadHojas);
    }
  }

  // NUEVA FUNCIONALIDAD: Actualizar estadísticas del cliente
  Future<void> _actualizarEstadisticasCliente(VentaModel venta) async {
    // Verificar que la venta tenga cliente asignado
    if (venta.clienteId.isEmpty) return;

    try {
      // Obtener el servicio de clientes
      final clienteService = Get.find<ClienteService>();

      // Incrementar compras del cliente y actualizar estado
      await clienteService.incrementarComprasCliente(
        venta.clienteId,
        venta.total,
      );
    } catch (e) {
      print('Error al actualizar estadísticas de cliente: $e');
      // No arrojamos el error para no interrumpir el flujo de la venta
    }
  }
}
