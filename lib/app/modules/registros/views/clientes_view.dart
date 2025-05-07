import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/registros_controller.dart';
import '../../../data/models/cliente_model.dart';
import '../../../widgets/empty_state.dart';
import '../components/form_cliente_component.dart';

class ClientesView extends GetView<RegistrosController> {
  const ClientesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Lista de clientes
        Obx(() {
          final clientes = controller.clientesFiltrados;
          
          if (clientes.isEmpty) {
            return EmptyState(
              title: 'No hay clientes',
              message: 'Agrega tu primer cliente para comenzar',
              icon: CupertinoIcons.person_add,
              buttonText: 'Agregar Cliente',
              onButtonPressed: () => _mostrarFormularioCliente(context),
            );
          }
          
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 80), // Espacio para el botón flotante
            itemCount: clientes.length,
            separatorBuilder: (context, index) => Container(height: 1),
            itemBuilder: (context, index) {
              final cliente = clientes[index];
              return _buildClienteItem(context, cliente);
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
            onPressed: () => _mostrarFormularioCliente(context),
          ),
        ),
      ],
    );
  }
  
  // Construir item de cliente
  Widget _buildClienteItem(BuildContext context, ClienteModel cliente) {
    return GestureDetector(
      onTap: () => _mostrarDetalleCliente(context, cliente),
      child: Container(
        padding: const EdgeInsets.all(16),
        color: CupertinoColors.white,
        child: Row(
          children: [
            // Icono según tipo de cliente
            Icon(
              _getIconoPorTipo(cliente.tipoCliente),
              color: _getColorPorTipo(cliente.tipoCliente),
              size: 40,
            ),
            
            const SizedBox(width: 16),
            
            // Información principal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cliente.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cliente.direccion,
                    style: const TextStyle(
                      color: CupertinoColors.systemGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getColorPorTipo(cliente.tipoCliente).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          cliente.tipoCliente,
                          style: TextStyle(
                            color: _getColorPorTipo(cliente.tipoCliente),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Zona ${cliente.zona}',
                          style: const TextStyle(
                            color: CupertinoColors.systemGrey,
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
  
  // Obtener icono según tipo de cliente
  IconData _getIconoPorTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'vip':
        return CupertinoIcons.star_fill;
      case 'frecuente':
        return CupertinoIcons.person_2_fill;
      case 'regular':
      default:
        return CupertinoIcons.person_fill;
    }
  }
  
  // Obtener color según tipo de cliente
  Color _getColorPorTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'vip':
        return CupertinoColors.systemYellow;
      case 'frecuente':
        return CupertinoColors.activeBlue;
      case 'regular':
      default:
        return CupertinoColors.systemGrey;
    }
  }
  
  // Mostrar formulario de cliente
  void _mostrarFormularioCliente(BuildContext context) {
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
        child: const FormClienteComponent(),
      ),
    );
  }
  
  // Mostrar detalle de cliente
  void _mostrarDetalleCliente(BuildContext context, ClienteModel cliente) {
    controller.clienteSeleccionado.value = cliente;
    
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
                    'Detalle del Cliente',
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
                    // Información del cliente
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
                          _buildInfoRow('Nombre:', cliente.nombre),
                          const SizedBox(height: 8),
                          _buildInfoRow('Dirección:', cliente.direccion),
                          const SizedBox(height: 8),
                          _buildInfoRow('Zona:', cliente.zona),
                          const SizedBox(height: 8),
                          _buildInfoRow('Tipo:', cliente.tipoCliente),
                          const SizedBox(height: 8),
                          _buildInfoRow('Total Gastado:', 'Q${cliente.totalGastado.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Historial de ventas
                    // Esta parte se conectaría con el servicio de ventas para mostrar
                    // el historial de compras del cliente
                    const Text(
                      'Historial de Compras',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Aquí se cargaría el historial de ventas
                    // pero por ahora mostraremos un placeholder
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: CupertinoColors.systemGrey5),
                      ),
                      child: const Center(
                        child: Text(
                          'El historial de compras se cargará aquí',
                          style: TextStyle(color: CupertinoColors.systemGrey),
                        ),
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
                        _mostrarFormularioCliente(context);
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
                      onPressed: () => _confirmarEliminarCliente(context, cliente),
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
  
  // Confirmar eliminación de cliente
  void _confirmarEliminarCliente(BuildContext context, ClienteModel cliente) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text('¿Está seguro que desea eliminar al cliente "${cliente.nombre}"?'),
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
              controller.eliminarCliente(cliente.id).then((success) {
                if (success) {
                  Navigator.pop(context); // Cerrar el modal de detalle
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