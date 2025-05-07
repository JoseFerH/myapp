// lib/app/bindings/estadisticas_binding.dart

import 'package:get/get.dart';
import '../controllers/estadisticas_controller.dart';
import '../data/services/estadisticas_service.dart';

class EstadisticasBinding implements Bindings {
  @override
  void dependencies() {
    // Servicios necesarios para estadísticas
    if (!Get.isRegistered<EstadisticasService>()) {
      Get.put(EstadisticasService().init(), permanent: true);
    }
    
    // Inyectar el controlador
    Get.lazyPut<EstadisticasController>(() => EstadisticasController());
  }
}