import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../providers/ventas_provider.dart';
import '../providers/clientes_provider.dart';
import '../providers/materiales_provider.dart';
import '../models/venta_model.dart';
import '../models/cliente_model.dart';
import '../models/material_model.dart';
import '../models/item_venta_model.dart';

class EstadisticasService extends GetxService {
  final VentasProvider _ventasProvider = VentasProvider();
  final ClientesProvider _clientesProvider = ClientesProvider();
  final MaterialesProvider _materialesProvider = MaterialesProvider();

  // Rx Variables para el estado
  final RxBool cargando = false.obs;
  final RxString error = ''.obs;

  // Datos para dashboard
  final RxMap<String, dynamic> resumenVentas = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> datosGraficoVentas =
      <Map<String, dynamic>>[].obs;
  final RxList<ClienteModel> topClientes = <ClienteModel>[].obs;
  final RxList<Map<String, dynamic>> productosPopulares =
      <Map<String, dynamic>>[].obs;
  final RxList<MaterialModel> materialesBajoStock = <MaterialModel>[].obs;

  // Inicializar servicio
  Future<EstadisticasService> init() async {
    try {
      cargando.value = true;
      error.value = '';

      // Cargar datos iniciales para dashboard
      await Future.wait([
        cargarResumenVentas(),
        cargarDatosGrafico(),
        cargarTopClientes(),
        cargarProductosPopulares(),
        cargarMaterialesBajoStock(),
      ]);

      return this;
    } catch (e) {
      error.value = 'Error al inicializar estadísticas: $e';
      print(error.value);
      return this;
    } finally {
      cargando.value = false;
    }
  }

  // Cargar resumen de ventas (hoy, semana, mes)
  Future<void> cargarResumenVentas() async {
    try {
      Map<String, dynamic> resumen = {};

      // Obtener estadísticas de hoy
      Map<String, dynamic> hoy = await _ventasProvider
          .obtenerEstadisticasVentas('hoy');

      // Obtener estadísticas de la semana
      Map<String, dynamic> semana = await _ventasProvider
          .obtenerEstadisticasVentas('semana');

      // Obtener estadísticas del mes
      Map<String, dynamic> mes = await _ventasProvider
          .obtenerEstadisticasVentas('mes');

      resumen['hoy'] = hoy;
      resumen['semana'] = semana;
      resumen['mes'] = mes;

      resumenVentas.assignAll(resumen);
    } catch (e) {
      error.value = 'Error al cargar resumen: $e';
      print(error.value);
    }
  }

  // Cargar datos para gráfico de ventas
  Future<void> cargarDatosGrafico() async {
    try {
      List<Map<String, dynamic>> datos =
          await _ventasProvider.obtenerDatosGraficoVentas();
      datosGraficoVentas.assignAll(datos);
    } catch (e) {
      error.value = 'Error al cargar datos gráfico: $e';
      print(error.value);
    }
  }

  // Cargar top clientes
  Future<void> cargarTopClientes() async {
    try {
      List<ClienteModel> clientes = await _clientesProvider.obtenerTopClientes(
        5,
      );
      topClientes.assignAll(clientes);
    } catch (e) {
      error.value = 'Error al cargar top clientes: $e';
      print(error.value);
    }
  }

  // Cargar productos populares
  Future<void> cargarProductosPopulares() async {
    try {
      // Obtener ventas del último mes
      final ahora = DateTime.now();
      final hace30Dias = ahora.subtract(Duration(days: 30));

      List<VentaModel> ventas = await _ventasProvider.obtenerVentasPorFecha(
        hace30Dias,
        ahora,
      );

      // Filtrar solo ventas completadas
      ventas = ventas.where((v) => v.estado == EstadoVenta.completada).toList();

      // Contabilizar ocurrencias de cada tipo de producto
      Map<String, Map<String, dynamic>> conteoProductos = {};

      for (var venta in ventas) {
        for (var item in venta.items) {
          // Crear clave única para el tipo de producto
          final clave =
              '${item.tamano.toString()}_${item.hojaId}_${item.laminadoId}';

          if (!conteoProductos.containsKey(clave)) {
            conteoProductos[clave] = {
              'tamano': item.tamano,
              'nombreHoja': item.nombreHoja,
              'nombreLaminado': item.nombreLaminado,
              'cantidad': 0,
              'ventas': 0.0,
            };
          }

          conteoProductos[clave]!['cantidad'] += item.cantidad;
          conteoProductos[clave]!['ventas'] += item.precioTotal;
        }
      }

      // Convertir a lista para ordenar
      List<Map<String, dynamic>> listaProductos =
          conteoProductos.values.toList();

      // Ordenar por cantidad vendida
      listaProductos.sort(
        (a, b) => (b['cantidad'] as int).compareTo(a['cantidad'] as int),
      );

      // Limitar a top 5
      if (listaProductos.length > 5) {
        listaProductos = listaProductos.sublist(0, 5);
      }

      productosPopulares.assignAll(listaProductos);
    } catch (e) {
      error.value = 'Error al cargar productos populares: $e';
      print(error.value);
    }
  }

  // Cargar materiales con bajo stock
  Future<void> cargarMaterialesBajoStock() async {
    try {
      List<MaterialModel> materiales =
          await _materialesProvider.obtenerMaterialesBajoStock();
      materialesBajoStock.assignAll(materiales);
    } catch (e) {
      error.value = 'Error al cargar materiales bajo stock: $e';
      print(error.value);
    }
  }

  // Actualizar todos los datos del dashboard
  Future<void> actualizarDashboard() async {
    try {
      cargando.value = true;
      error.value = '';

      await Future.wait([
        cargarResumenVentas(),
        cargarDatosGrafico(),
        cargarTopClientes(),
        cargarProductosPopulares(),
        cargarMaterialesBajoStock(),
      ]);
    } catch (e) {
      error.value = 'Error al actualizar dashboard: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }

  // Obtener totales para un período
  double obtenerTotalPeriodo(String periodo) {
    if (resumenVentas.containsKey(periodo)) {
      return resumenVentas[periodo]['totalVentas'] ?? 0.0;
    }
    return 0.0;
  }

  // Obtener cantidad de ventas para un período
  int obtenerCantidadVentasPeriodo(String periodo) {
    if (resumenVentas.containsKey(periodo)) {
      return resumenVentas[periodo]['cantidadVentas'] ?? 0;
    }
    return 0;
  }

  // Obtener promedio de venta para un período
  double obtenerPromedioVentaPeriodo(String periodo) {
    if (resumenVentas.containsKey(periodo)) {
      var promedioVenta = resumenVentas[periodo]['promedioVenta'];
      // Convertir explícitamente a double independientemente del tipo original
      if (promedioVenta == null) {
        return 0.0;
      } else if (promedioVenta is int) {
        return promedioVenta.toDouble();
      } else if (promedioVenta is double) {
        return promedioVenta;
      } else {
        // Intentar convertir cualquier otro tipo a double
        return double.tryParse(promedioVenta.toString()) ?? 0.0;
      }
    }
    return 0.0;
  }

  // Obtener porcentaje de variación entre períodos
  double obtenerVariacionPorcentual(
    String periodoActual,
    String periodoAnterior,
  ) {
    double totalActual = obtenerTotalPeriodo(periodoActual);
    double totalAnterior = obtenerTotalPeriodo(periodoAnterior);

    if (totalAnterior == 0) return 0;

    return ((totalActual - totalAnterior) / totalAnterior) * 100;
  }
}
