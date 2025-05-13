// lib/app/modules/registros/components/form_proveedor_component.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/registros_controller.dart';
import '../../../data/models/proveedor_model.dart';

class FormProveedorComponent extends StatefulWidget {
  final ProveedorModel? proveedor;

  const FormProveedorComponent({Key? key, this.proveedor}) : super(key: key);

  @override
  _FormProveedorComponentState createState() => _FormProveedorComponentState();
}

class _FormProveedorComponentState extends State<FormProveedorComponent> {
  // Controladores para los campos del formulario que se inicializan una vez
  late TextEditingController nombreController;
  late TextEditingController contactoController;
  late TextEditingController telefonoController;
  late TextEditingController emailController;
  late TextEditingController direccionController;

  // Lista de productos (estado local)
  late RxList<String> productos;

  // Controlador de registros
  late RegistrosController controller;

  @override
  void initState() {
    super.initState();
    // Inicializar controladores con valores del proveedor si existe
    nombreController = TextEditingController(
      text: widget.proveedor?.nombre ?? '',
    );
    contactoController = TextEditingController(
      text: widget.proveedor?.contacto ?? '',
    );
    telefonoController = TextEditingController(
      text: widget.proveedor?.telefono ?? '',
    );
    emailController = TextEditingController(
      text: widget.proveedor?.email ?? '',
    );
    direccionController = TextEditingController(
      text: widget.proveedor?.direccion ?? '',
    );

    // Inicializar lista de productos
    productos = RxList<String>.from(widget.proveedor?.productos ?? []);

    // Obtener el controlador
    controller = Get.find<RegistrosController>();
  }

  @override
  void dispose() {
    // Liberar recursos al desmontar el widget
    nombreController.dispose();
    contactoController.dispose();
    telefonoController.dispose();
    emailController.dispose();
    direccionController.dispose();
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
                widget.proveedor == null
                    ? 'Nuevo Proveedor'
                    : 'Editar Proveedor',
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
                      onPressed: () => _agregarProducto(context),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Lista de productos
                Obx(
                  () =>
                      productos.isEmpty
                          ? Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemGrey6,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'No hay productos registrados',
                                style: TextStyle(
                                  color: CupertinoColors.systemGrey,
                                ),
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
                              children:
                                  productos.map((producto) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: CupertinoColors.systemGrey5,
                                        ),
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
                                              setState(() {
                                                productos.remove(producto);
                                              });
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
              if (widget.proveedor != null) ...[
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
                    widget.proveedor == null ? 'Crear' : 'Actualizar',
                  ),
                  onPressed: () => _guardarProveedor(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Agregar producto al proveedor
  void _agregarProducto(BuildContext context) {
    final TextEditingController productoController = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
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
                    setState(() {
                      productos.add(productoController.text);
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
    );
  }

  // Guardar proveedor (crear nuevo o actualizar existente)
  void _guardarProveedor(BuildContext context) {
    // Validar campos
    if (nombreController.text.isEmpty ||
        contactoController.text.isEmpty ||
        telefonoController.text.isEmpty ||
        direccionController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Los campos Nombre, Contacto, Teléfono y Dirección son obligatorios',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Crear objeto de proveedor
    ProveedorModel nuevoProveedor;

    if (widget.proveedor == null) {
      // Crear nuevo proveedor
      nuevoProveedor = ProveedorModel(
        nombre: nombreController.text,
        contacto: contactoController.text,
        telefono: telefonoController.text,
        email: emailController.text,
        direccion: direccionController.text,
        productos: productos.toList(),
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
      nuevoProveedor = widget.proveedor!.copyWith(
        nombre: nombreController.text,
        contacto: contactoController.text,
        telefono: telefonoController.text,
        email: emailController.text,
        direccion: direccionController.text,
        productos: productos.toList(),
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
      builder:
          (context) => CupertinoAlertDialog(
            title: const Text('Confirmar Eliminación'),
            content: Text(
              '¿Está seguro que desea eliminar al proveedor "${widget.proveedor!.nombre}"?',
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

                  controller.eliminarProveedor(widget.proveedor!.id).then((
                    success,
                  ) {
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
