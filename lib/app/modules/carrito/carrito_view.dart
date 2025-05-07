// lib/app/modules/carrito/carrito_view.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/carrito_controller.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';
import '../../widgets/empty_state.dart';
import 'components/lista_items_component.dart';
import 'components/selector_cliente_component.dart';
import 'components/selector_envio_component.dart';
import 'components/resumen_component.dart';
import 'components/boton_cotizacion_component.dart';

class CarritoView extends GetView<CarritoController> {
  const CarritoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // No necesitamos navigation bar porque ya lo maneja HomeView
      child: SafeArea(
        child: Obx(() {
          // Mostrar loading si está cargando
          if (controller.cargando.value) {
            return const LoadingIndicator(message: 'Cargando carrito...');
          }
          
          // Mostrar error si existe
          if (controller.error.value.isNotEmpty) {
            return ErrorMessage(
              message: controller.error.value,
              onRetry: () => controller.onInit(),
            );
          }
          
          // Mostrar estado vacío si no hay items
          if (controller.items.isEmpty) {
            return EmptyState(
              title: 'Carrito Vacío',
              message: 'Agrega productos desde la calculadora',
              icon: CupertinoIcons.cart,
              buttonText: 'Ir a Calculadora',
              onButtonPressed: () => Get.find<HomeController>().changeIndex(2), // Ir a calculadora
            );
          }
          
          // Vista principal del carrito
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Lista de items en el carrito
                ListaItemsComponent(),
                
                const SizedBox(height: 20),
                
                // Selector de cliente
                SelectorClienteComponent(),
                
                const SizedBox(height: 20),
                
                // Selector de tipo de envío
                SelectorEnvioComponent(),
                
                const SizedBox(height: 20),
                
                // Campo para notas
                CupertinoTextField(
                  placeholder: 'Notas adicionales...',
                  padding: const EdgeInsets.all(12),
                  maxLines: 3,
                  onChanged: controller.setNotas,
                ),
                
                const SizedBox(height: 20),
                
                // Resumen de la venta
                ResumenComponent(),
                
                const SizedBox(height: 20),
                
                // Botones de acción
                Row(
                  children: [
                    // Botón Limpiar Carrito
                    Expanded(
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(12),
                        color: CupertinoColors.systemGrey5,
                        child: const Text(
                          'Limpiar Carrito',
                          style: TextStyle(color: CupertinoColors.black),
                        ),
                        onPressed: controller.limpiarCarrito,
                      ),
                    ),
                    
                    const SizedBox(width: 10),
                    
                    // Botón de Generar Cotización
                    Expanded(
                      child: BotonCotizacionComponent(),
                    ),
                  ],
                ),
                
                const SizedBox(height: 10),
                
                // Botón de Crear Venta Directa
                CupertinoButton(
                  padding: const EdgeInsets.all(12),
                  color: CupertinoColors.activeGreen,
                  child: const Text('Crear Venta Directa'),
                  onPressed: controller.crearVenta,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}