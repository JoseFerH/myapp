// lib/app/bindings/visualizacion_binding.dart

import 'package:get/get.dart';
import '../controllers/visualizacion_controller.dart';
import '../data/services/venta_service.dart';
import '../data/services/cliente_service.dart';
import '../data/services/exportacion_service.dart';
import '../data/services/pdf_service.dart';

class VisualizacionBinding implements Bindings {
  @override
  void dependencies() {
    // Servicios necesarios para visualización de datos
    if (!Get.isRegistered<VentaService>()) {
      Get.put(VentaService().init(), permanent: true);
    }
    
    if (!Get.isRegistered<ClienteService>()) {
      Get.put(ClienteService().init(), permanent: true);
    }
    
    if (!Get.isRegistered<ExportacionService>()) {
      Get.put(ExportacionService(), permanent: true);
    }
    
    if (!Get.isRegistered<PDFService>()) {
      Get.put(PDFService(), permanent: true);
    }
    
        // Usar Get.put en lugar de Get.lazyPut para inicialización inmediata
    Get.put<VisualizacionController>(VisualizacionController(), permanent: true);
  }
}