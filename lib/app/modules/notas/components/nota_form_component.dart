// lib/app/modules/notas/components/nota_form_component.dart
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/notas_controller.dart';
import '../../../data/models/nota_model.dart';
import 'selector_icono_component.dart';
import 'selector_color_component.dart';

class NotaFormComponent extends GetView<NotasController> {
  final NotaModel? nota;

  const NotaFormComponent({Key? key, this.nota}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controladores para los campos
    final tituloController = TextEditingController(text: nota?.titulo ?? '');
    final contenidoController = TextEditingController(
      text: nota?.contenido ?? '',
    );
    final categoriaController = TextEditingController(
      text: nota?.categoria ?? 'General',
    );

    // Variables reactivas locales
    final iconoSeleccionado = RxString(nota?.icono ?? 'doc_text');
    final colorSeleccionado = Rx<Color>(nota?.color ?? const Color(0xFF9E9E9E));

    return Column(
      children: [
        // Barra superior
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nota == null ? 'Nueva Nota' : 'Editar Nota',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('Cerrar'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),

        // Contenido del formulario
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                const Text('Título'),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: tituloController,
                  placeholder: 'Título de la nota',
                  padding: const EdgeInsets.all(12),
                ),

                const SizedBox(height: 16),

                // Contenido
                const Text('Contenido'),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: contenidoController,
                  placeholder: 'Escribe tu nota aquí...',
                  padding: const EdgeInsets.all(12),
                  maxLines: 8,
                ),

                const SizedBox(height: 16),

                // Categoría
                const Text('Categoría'),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: categoriaController,
                  placeholder: 'Categoría (ej: General, Clientes, etc.)',
                  padding: const EdgeInsets.all(12),
                ),

                const SizedBox(height: 16),

                // Selector de icono
                const Text('Icono'),
                const SizedBox(height: 8),
                SelectorIconoComponent(iconoSeleccionado: iconoSeleccionado),

                const SizedBox(height: 16),

                // Selector de color
                const Text('Color'),
                const SizedBox(height: 8),
                SelectorColorComponent(colorSeleccionado: colorSeleccionado),
              ],
            ),
          ),
        ),

        // Botones de acción
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if (nota != null) ...[
                // Botón Eliminar (solo en modo edición)
                Expanded(
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(12),
                    color: CupertinoColors.systemRed,
                    child: const Text('Eliminar'),
                    onPressed: () => _confirmarEliminar(context),
                  ),
                ),

                const SizedBox(width: 16),
              ],

              // Botón Guardar
              Expanded(
                child: CupertinoButton(
                  padding: const EdgeInsets.all(12),
                  color: CupertinoColors.activeBlue,
                  child: Text(nota == null ? 'Crear' : 'Actualizar'),
                  onPressed:
                      () => _guardarNota(
                        context,
                        tituloController.text,
                        contenidoController.text,
                        categoriaController.text,
                        iconoSeleccionado.value,
                        colorSeleccionado.value,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Guardar nota
  void _guardarNota(
    BuildContext context,
    String titulo,
    String contenido,
    String categoria,
    String icono,
    Color color,
  ) {
    // Validar datos
    if (titulo.isEmpty || contenido.isEmpty) {
      Get.snackbar(
        'Error',
        'Título y contenido son obligatorios',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Fecha actual
    final ahora = DateTime.now();

    if (nota == null) {
      // Crear nueva nota
      final nuevaNota = NotaModel(
        titulo: titulo,
        contenido: contenido,
        icono: icono,
        categoria: categoria,
        color: color,
        fechaCreacion: ahora,
        fechaModificacion: ahora,
      );

      controller.crearNota(nuevaNota).then((success) {
        if (success) {
          Navigator.pop(context);
          Get.snackbar(
            'Éxito',
            'Nota creada correctamente',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      });
    } else {
      // Actualizar nota existente
      final notaActualizada = NotaModel(
        id: nota!.id,
        titulo: titulo,
        contenido: contenido,
        icono: icono,
        categoria: categoria,
        color: color,
        fechaCreacion: nota!.fechaCreacion,
        fechaModificacion: ahora,
      );

      controller.actualizarNota(notaActualizada).then((success) {
        if (success) {
          Navigator.pop(context);
          Get.snackbar(
            'Éxito',
            'Nota actualizada correctamente',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      });
    }
  }

  // Confirmar eliminación
  void _confirmarEliminar(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: const Text('Confirmar Eliminación'),
            content: Text(
              '¿Está seguro que desea eliminar la nota "${nota!.titulo}"?',
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

                  controller.eliminarNota(nota!.id).then((success) {
                    if (success) {
                      Navigator.pop(context);
                      Get.snackbar(
                        'Éxito',
                        'Nota eliminada correctamente',
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
