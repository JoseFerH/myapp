// lib/app/modules/configuracion/components/proyectos_component.dart
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/configuracion_controller.dart';
import '../../../data/models/proyecto_model.dart';

class ProyectosComponent extends GetView<ConfiguracionController> {
  const ProyectosComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        const Text(
          'Tipos de Proyecto',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        const Text(
          'Define los tipos de proyecto que podrás asignar a los stickers.',
          style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 14),
        ),

        const SizedBox(height: 20),

        // Lista de proyectos
        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.proyectos.length,
            itemBuilder: (context, index) {
              final proyecto = controller.proyectos[index];
              return _buildProyectoItem(context, proyecto);
            },
          ),
        ),

        const SizedBox(height: 20),

        // Botón para agregar nuevo proyecto
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(CupertinoIcons.add_circled),
              SizedBox(width: 8),
              Text('Agregar Tipo de Proyecto'),
            ],
          ),
          onPressed: () => _mostrarFormularioProyecto(context),
        ),
      ],
    );
  }

  // Construir item de proyecto en la lista
  Widget _buildProyectoItem(BuildContext context, ProyectoModel proyecto) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CupertinoColors.systemGrey5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Switch para activar/desactivar
            CupertinoSwitch(
              value: proyecto.activo,
              onChanged: (value) {
                controller.toggleProyecto(proyecto.id, value);
              },
            ),

            const SizedBox(width: 12),

            // Información del proyecto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    proyecto.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (proyecto.descripcion.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      proyecto.descripcion,
                      style: const TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Botones de editar y eliminar
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.pencil, size: 20),
              onPressed: () => _mostrarFormularioProyecto(context, proyecto),
            ),

            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(
                CupertinoIcons.delete,
                size: 20,
                color: CupertinoColors.systemRed,
              ),
              onPressed: () => _confirmarEliminarProyecto(context, proyecto),
            ),
          ],
        ),
      ),
    );
  }

  // Mostrar formulario para agregar o editar proyecto
  void _mostrarFormularioProyecto(
    BuildContext context, [
    ProyectoModel? proyecto,
  ]) {
    // Controladores para los campos
    final nombreController = TextEditingController(
      text: proyecto?.nombre ?? '',
    );
    final descripcionController = TextEditingController(
      text: proyecto?.descripcion ?? '',
    );

    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título del modal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      proyecto == null
                          ? 'Nuevo Tipo de Proyecto'
                          : 'Editar Tipo de Proyecto',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text('Cancelar'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Formulario
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Nombre:'),
                        const SizedBox(height: 8),
                        CupertinoTextField(
                          controller: nombreController,
                          placeholder: 'Nombre del tipo de proyecto',
                          padding: const EdgeInsets.all(12),
                        ),

                        const SizedBox(height: 16),

                        const Text('Descripción (opcional):'),
                        const SizedBox(height: 8),
                        CupertinoTextField(
                          controller: descripcionController,
                          placeholder: 'Breve descripción del tipo de proyecto',
                          padding: const EdgeInsets.all(12),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),

                // Botón guardar
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    child: Text(
                      proyecto == null
                          ? 'Crear Tipo de Proyecto'
                          : 'Actualizar Tipo de Proyecto',
                    ),
                    onPressed: () {
                      // Validar campos
                      if (nombreController.text.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'El nombre es obligatorio',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      // Crear objeto de proyecto
                      final nuevoProyecto = ProyectoModel(
                        id: proyecto?.id ?? '',
                        nombre: nombreController.text,
                        descripcion: descripcionController.text,
                        activo: proyecto?.activo ?? true,
                      );

                      // Guardar cambios
                      controller.guardarProyecto(nuevoProyecto).then((success) {
                        if (success) {
                          Navigator.pop(context);
                          Get.snackbar(
                            'Éxito',
                            proyecto == null
                                ? 'Tipo de proyecto creado correctamente'
                                : 'Tipo de proyecto actualizado correctamente',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // Confirmar eliminación de proyecto
  void _confirmarEliminarProyecto(
    BuildContext context,
    ProyectoModel proyecto,
  ) {
    showCupertinoDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: const Text('Confirmar Eliminación'),
            content: Text(
              '¿Está seguro que desea eliminar el tipo de proyecto "${proyecto.nombre}"?',
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Eliminar'),
                onPressed: () {
                  Navigator.pop(context);
                  controller.eliminarProyecto(proyecto.id).then((success) {
                    if (success) {
                      Get.snackbar(
                        'Éxito',
                        'Tipo de proyecto eliminado correctamente',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        controller.error.value,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  });
                },
              ),
            ],
          ),
    );
  }
}
