// lib/app/modules/notas/components/nota_form_component.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../controllers/notas_controller.dart';
import '../../../data/models/nota_model.dart';
import 'selector_icono_component.dart';
import 'selector_color_component.dart';

class NotaFormComponent extends StatefulWidget {
  final NotaModel? nota;

  const NotaFormComponent({Key? key, this.nota}) : super(key: key);

  @override
  _NotaFormComponentState createState() => _NotaFormComponentState();
}

class _NotaFormComponentState extends State<NotaFormComponent> {
  // Controladores para los campos
  late TextEditingController tituloController;
  late TextEditingController contenidoController;
  late TextEditingController categoriaController;

  // Variables reactivas locales
  final iconoSeleccionado = RxString('');
  final colorSeleccionado = Rx<Color>(const Color(0xFF9E9E9E));

  // Controlador
  late NotasController controller;

  @override
  void initState() {
    super.initState();

    // Obtener el controlador
    controller = Get.find<NotasController>();

    // Inicializar controladores
    tituloController = TextEditingController(text: widget.nota?.titulo ?? '');
    contenidoController = TextEditingController(
      text: widget.nota?.contenido ?? '',
    );
    categoriaController = TextEditingController(
      text: widget.nota?.categoria ?? 'General',
    );

    // Inicializar variables reactivas
    iconoSeleccionado.value = widget.nota?.icono ?? 'doc_text';
    colorSeleccionado.value = widget.nota?.color ?? const Color(0xFF9E9E9E);
  }

  @override
  void dispose() {
    // Liberar recursos
    tituloController.dispose();
    contenidoController.dispose();
    categoriaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra superior
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.nota == null ? 'Nueva Nota' : 'Editar Nota',
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
              if (widget.nota != null) ...[
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
                  child: Text(
                    widget.nota == null ? 'Crear' : 'Actualizar',
                    style: const TextStyle(
                      color: CupertinoColors.white,
                    ), // Aquí defines el color del texto
                  ),
                  onPressed: () => _guardarNota(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Guardar nota
  void _guardarNota(BuildContext context) {
    // Obtener valores de los controladores
    final titulo = tituloController.text;
    final contenido = contenidoController.text;
    final categoria = categoriaController.text;
    final icono = iconoSeleccionado.value;
    final color = colorSeleccionado.value;

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

    if (widget.nota == null) {
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
        id: widget.nota!.id,
        titulo: titulo,
        contenido: contenido,
        icono: icono,
        categoria: categoria,
        color: color,
        fechaCreacion: widget.nota!.fechaCreacion,
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
          (dialogContext) => CupertinoAlertDialog(
            title: const Text('Confirmar Eliminación'),
            content: Text(
              '¿Está seguro que desea eliminar la nota "${widget.nota!.titulo}"?',
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(dialogContext),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Eliminar'),
                onPressed: () {
                  // Cerrar diálogo de confirmación
                  Navigator.pop(dialogContext);

                  controller.eliminarNota(widget.nota!.id).then((success) {
                    if (success) {
                      // Cerrar formulario
                      Navigator.pop(context);
                      Get.snackbar(
                        'Éxito',
                        'Nota eliminada correctamente',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        'No se pudo eliminar la nota',
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
