// lib/app/modules/visualizacion/components/detalle_component.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/visualizacion_controller.dart';
import '../../../data/models/venta_model.dart';
import '../../../data/models/item_venta_model.dart';

class DetalleComponent extends GetView<VisualizacionController> {
  const DetalleComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Formato para fecha y moneda
    final formatoFecha = DateFormat('dd/MM/yyyy');
    final formatoMoneda = NumberFormat.currency(
      locale: 'es_GT',
      symbol: 'Q',
      decimalDigits: 2,
    );

    return Column(
      children: [
        // Barra superior
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Detalle de Venta',
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
        
        // Contenido detallado
        Expanded(
          child: Obx(() {
            if (controller.ventaSeleccionada.value == null) {
              return const Center(
                child: Text('No hay venta seleccionada'),
              );
            }
            
            final venta = controller.ventaSeleccionada.value!;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información principal
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
                        // ID y fecha
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ID: ${venta.id}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Fecha: ${formatoFecha.format(venta.fecha)}',
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Cliente y estado
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Cliente:'),
                                  Text(
                                    venta.nombreCliente,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Estado con color según tipo
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getColorPorEstado(venta.estado).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                _getTextoEstado(venta.estado),
                                style: TextStyle(
                                  color: _getColorPorEstado(venta.estado),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Notas
                        if (venta.notas.isNotEmpty) ...[
                          const Text('Notas:'),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemGrey6,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(venta.notas),
                          ),
                          const SizedBox(height: 16),
                        ],
                        
                        // Tipo de envío
                        Row(
                          children: [
                            const Text('Tipo de Envío:'),
                            const SizedBox(width: 8),
                            Text(
                              _getTextoEnvio(venta.tipoEnvio),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              formatoMoneda.format(venta.costoEnvio),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Lista de ítems
                  const Text(
                    'Detalle de Productos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Ítems
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: venta.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildItemCard(venta.items[index], formatoMoneda);
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Resumen financiero
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal:'),
                            Text(formatoMoneda.format(venta.subtotal)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Envío:'),
                            Text(formatoMoneda.format(venta.costoEnvio)),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TOTAL:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              formatoMoneda.format(venta.total),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: CupertinoColors.activeBlue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Botones de acción
                  Row(
                    children: [
                      // Botón para generar PDF
                      Expanded(
                        child: CupertinoButton(
                          padding: const EdgeInsets.all(12),
                          color: CupertinoColors.activeBlue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(CupertinoIcons.doc_text),
                              SizedBox(width: 8),
                              Text('Generar PDF'),
                            ],
                          ),
                          onPressed: controller.generarPDFVenta,
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Botón para cambiar estado
                      Expanded(
                        child: CupertinoButton(
                          padding: const EdgeInsets.all(12),
                          color: CupertinoColors.activeGreen,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(CupertinoIcons.arrow_right_circle),
                              SizedBox(width: 8),
                              Text('Cambiar Estado'),
                            ],
                          ),
                          onPressed: () => _mostrarSelectorEstado(context, venta),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
  
  // Construir tarjeta de ítem
  Widget _buildItemCard(ItemVentaModel item, NumberFormat formatoMoneda) {
    // Mapear tamaño a texto legible
    String tamanoText;
    switch (item.tamano) {
      case TamanoSticker.cuarto:
        tamanoText = '1/4 de hoja';
        break;
      case TamanoSticker.medio:
        tamanoText = '1/2 hoja';
        break;
      case TamanoSticker.tresQuartos:
        tamanoText = '3/4 de hoja';
        break;
      case TamanoSticker.completo:
        tamanoText = 'Hoja completa';
        break;
      default:
        tamanoText = 'Tamaño personalizado';
    }
    
    // Descripción del diseño
    String disenoText = item.tipoDiseno == TipoDiseno.estandar 
        ? 'Diseño estándar' 
        : 'Diseño personalizado';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CupertinoColors.systemGrey5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre del material
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Sticker ${item.nombreHoja}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'Cantidad: ${item.cantidad}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Detalles del ítem
          Text('Laminado: ${item.nombreLaminado}'),
          Text('Tamaño: $tamanoText'),
          Text(disenoText),
          
          const SizedBox(height: 8),
          
          // Precios
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Precio unitario: ${formatoMoneda.format(item.precioUnitario)}'),
              Text(
                formatoMoneda.format(item.precioTotal),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Mostrar selector de estado
  void _mostrarSelectorEstado(BuildContext context, VentaModel venta) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
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
            const Text(
              'Cambiar Estado',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Lista de estados
            Expanded(
              child: ListView(
                children: [
                  _buildOpcionEstado(
                    context,
                    venta,
                    EstadoVenta.cotizacion,
                    'Cotización',
                    CupertinoColors.systemBlue,
                  ),
                  _buildOpcionEstado(
                    context,
                    venta,
                    EstadoVenta.pendiente,
                    'Pendiente',
                    CupertinoColors.systemOrange,
                  ),
                  _buildOpcionEstado(
                    context,
                    venta,
                    EstadoVenta.completada,
                    'Completada',
                    CupertinoColors.systemGreen,
                  ),
                  _buildOpcionEstado(
                    context,
                    venta,
                    EstadoVenta.cancelada,
                    'Cancelada',
                    CupertinoColors.systemRed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Construir opción de estado
  Widget _buildOpcionEstado(
    BuildContext context,
    VentaModel venta,
    EstadoVenta estado,
    String texto,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        if (venta.estado != estado) {
          controller.cambiarEstadoVenta(estado);
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CupertinoColors.systemGrey5,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Text(texto),
            const Spacer(),
            if (venta.estado == estado)
              const Icon(
                CupertinoIcons.check_mark,
                color: CupertinoColors.activeBlue,
              ),
          ],
        ),
      ),
    );
  }
  
  // Obtener color según estado
  Color _getColorPorEstado(EstadoVenta estado) {
    switch (estado) {
      case EstadoVenta.cotizacion:
        return CupertinoColors.systemBlue;
      case EstadoVenta.pendiente:
        return CupertinoColors.systemOrange;
      case EstadoVenta.completada:
        return CupertinoColors.systemGreen;
      case EstadoVenta.cancelada:
        return CupertinoColors.systemRed;
      default:
        return CupertinoColors.systemGrey;
    }
  }
  
  // Obtener texto según estado
  String _getTextoEstado(EstadoVenta estado) {
    switch (estado) {
      case EstadoVenta.cotizacion:
        return 'Cotización';
      case EstadoVenta.pendiente:
        return 'Pendiente';
      case EstadoVenta.completada:
        return 'Completada';
      case EstadoVenta.cancelada:
        return 'Cancelada';
      default:
        return 'Desconocido';
    }
  }
  
  // Obtener texto según tipo de envío
  String _getTextoEnvio(TipoEnvio tipo) {
    switch (tipo) {
      case TipoEnvio.normal:
        return 'Normal (2-3 días)';
      case TipoEnvio.express:
        return 'Express (24 horas)';
      case TipoEnvio.personalizado:
        return 'Personalizado';
      default:
        return 'Desconocido';
    }
  }
}