import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/registros_controller.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';
import 'views/clientes_view.dart';
import 'views/proveedores_view.dart';
import 'views/inventario_view.dart';
import '../../data/services/cliente_service.dart';
import '../../data/services/material_service.dart';
import '../../data/services/venta_service.dart';

class RegistrosView extends GetView<RegistrosController> {
  const RegistrosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inicializar todos los servicios necesarios antes del controlador
    if (!Get.isRegistered<ClienteService>()) {
      Get.put(ClienteService().init(), permanent: true);
    }
    
    if (!Get.isRegistered<MaterialService>()) {
      Get.put(MaterialService().init(), permanent: true);
    }
    
    if (!Get.isRegistered<VentaService>()) {
      Get.put(VentaService().init(), permanent: true);
    }
    
    // Ahora sí, inicializar el controlador
    if (!Get.isRegistered<RegistrosController>()) {
      Get.put(RegistrosController());
    }
    
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Obx(() {
          // Mostrar loading si está cargando
          if (controller.cargando.value) {
            return const LoadingIndicator(message: 'Cargando registros...');
          }
          
          // Mostrar error si existe
          if (controller.error.value.isNotEmpty) {
            return ErrorMessage(
              message: controller.error.value,
              onRetry: () => controller.onInit(),
            );
          }
          
          return Column(
            children: [
              // Barra de búsqueda
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CupertinoSearchTextField(
                  placeholder: 'Buscar en registros',
                  onChanged: controller.setFiltro,
                ),
              ),
              
              // Selector de tipo de registro
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CupertinoSegmentedControl<int>(
                  children: const {
                    0: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Clientes'),
                    ),
                    1: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Proveedores'),
                    ),
                    2: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Inventario'),
                    ),
                  },
                  groupValue: controller.tabIndex.value,
                  onValueChanged: controller.cambiarTab,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Contenido según pestaña seleccionada
              Expanded(
                child: Obx(() {
                  switch (controller.tabIndex.value) {
                    case 0:
                      return const ClientesView();
                    case 1:
                      return const ProveedoresView();
                    case 2:
                      return const InventarioView();
                    default:
                      return const ClientesView();
                  }
                }),
              ),
            ],
          );
        }),
      ),
    );
  }
}