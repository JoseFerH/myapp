// lib/app/bindings/configuracion_binding.dart

import 'package:get/get.dart';
import '../controllers/configuracion_controller.dart';
import '../data/providers/configuracion_provider.dart';

class ConfiguracionBinding implements Bindings {
  @override
  void dependencies() {
    // Proveedores necesarios para la configuración
    if (!Get.isRegistered<ConfiguracionProvider>()) {
      Get.put(ConfiguracionProvider(), permanent: true);
    }
    
    // Inyectar el controlador
    Get.lazyPut<ConfiguracionController>(() => ConfiguracionController());
  }
}