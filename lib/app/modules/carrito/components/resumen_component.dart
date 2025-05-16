// lib/app/modules/carrito/components/resumen_component.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/carrito_controller.dart';
import '../../../data/models/item_venta_model.dart';

class ResumenComponent extends GetView<CarritoController> {
  ResumenComponent({Key? key}) : super(key: key);

  // Formato para moneda guatemalteca
  final formatoMoneda = NumberFormat.currency(
    locale: 'es_GT',
    symbol: 'Q',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CupertinoColors.systemGrey5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          // Subtotal
          _buildResumenRow(
            label: 'Subtotal:',
            valor: controller.subtotal.value,
          ),
          // Añadir después del subtotal pero antes del costo de envío
          Obx(() {
            // Contar stickers de 1/4
            int cantidadStickers = 0;
            for (var item in controller.items) {
              if (item.tamano == TamanoSticker.cuarto) {
                cantidadStickers += item.cantidad;
              }
            }

            // Mostrar texto de descuento solo si hay más de un sticker de 1/4
            if (cantidadStickers > 1) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      'Descuento multicompra aplicado',
                      style: TextStyle(
                        color: CupertinoColors.activeGreen,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
          // Envío
          _buildResumenRow(label: 'Envío:', valor: controller.costoEnvio.value),

          // Reemplazamos Divider por un contenedor personalizado
          Container(
            height: 1,
            color: CupertinoColors.systemGrey4,
            margin: const EdgeInsets.symmetric(vertical: 12),
          ),

          // Total
          _buildResumenRow(
            label: 'TOTAL:',
            valor: controller.total.value,
            esTotal: true,
          ),

          const SizedBox(height: 8),

          // Promoción de redes sociales si aplica
          Obx(() {
            if (controller.verificarPromoRedesSociales()) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Promoción 3x90 disponible',
                    style: TextStyle(
                      color: CupertinoColors.activeGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text('Aplicar'),
                    onPressed: controller.aplicarPromoRedesSociales,
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }

  // Construir fila de resumen
  Widget _buildResumenRow({
    required String label,
    required double valor,
    bool esTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: esTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: esTotal ? 18 : 16,
            ),
          ),
          Text(
            formatoMoneda.format(valor),
            style: TextStyle(
              fontWeight: esTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: esTotal ? 18 : 16,
              color: esTotal ? CupertinoColors.activeBlue : null,
            ),
          ),
        ],
      ),
    );
  }
}
