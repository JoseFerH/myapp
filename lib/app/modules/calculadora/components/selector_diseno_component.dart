import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/calculadora_controller.dart';
import '../../../data/models/item_venta_model.dart';
import '../../../data/services/calculadora_service.dart';

class SelectorDisenoComponent extends GetView<CalculadoraController> {
  const SelectorDisenoComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Acceder al servicio para obtener valores de referencia
    final calculadoraService = Get.find<CalculadoraService>();

    return Container(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tipo de Diseño',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Selector de tipo de diseño
            Obx(
              () => CupertinoSegmentedControl<TipoDiseno>(
                children: const {
                  TipoDiseno.estandar: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("Estándar"),
                  ),
                  TipoDiseno.personalizado: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("Personalizado"),
                  ),
                },
                groupValue: controller.tipoDiseno.value,
                onValueChanged: (value) {
                  controller.seleccionarTipoDiseno(value);
                },
              ),
            ),

            const SizedBox(height: 16),

            // Mostrar campo de precio si es personalizado
            Obx(() {
              // Crear un controlador de texto con el valor actual
              final TextEditingController textController =
                  TextEditingController(
                    text: controller.precioDiseno.value.toString(),
                  );

              // Posicionar el cursor al final del texto
              textController.selection = TextSelection.fromPosition(
                TextPosition(offset: textController.text.length),
              );

              if (controller.tipoDiseno.value == TipoDiseno.personalizado) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Precio del diseño personalizado:',
                      style: TextStyle(fontSize: 14),
                    ),

                    const SizedBox(height: 8),

                    CupertinoTextField(
                      controller: textController,
                      placeholder: 'Ingrese precio del diseño',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('Q'),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          try {
                            double precio = double.parse(value);
                            controller.cambiarPrecioDiseno(precio);
                          } catch (e) {
                            // Si no es un número válido, restaurar al valor anterior
                            // pero no mostramos mensaje de error para no molestar al usuario
                          }
                        } else {
                          // Si está vacío, usar el valor predeterminado
                          controller.cambiarPrecioDiseno(
                            calculadoraService
                                .configuracion
                                .precioDisenioPersonalizado,
                          );
                        }
                      },
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}
