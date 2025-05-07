import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/estadisticas_controller.dart';

class ResumenVentasComponent extends GetView<EstadisticasController> {
  const ResumenVentasComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Formato para moneda guatemalteca
    final formatoMoneda = NumberFormat.currency(
      locale: 'es_GT',
      symbol: 'Q',
      decimalDigits: 2,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resumen de Ventas',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Tarjetas con datos principales
        Row(
          children: [
            // Total de ventas
            Expanded(
              child: _buildInfoCard(
                'Total Ventas',
                formatoMoneda.format(controller.obtenerTotalPeriodo()),
                CupertinoIcons.money_dollar,
                CupertinoColors.activeBlue,
                controller.obtenerVariacionPorcentual() >= 0 
                    ? '+${controller.obtenerVariacionPorcentual().toStringAsFixed(1)}%' 
                    : '${controller.obtenerVariacionPorcentual().toStringAsFixed(1)}%',
                controller.obtenerVariacionPorcentual() >= 0 
                    ? CupertinoColors.systemGreen 
                    : CupertinoColors.systemRed,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Cantidad de ventas
            Expanded(
              child: _buildInfoCard(
                'Cantidad',
                '${controller.obtenerCantidadVentas()} ventas',
                CupertinoIcons.doc_text,
                CupertinoColors.systemOrange,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        Row(
          children: [
            // Promedio por venta
            Expanded(
              child: _buildInfoCard(
                'Prom. por Venta',
                formatoMoneda.format(controller.obtenerPromedioVenta()),
                CupertinoIcons.chart_bar,
                CupertinoColors.systemPurple,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Espacio para otra métrica o dejarlo vacío
            Expanded(
              child: Obx(() {
                // Según el periodo seleccionado, mostrar texto diferente
                String periodoTexto;
                switch (controller.periodoSeleccionado.value) {
                  case 'dia':
                    periodoTexto = 'de hoy';
                    break;
                  case 'semana':
                    periodoTexto = 'de esta semana';
                    break;
                  case 'mes':
                  default:
                    periodoTexto = 'de este mes';
                    break;
                }
                
                return _buildInfoCard(
                  'Período',
                  'Datos $periodoTexto',
                  CupertinoIcons.calendar,
                  CupertinoColors.systemGreen,
                );
              }),
            ),
          ],
        ),
      ],
    );
  }
  
  // Construir tarjeta de información
  Widget _buildInfoCard(
    String title, 
    String value, 
    IconData icon, 
    Color color, 
    [String? changeText, Color? changeColor]
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CupertinoColors.systemGrey5),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ícono y título
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Valor principal
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          
          // Mostrar cambio porcentual si está disponible
          if (changeText != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  changeText.startsWith('+') 
                      ? CupertinoIcons.arrow_up 
                      : CupertinoIcons.arrow_down,
                  color: changeColor,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  changeText,
                  style: TextStyle(
                    color: changeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}