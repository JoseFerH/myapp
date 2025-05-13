import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/visualizacion_controller.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';
import '../../widgets/empty_state.dart';
import '../../data/services/venta_service.dart';
import '../../data/services/cliente_service.dart';
import '../../data/services/exportacion_service.dart';
import '../../data/services/pdf_service.dart';
import 'components/tabla_datos_component.dart';
import 'components/filtros_component.dart';
import 'components/detalle_component.dart';
import 'components/exportar_component.dart';

class VisualizacionView extends StatelessWidget {
  const VisualizacionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inicializar servicios y controlador directamente en la vista
    if (!Get.isRegistered<VentaService>()) {
      Get.put(VentaService(), permanent: true).init();
    }
    
    if (!Get.isRegistered<ClienteService>()) {
      Get.put(ClienteService(), permanent: true).init();
    }
    
    if (!Get.isRegistered<ExportacionService>()) {
      Get.put(ExportacionService(), permanent: true);
    }
    
    if (!Get.isRegistered<PDFService>()) {
      Get.put(PDFService(), permanent: true);
    }
    
    // Inicializar el controlador si no está registrado
    if (!Get.isRegistered<VisualizacionController>()) {
      Get.put(VisualizacionController(), permanent: true);
    }
    
    // Ahora podemos acceder al controlador de forma segura
    final controller = Get.find<VisualizacionController>();
    
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Obx(() {
          // Mostrar loading si está cargando
          if (controller.cargando.value) {
            return const LoadingIndicator(message: 'Cargando datos...');
          }
          
          // Mostrar error si existe
          if (controller.error.value.isNotEmpty) {
            return ErrorMessage(
              message: controller.error.value,
              onRetry: () => controller.cargarVentas(),
            );
          }
          
          return Column(
            children: [
              // Filtros
              const FiltrosComponent(),
              
              // Contenido principal (tabla o estado vacío)
              Expanded(
                child: Obx(() {
                  // Mostrar tabla si hay ventas, estado vacío en caso contrario
                  if (controller.ventas.isEmpty) {
                    return EmptyState(
                      title: 'No hay ventas',
                      message: 'No se encontraron ventas con los filtros aplicados',
                      icon: CupertinoIcons.doc_text,
                      buttonText: 'Limpiar Filtros',
                      onButtonPressed: controller.limpiarFiltros,
                    );
                  }
                  
                  return TablaDatosComponent();
                }),
              ),
              
              // Botones de acción
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Botón de exportar
                    Expanded(
                      child: ExportarComponent(),
                    ),
                    
                    const SizedBox(width: 10),
                    
                    // Botón de detalle (solo disponible cuando hay una venta seleccionada)
                    Expanded(
                      child: Obx(() => CupertinoButton(
                        padding: const EdgeInsets.all(12),
                        color: CupertinoColors.activeBlue,
                        disabledColor: CupertinoColors.systemGrey4,
                        onPressed: controller.ventaSeleccionada.value != null
                            ? () => _mostrarDetalle(context)
                            : null,
                        child: const Text('Ver Detalle'),
                      )),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
  
  // Mostrar detalle de venta
  void _mostrarDetalle(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: const DetalleComponent(),
      ),
    );
  }
}