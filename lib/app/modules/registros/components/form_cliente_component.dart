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
    final direccionController = TextEditingController(text: cliente?.direccion ?? '');
    final zonaController = TextEditingController(text: cliente?.zona ?? '');
    final tipoClienteController = TextEditingController(text: cliente?.tipoCliente ?? 'Regular');
    
    // Tipo de cliente seleccionado (estado local)
    String tipoCliente = cliente?.tipoCliente ?? 'Regular';
    
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
                
                // Selector de tipo de cliente usando StatefulBuilder para manejar el estado local
                StatefulBuilder(
                  builder: (context, setState) {
                    return CupertinoSegmentedControl<String>(
                      children: const {
                        'Regular': Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Regular'),
                        ),
                        'Frecuente': Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Frecuente'),
                        ),
                        'VIP': Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('VIP'),
                        ),
                      },
                      groupValue: tipoCliente,
                      onValueChanged: (value) {
                        setState(() => tipoCliente = value);
                        tipoClienteController.text = value;
                      },
                    );
                  }
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
                  onPressed: () => _guardarCliente(
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
      // Actualizar cliente existente
      nuevoCliente = cliente!.copyWith(
        nombre: nombre,
        direccion: direccion,
        zona: zona,
        tipoCliente: tipoCliente,
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
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text('¿Está seguro que desea eliminar al cliente "${cliente!.nombre}"?'),
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
                }
              });
            },
          ),
        ],
      ),
    );
  }
}