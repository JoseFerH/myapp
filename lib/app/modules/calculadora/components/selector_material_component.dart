import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/calculadora_controller.dart';
import '../../../widgets/custom_dropdown.dart';

class SelectorMaterialComponent extends GetView<CalculadoraController> {
  const SelectorMaterialComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selección de Material',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Selector de Hoja
            Obx(() => CustomDropdown(
              title: 'Hoja',
              items: controller.hojas,
              selectedItem: controller.hojaSeleccionada.value,
              itemBuilder: (hoja) => Text(hoja.nombre),
              onChanged: (hoja) {
                if (hoja != null) {
                  controller.seleccionarHoja(hoja);
                }
              },
              hint: 'Seleccione tipo de hoja',
            )),
            
            const SizedBox(height: 12),
            
            // Selector de Laminado
            Obx(() => CustomDropdown(
              title: 'Laminado',
              items: controller.laminados,
              selectedItem: controller.laminadoSeleccionada.value,
              itemBuilder: (laminado) => Text(laminado.nombre),
              onChanged: (laminado) {
                if (laminado != null) {
                  controller.seleccionarLaminado(laminado);
                }
              },
              hint: 'Seleccione tipo de laminado',
            )),
          ],
        ),
      ),
    );
  }
}