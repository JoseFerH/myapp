// lib/app/controllers/estadisticas_controller.dart

import 'package:get/get.dart';
import '../data/models/cliente_model.dart';
import '../data/models/material_model.dart';
import '../data/services/estadisticas_service.dart';

class EstadisticasController extends GetxController {
  // Servicios
  final EstadisticasService _estadisticasService = Get.find<EstadisticasService>();
  
  // Variables reactivas de UI
  final RxBool cargando = false.obs;
  final RxString error = ''.obs;
  final RxString periodoSeleccionado = 'mes'.obs; // 'dia', 'semana', 'mes'
  
  // Getters para acceder a las variables del servicio
  RxMap<String, dynamic> get resumenVentas => _estadisticasService.resumenVentas;
  RxList<Map<String, dynamic>> get datosGraficoVentas => _estadisticasService.datosGraficoVentas;
  RxList<ClienteModel> get topClientes => _estadisticasService.topClientes;
  RxList<Map<String, dynamic>> get productosPopulares => _estadisticasService.productosPopulares;
  RxList<MaterialModel> get materialesBajoStock => _estadisticasService.materialesBajoStock;
  
  @override
  void onInit() async {
    super.onInit();
    cargando.value = true;
    try {
      // Inicializar servicio
      await _estadisticasService.init();
    } catch (e) {
      error.value = 'Error al inicializar: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }
  
  // Actualizar dashboard completo
  Future<void> actualizarDashboard() async {
    try {
      cargando.value = true;
      error.value = '';
      
      await _estadisticasService.actualizarDashboard();
    } catch (e) {
      error.value = 'Error al actualizar dashboard: $e';
      print(error.value);
    } finally {
      cargando.value = false;
    }
  }
  
  // Cambiar período seleccionado
  void cambiarPeriodo(String periodo) {
    periodoSeleccionado.value = periodo;
  }
  
  // Obtener total para el período seleccionado
  double obtenerTotalPeriodo() {
    return _estadisticasService.obtenerTotalPeriodo(periodoSeleccionado.value);
  }
  
  // Obtener cantidad de ventas para el período seleccionado
  int obtenerCantidadVentas() {
    return _estadisticasService.obtenerCantidadVentasPeriodo(periodoSeleccionado.value);
  }
  
  // Obtener promedio de venta para el período seleccionado
  double obtenerPromedioVenta() {
    return _estadisticasService.obtenerPromedioVentaPeriodo(periodoSeleccionado.value);
  }
  
  // Obtener variación porcentual respecto al período anterior
  double obtenerVariacionPorcentual() {
    String periodoAnterior;
    
    switch (periodoSeleccionado.value) {
      case 'dia':
        return 0.0; // No hay comparación para período diario
      case 'semana':
        periodoAnterior = 'dia';
        break;
      case 'mes':
      default:
        periodoAnterior = 'semana';
        break;
    }
    
    return _estadisticasService.obtenerVariacionPorcentual(
      periodoSeleccionado.value,
      periodoAnterior,
    );
  }
}