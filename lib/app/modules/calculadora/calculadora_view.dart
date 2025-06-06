// lib/app/modules/calculadora/calculadora_view.dart
// Agrega los componentes faltantes en la vista de la calculadora

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/calculadora_controller.dart';
import 'components/selector_material_component.dart';
import 'components/selector_tamano_component.dart';
import 'components/selector_diseno_component.dart';
import 'components/checkbox_desperdicio_component.dart';
import 'components/input_cantidad_component.dart';
import 'components/preview_calculo_component.dart';
// Agrega estas importaciones que faltaban
import 'components/selector_cliente_calculadora_component.dart';
import 'components/selector_proyecto_component.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';
import '../../widgets/custom_button.dart';
import '../../data/services/calculadora_service.dart';
import '../../data/services/carrito_service.dart';

class CalculadoraView extends GetView<CalculadoraController> {
  const CalculadoraView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inicialización de emergencia si el binding falla
    if (!Get.isRegistered<CalculadoraService>()) {
      Get.put(CalculadoraService(), permanent: true);
      Get.find<CalculadoraService>().init();
    }

    if (!Get.isRegistered<CarritoService>()) {
      Get.put(CarritoService(), permanent: true);
      Get.find<CarritoService>().init();
    }

    if (!Get.isRegistered<CalculadoraController>()) {
      Get.put(CalculadoraController());
    }

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Calculadora de Precios'),
      ),
      child: SafeArea(
        child: Obx(() {
          // Mostrar loading si está cargando
          if (controller.cargando.value) {
            return const LoadingIndicator(message: 'Cargando materiales...');
          }

          // Mostrar error si existe
          if (controller.error.value.isNotEmpty) {
            return ErrorMessage(
              message: controller.error.value,
              onRetry: () => controller.onInit(),
            );
          }

          // CustomScrollView con soporte para pull-to-refresh
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Control de actualización estilo iOS
              CupertinoSliverRefreshControl(
                onRefresh: () => controller.refrescarDatos(),
              ),

              // Contenido principal
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Añadir aquí los componentes que se perdieron
                      // Selector de cliente
                      const SelectorClienteCalculadoraComponent(),

                      const SizedBox(height: 20),

                      // Selector de proyecto
                      const SelectorProyectoComponent(),

                      const SizedBox(height: 20),

                      // Selectores de material
                      const SelectorMaterialComponent(),

                      const SizedBox(height: 20),

                      // Selector de tamaño
                      const SelectorTamanoComponent(),

                      const SizedBox(height: 20),

                      // Selector de diseño
                      const SelectorDisenoComponent(),

                      const SizedBox(height: 20),

                      // Opciones adicionales
                      Row(
                        children: [
                          // Checkbox desperdicio
                          const Expanded(child: CheckboxDesperdicioComponent()),

                          const SizedBox(width: 16),

                          // Input cantidad
                          const Expanded(child: InputCantidadComponent()),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Vista previa del cálculo
                      PreviewCalculoComponent(),

                      const SizedBox(height: 20),

                      // Botones de acción
                      Row(
                        children: [
                          // Botón Resetear
                          Expanded(
                            child: CustomButton(
                              text: 'Resetear',
                              isSecondary: true,
                              onPressed: controller.resetear,
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Botón Agregar al Carrito
                          Expanded(
                            child: CustomButton(
                              text: 'Agregar al Carrito',
                              onPressed: controller.agregarAlCarrito,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
