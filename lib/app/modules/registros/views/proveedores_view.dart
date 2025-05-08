// lib/app/modules/registros/views/proveedores_view.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/registros_controller.dart';
import '../../../data/models/proveedor_model.dart';
import '../../../widgets/empty_state.dart';
import '../components/form_proveedor_component.dart';

class ProveedoresView extends GetView<RegistrosController> {
  const ProveedoresView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Lista de proveedores
        Obx(() {
          final proveedores = controller.proveedoresFiltrados;
          
          if (proveedores.isEmpty) {
            return EmptyState(
              title: 'No hay proveedores',
              message: 'Agrega tu primer proveedor para comenzar',
              icon: CupertinoIcons.building_2_fill,
              buttonText: 'Agregar Proveedor',
              onButtonPressed: () => _mostrarFormularioProveedor(context),
            );
          }
          
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 80), // Espacio para el botón flotante
            itemCount: proveedores.length,
            separatorBuilder: (context, index) => Container(height: 1),
            itemBuilder: (context, index) {
              final proveedor = proveedores[index];
              return _buildProveedorItem(context, proveedor);
            },
          );
        }),
        
        // Botón flotante para agregar
        Positioned(
          right: 16,
          bottom: 16,
          child: CupertinoButton(
            padding: const EdgeInsets.all(16),
            color: CupertinoColors.activeBlue,
            child: const Icon(CupertinoIcons.add),
            onPressed: () => _mostrarFormularioProveedor(context),
          ),
        ),
      ],
    );
  }
  
  // Construir item de proveedor
  Widget _buildProveedorItem(BuildContext context, ProveedorModel proveedor) {
    return GestureDetector(
      onTap: () => _mostrarDetalleProveedor(context, proveedor),
      child: Container(
        padding: const EdgeInsets.all(16),
        color: CupertinoColors.white,
        child: Row(
          children: [
            // Icono de proveedor
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: CupertinoColors.systemIndigo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                CupertinoIcons.building_2_fill,
                color: CupertinoColors.systemIndigo,
                size: 25,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Información principal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    proveedor.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Contacto: ${proveedor.contacto}',
                    style: const TextStyle(
                      color: CupertinoColors.systemGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.phone,
                        size: 14,
                        color: CupertinoColors.systemGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        proveedor.telefono,
                        style: const TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Mostrar cantidad de productos
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey5,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${proveedor.productos.length} productos',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Flecha de navegación
            const Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ),
      ),
    );
  }
  
  // Mostrar formulario de proveedor
  void _mostrarFormularioProveedor(BuildContext context, [ProveedorModel? proveedor]) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: FormProveedorComponent(proveedor: proveedor),
      ),
    );
  }
  
  // Mostrar detalle de proveedor
  void _mostrarDetalleProveedor(BuildContext context, ProveedorModel proveedor) {
    controller.proveedorSeleccionado.value = proveedor;
    
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Barra superior
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Detalle del Proveedor',
                    style: TextStyle(
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
            
            // Contenido
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información del proveedor
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: CupertinoColors.systemGrey5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Nombre:', proveedor.nombre),
                          const SizedBox(height: 8),
                          _buildInfoRow('Contacto:', proveedor.contacto),
                          const SizedBox(height: 8),
                          _buildInfoRow('Teléfono:', proveedor.telefono),
                          const SizedBox(height: 8),
                          _buildInfoRow('Email:', proveedor.email.isEmpty ? 'No disponible' : proveedor.email),
                          const SizedBox(height: 8),
                          _buildInfoRow('Dirección:', proveedor.direccion),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Lista de productos
                    const Text(
                      'Productos Suministrados',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    if (proveedor.productos.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: CupertinoColors.systemGrey5),
                        ),
                        child: const Center(
                          child: Text(
                            'No hay productos registrados',
                            style: TextStyle(color: CupertinoColors.systemGrey),
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: CupertinoColors.systemGrey5),
                        ),
                        child: Column(
                          children: proveedor.productos.map((producto) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.cube_box,
                                    size: 16,
                                    color: CupertinoColors.systemIndigo,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(producto),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            // Botones de acción
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Botón Editar
                  Expanded(
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(12),
                      color: CupertinoColors.activeBlue,
                      child: const Text('Editar'),
                      onPressed: () {
                        Navigator.pop(context);
                        _mostrarFormularioProveedor(context, proveedor);
                      },
                    ),
                  ),
                  
                  const SizedBox(width: 10),
                  
                  // Botón Eliminar
                  Expanded(
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(12),
                      color: CupertinoColors.systemRed,
                      child: const Text('Eliminar'),
                      onPressed: () => _confirmarEliminarProveedor(context, proveedor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Construir fila de información
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }
  
  // Confirmar eliminación de proveedor
  void _confirmarEliminarProveedor(BuildContext context, ProveedorModel proveedor) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text('¿Está seguro que desea eliminar al proveedor "${proveedor.nombre}"?'),
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
              
              controller.eliminarProveedor(proveedor.id).then((success) {
                if (success) {
                  Navigator.pop(context); // Cerrar el modal de detalle
                  Get.snackbar(
                    'Éxito',
                    'Proveedor eliminado correctamente',
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