// lib/app/bindings/registros_binding.dart

import 'package:get/get.dart';
import '../controllers/registros_controller.dart';
import '../data/services/cliente_service.dart';
import '../data/services/material_service.dart';
import '../data/services/venta_service.dart';

class RegistrosBinding implements Bindings {
  @override
  void dependencies() {
    // Inicializar servicios primero
    
    // Cliente Service
    if (!Get.isRegistered<ClienteService>()) {
      Get.put(ClienteService(), permanent: true).init();
    }
    
    // Material Service
    if (!Get.isRegistered<MaterialService>()) {
      Get.put(MaterialService(), permanent: true).init();
    }
    
    // Venta Service
    if (!Get.isRegistered<VentaService>()) {
      Get.put(VentaService(), permanent: true).init();
    }
    
    // Usar Get.put en lugar de Get.lazyPut para inicializar el controlador inmediatamente
    // El parámetro permanent:true evita que se elimine el controlador de la memoria
    Get.put<RegistrosController>(RegistrosController(), permanent: true);
  }
}