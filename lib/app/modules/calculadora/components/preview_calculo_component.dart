// lib/app/modules/calculadora/components/preview_calculo_component.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/calculadora_controller.dart';

class PreviewCalculoComponent extends GetView<CalculadoraController> {
  PreviewCalculoComponent({Key? key}) : super(key: key);

  // Formato para moneda guatemalteca
  final formatoMoneda = NumberFormat.currency(
    locale: 'es_GT',
    symbol: 'Q',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalculadoraController>(
      builder:
          (controller) => Container(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: CupertinoColors.systemGrey5),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.systemGrey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resumen de Cálculo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                // Desglose de costos
                Obx(
                  () => _buildResumenItem(
                    'Materiales:',
                    controller.costoMateriales.value,
                  ),
                ),
                _buildDivider(),

                Obx(
                  () => _buildResumenItem(
                    'Costos Fijos:',
                    controller.costosFijos.value,
                  ),
                ),
                _buildDivider(),

                Obx(
                  () =>
                      _buildResumenItem('Subtotal:', controller.subtotal.value),
                ),
                _buildDivider(),

                Obx(
                  () => _buildResumenItem(
                    'Ganancia (50%):',
                    controller.ganancia.value,
                  ),
                ),
                _buildDivider(),

                // Precio unitario
                Obx(
                  () => _buildResumenItem(
                    'Precio Unitario:',
                    controller.precioUnitario.value,
                    isBold: true,
                  ),
                ),

                // Precio total si cantidad > 1
                Obx(() {
                  if (controller.cantidad.value > 1) {
                    return Column(
                      children: [
                        _buildDivider(),
                        _buildResumenItem(
                          'Precio Total (${controller.cantidad.value} unidades):',
                          controller.precioTotal.value,
                          isBold: true,
                          isTotal: true,
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
              ],
            ),
          ),
    );
  }

  // Widget para construir cada item del resumen
  Widget _buildResumenItem(
    String label,
    double valor, {
    bool isBold = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            formatoMoneda.format(valor),
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? CupertinoColors.activeBlue : null,
            ),
          ),
        ],
      ),
    );
  }

  // Reemplazo personalizado para Divider
  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: CupertinoColors.systemGrey5,
    );
  }
}
