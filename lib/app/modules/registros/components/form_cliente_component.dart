// lib/app/modules/registros/components/form_cliente_component.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/registros_controller.dart';
import '../../../data/models/cliente_model.dart';

class FormClienteComponent extends GetView<RegistrosController> {
  final ClienteModel? cliente;

  const FormClienteComponent({Key? key, this.cliente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controladores para los campos del formulario
    final nombreController = TextEditingController(text: cliente?.nombre ?? '');
    final direccionController = TextEditingController(
      text: cliente?.direccion ?? '',
    );
    final zonaController = TextEditingController(text: cliente?.zona ?? '');

    // Inicializar tipo de cliente (ahora incluye "NUEVO")
    String tipoCliente = cliente?.tipoCliente ?? 'NUEVO';

    return Column(
      children: [
        // Barra superior
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cliente == null ? 'Nuevo Cliente' : 'Editar Cliente',
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
                const Text('Nombre'),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: nombreController,
                  placeholder: 'Nombre completo',
                  padding: const EdgeInsets.all(12),
                ),

                const SizedBox(height: 16),

                const Text('Dirección'),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: direccionController,
                  placeholder: 'Dirección completa',
                  padding: const EdgeInsets.all(12),
                ),

                const SizedBox(height: 16),

                const Text('Zona'),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: zonaController,
                  placeholder: 'Zona (ej: Zona 10)',
                  padding: const EdgeInsets.all(12),
                ),

                const SizedBox(height: 16),

                const Text('Tipo de Cliente'),
                const SizedBox(height: 8),

                // Selector de tipo de cliente (ahora incluye "NUEVO")
                StatefulBuilder(
                  builder: (context, setState) {
                    return CupertinoSegmentedControl<String>(
                      children: const {
                        'NUEVO': Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('NUEVO'),
                        ),
                        'Regular': Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Regular'),
                        ),
                        'Frecuente': Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Frecuente'),
                        ),
                        'VIP': Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('VIP'),
                        ),
                      },
                      groupValue: tipoCliente,
                      onValueChanged: (value) {
                        setState(() => tipoCliente = value);
                      },
                    );
                  },
                ),

                // Información sobre actualización automática
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: CupertinoColors.systemGrey5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Información de Actualización Automática:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'El tipo de cliente se actualiza automáticamente según estas reglas:',
                        style: TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '• NUEVO: Cliente inicial',
                        style: TextStyle(fontSize: 13),
                      ),
                      const Text(
                        '• Regular: 3 o más compras',
                        style: TextStyle(fontSize: 13),
                      ),
                      const Text(
                        '• Frecuente: 18 o más compras',
                        style: TextStyle(fontSize: 13),
                      ),
                      const Text(
                        '• VIP: 100 o más compras',
                        style: TextStyle(fontSize: 13),
                      ),

                      if (cliente != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Compras realizadas: ${cliente!.comprasRealizadas}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          cliente!.tipoCliente == 'VIP'
                              ? '¡Este cliente ya ha alcanzado el nivel máximo!'
                              : 'Faltan ${cliente!.proximoNivel()['faltantes']} compras para nivel ${cliente!.proximoNivel()['nivel']}',
                          style: TextStyle(
                            fontSize: 13,
                            color:
                                cliente!.tipoCliente == 'VIP'
                                    ? CupertinoColors.activeGreen
                                    : CupertinoColors.systemBlue,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),

        // Botones de acción
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if (cliente != null) ...[
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
                  child: Text(cliente == null ? 'Crear' : 'Actualizar'),
                  onPressed:
                      () => _guardarCliente(
                        context,
                        nombreController.text,
                        direccionController.text,
                        zonaController.text,
                        tipoCliente,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Guardar cliente (crear nuevo o actualizar existente)
  void _guardarCliente(
    BuildContext context,
    String nombre,
    String direccion,
    String zona,
    String tipoCliente,
  ) {
    // Validar campos
    if (nombre.isEmpty || direccion.isEmpty || zona.isEmpty) {
      Get.snackbar(
        'Error',
        'Todos los campos son obligatorios',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Crear objeto de cliente
    ClienteModel nuevoCliente;

    if (cliente == null) {
      // Crear nuevo cliente
      nuevoCliente = ClienteModel(
        nombre: nombre,
        direccion: direccion,
        zona: zona,
        tipoCliente: tipoCliente,
        comprasRealizadas: 0, // Nuevo cliente inicia con 0 compras
      );

      controller.crearCliente(nuevoCliente).then((success) {
        if (success) {
          Navigator.pop(context);
          Get.snackbar(
            'Éxito',
            'Cliente creado correctamente',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      });
    } else {
      // Actualizar cliente existente - mantener contador de compras
      nuevoCliente = cliente!.copyWith(
        nombre: nombre,
        direccion: direccion,
        zona: zona,
        tipoCliente: tipoCliente,
        // Mantener comprasRealizadas del cliente original
      );

      controller.actualizarCliente(nuevoCliente).then((success) {
        if (success) {
          Navigator.pop(context);
          Get.snackbar(
            'Éxito',
            'Cliente actualizado correctamente',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      });
    }
  }

  // Confirmar eliminación de cliente
  void _confirmarEliminar(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: const Text('Confirmar Eliminación'),
            content: Text(
              '¿Está seguro que desea eliminar al cliente "${cliente!.nombre}"?',
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
                  Navigator.pop(context); // Cerrar el diálogo

                  controller.eliminarCliente(cliente!.id).then((success) {
                    if (success) {
                      Navigator.pop(context); // Cerrar el formulario
                      Get.snackbar(
                        'Éxito',
                        'Cliente eliminado correctamente',
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
