// lib/app/modules/registros/components/form_proveedor_component.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/registros_controller.dart';
import '../../../data/models/proveedor_model.dart';

class FormProveedorComponent extends GetView<RegistrosController> {
  final ProveedorModel? proveedor;
  
  const FormProveedorComponent({Key? key, this.proveedor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controladores para los campos del formulario
    final nombreController = TextEditingController(text: proveedor?.nombre ?? '');
    final contactoController = TextEditingController(text: proveedor?.contacto ?? '');
    final telefonoController = TextEditingController(text: proveedor?.telefono ?? '');
    final emailController = TextEditingController(text: proveedor?.email ?? '');
    final direccionController = TextEditingController(text: proveedor?.direccion ?? '');
    
    // Lista de productos (estado local)
    RxList<String> productos = RxList<String>.from(proveedor?.productos ?? []);
    
    return Column(
      children: [
        // Barra superior
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                proveedor == null ? 'Nuevo Proveedor' : 'Editar Proveedor',
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
                const Text('Nombre de la Empresa'),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: nombreController,
                  placeholder: 'Nombre de la empresa',
                  padding: const EdgeInsets.all(12),
                ),
                
                const SizedBox(height: 16),
                
                const Text('Persona de Contacto'),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: contactoController,
                  placeholder: 'Nombre completo',
                  padding: const EdgeInsets.all(12),
                ),
                
                const SizedBox(height: 16),
                
                const Text('Teléfono'),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: telefonoController,
                  placeholder: 'Número telefónico',
                  padding: const EdgeInsets.all(12),
                  keyboardType: TextInputType.phone,
                ),
                
                const SizedBox(height: 16),
                
                const Text('Email (opcional)'),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: emailController,
                  placeholder: 'Correo electrónico',
                  padding: const EdgeInsets.all(12),
                  keyboardType: TextInputType.emailAddress,
                ),
                
                const SizedBox(height: 16),
                
                const Text('Dirección'),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: direccionController,
                  placeholder: 'Dirección completa',
                  padding: const EdgeInsets.all(12),
                  maxLines: 2,
                ),
                
                const SizedBox(height: 24),
                
                // Sección de Productos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Productos Suministrados',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text('Agregar'),
                      onPressed: () => _agregarProducto(context, productos),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Lista de productos
                Obx(() => productos.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'No hay productos registrados',
                          style: TextStyle(color: CupertinoColors.systemGrey),
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: productos.map((producto) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: CupertinoColors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: CupertinoColors.systemGrey5),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.cube_box,
                                  size: 20,
                                  color: CupertinoColors.systemIndigo,
                                ),
                                const SizedBox(width: 12),
                                Expanded(child: Text(producto)),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: const Icon(
                                    CupertinoIcons.delete,
                                    size: 20,
                                    color: CupertinoColors.systemRed,
                                  ),
                                  onPressed: () {
                                    productos.remove(producto);
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
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
              if (proveedor != null) ...[
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
                  child: Text(proveedor == null ? 'Crear' : 'Actualizar'),
                  onPressed: () => _guardarProveedor(
                    context,
                    nombreController.text,
                    contactoController.text,
                    telefonoController.text,
                    emailController.text,
                    direccionController.text,
                    productos,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // Agregar producto al proveedor
  void _agregarProducto(BuildContext context, RxList<String> productos) {
    final TextEditingController productoController = TextEditingController();
    
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Agregar Producto'),
        content: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: CupertinoTextField(
            controller: productoController,
            placeholder: 'Nombre del producto',
            autofocus: true,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Agregar'),
            onPressed: () {
              if (productoController.text.isNotEmpty) {
                productos.add(productoController.text);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
  
  // Guardar proveedor (crear nuevo o actualizar existente)
  void _guardarProveedor(
    BuildContext context,
    String nombre,
    String contacto,
    String telefono,
    String email,
    String direccion,
    List<String> productos,
  ) {
    // Validar campos
    if (nombre.isEmpty || contacto.isEmpty || telefono.isEmpty || direccion.isEmpty) {
      Get.snackbar(
        'Error',
        'Los campos Nombre, Contacto, Teléfono y Dirección son obligatorios',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    // Crear objeto de proveedor
    ProveedorModel nuevoProveedor;
    
    if (proveedor == null) {
      // Crear nuevo proveedor
      nuevoProveedor = ProveedorModel(
        nombre: nombre,
        contacto: contacto,
        telefono: telefono,
        email: email,
        direccion: direccion,
        productos: productos,
      );
      
      controller.crearProveedor(nuevoProveedor).then((success) {
        if (success) {
          Navigator.pop(context);
          Get.snackbar(
            'Éxito',
            'Proveedor creado correctamente',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      });
    } else {
      // Actualizar proveedor existente
      nuevoProveedor = proveedor!.copyWith(
        nombre: nombre,
        contacto: contacto,
        telefono: telefono,
        email: email,
        direccion: direccion,
        productos: productos,
      );
      
      controller.actualizarProveedor(nuevoProveedor).then((success) {
        if (success) {
          Navigator.pop(context);
          Get.snackbar(
            'Éxito',
            'Proveedor actualizado correctamente',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      });
    }
  }
  
  // Confirmar eliminación de proveedor
  void _confirmarEliminar(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text('¿Está seguro que desea eliminar al proveedor "${proveedor!.nombre}"?'),
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
              
              controller.eliminarProveedor(proveedor!.id).then((success) {
                if (success) {
                  Navigator.pop(context); // Cerrar el formulario
                  Get.snackbar(
                    'Éxito',
                    'Proveedor eliminado correctamente',
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