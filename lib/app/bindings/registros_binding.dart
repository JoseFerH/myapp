// lib/app/bindings/registros_binding.dart

import 'package:get/get.dart';
import '../controllers/registros_controller.dart';
import '../data/services/cliente_service.dart';
import '../data/services/material_service.dart';
import '../data/services/venta_service.dart';

class RegistrosBinding implements Bindings {
  @override
  void dependencies() {
    // Servicios necesarios para gestión de registros
    if (!Get.isRegistered<ClienteService>()) {
      Get.put(ClienteService().init(), permanent: true);
    }
    
    if (!Get.isRegistered<MaterialService>()) {
      Get.put(MaterialService().init(), permanent: true);
    }
    
    if (!Get.isRegistered<VentaService>()) {
      Get.put(VentaService().init(), permanent: true);
    }
    
    // Inyectar el controlador
    Get.lazyPut<RegistrosController>(() => RegistrosController());
  }
}