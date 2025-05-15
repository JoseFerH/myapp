// lib/app/modules/calculadora/components/selector_proyecto_component.dart
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/calculadora_controller.dart';
import '../../../data/models/proyecto_model.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../data/models/proyecto_model.dart';

class SelectorProyectoComponent extends GetView<CalculadoraController> {
  const SelectorProyectoComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalculadoraController>(
      builder:
          (controller) => Container(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tipo de Proyecto',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  // Selector de proyecto
                  Obx(
                    () => CustomDropdown<ProyectoModel>(
                      title: 'Proyecto',
                      items: controller.proyectos,
                      selectedItem: controller.proyectoSeleccionado.value,
                      itemBuilder: (proyecto) => Text(proyecto.nombre),
                      onChanged: (proyecto) {
                        if (proyecto != null) {
                          controller.seleccionarProyecto(proyecto);
                        }
                      },
                      hint: 'Seleccione tipo de proyecto',
                    ),
                  ),

                  // Mostrar descripción del proyecto seleccionado
                  Obx(() {
                    if (controller.proyectoSeleccionado.value != null &&
                        controller
                            .proyectoSeleccionado
                            .value!
                            .descripcion
                            .isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          controller.proyectoSeleccionado.value!.descripcion,
                          style: TextStyle(
                            color: CupertinoColors.systemGrey,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
    );
  }
}
