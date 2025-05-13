// lib/app/bindings/registros_binding.dart

import 'package:get/get.dart';
import '../controllers/registros_controller.dart';
import '../data/services/cliente_service.dart';
import '../data/services/material_service.dart';
import '../data/services/venta_service.dart';

class RegistrosBinding implements Bindings {
  @override
  void dependencies() {
    // Inicializar servicios con método put directo, no con init() en cascada
    // El método init() se llamará dentro del servicio de forma segura
    
    // Cliente Service
    if (!Get.isRegistered<ClienteService>()) {
      final clienteService = ClienteService();
      Get.put(clienteService, permanent: true);
      // Inicializar de forma segura (sin await en el binding)
      clienteService.init();
    }
    
    // Material Service
    if (!Get.isRegistered<MaterialService>()) {
      final materialService = MaterialService();
      Get.put(materialService, permanent: true);
      materialService.init();
    }
    
    // Venta Service
    if (!Get.isRegistered<VentaService>()) {
      final ventaService = VentaService();
      Get.put(ventaService, permanent: true);
      ventaService.init();
    }
    
    // Inyectar el controlador con put para asegurar inicialización inmediata
    Get.put(RegistrosController());
  }
}