import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/calculadora_controller.dart';
import 'components/selector_material_component.dart';
import 'components/selector_tamano_component.dart';
import 'components/selector_diseno_component.dart';
import 'components/checkbox_desperdicio_component.dart';
import 'components/input_cantidad_component.dart';
import 'components/preview_calculo_component.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';
import '../../widgets/custom_button.dart';

class CalculadoraView extends GetView<CalculadoraController> {
  const CalculadoraView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                    const Expanded(
                      child: CheckboxDesperdicioComponent(),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Input cantidad
                    const Expanded(
                      child: InputCantidadComponent(),
                    ),
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
          );
        }),
      ),
    );
  }
}