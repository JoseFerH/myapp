import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/visualizacion_controller.dart';
import '../../../data/models/venta_model.dart';

class TablaDatosComponent extends GetView<VisualizacionController> {
  TablaDatosComponent({Key? key}) : super(key: key);

  // Formato para fechas y moneda
  final formatoFecha = DateFormat('dd/MM/yyyy');
  final formatoMoneda = NumberFormat.currency(
    locale: 'es_GT',
    symbol: 'Q',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: controller.ventas.length,
      separatorBuilder: (context, index) => Container(height: 1),
      itemBuilder: (context, index) {
        final venta = controller.ventas[index];
        return _buildVentaItem(venta);
      },
    ));
  }
  
  // Construir ítem de venta
  Widget _buildVentaItem(VentaModel venta) {
    return GestureDetector(
      onTap: () => controller.seleccionarVenta(venta),
      child: Container(
        padding: const EdgeInsets.all(16),
        color: controller.ventaSeleccionada.value?.id == venta.id
            ? CupertinoColors.systemBlue.withOpacity(0.1)
            : CupertinoColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila superior - ID, Fecha y Estado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ID de venta (truncado para mostrar solo primeros caracteres)
                Text(
                  '#${venta.id.substring(0, 6)}...',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                
                // Fecha
                Text(
                  formatoFecha.format(venta.fecha),
                  style: const TextStyle(
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                
                // Estado
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getColorPorEstado(venta.estado).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getTextoEstado(venta.estado),
                    style: TextStyle(
                      color: _getColorPorEstado(venta.estado),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Nombre del cliente
            Text(
              'Cliente: ${venta.nombreCliente}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Cantidad de ítems
            Text(
              'Ítems: ${venta.items.length} producto(s)',
              style: const TextStyle(
                fontSize: 14,
                color: CupertinoColors.systemGrey,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Fila inferior - Subtotal, Envío y Total
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Subtotal: ${formatoMoneda.format(venta.subtotal)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Envío: ${formatoMoneda.format(venta.costoEnvio)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Total: ${formatoMoneda.format(venta.total)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
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
}