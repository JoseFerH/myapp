// lib/app/modules/calculadora/components/preview_calculo_component.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/calculadora_controller.dart';
import '../../../data/models/item_venta_model.dart';
import '../../../data/services/calculadora_service.dart';

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
    // Acceder al servicio calculadora para obtener la configuración
    final calculadoraService = Get.find<CalculadoraService>();

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

                // Desglose de costos de materiales
                Obx(
                  () => _buildResumenItem(
                    'Materiales:',
                    controller.costoMateriales.value,
                  ),
                ),

                // Detalle de cada material - Ahora para múltiples hojas
                Obx(() {
                  List<Widget> hojasWidgets = [];
                  for (var hoja in controller.hojasSeleccionadas) {
                    hojasWidgets.add(
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: _buildDetalleItem(
                          'Hoja ${hoja.nombre}:',
                          _calcularCostoMaterialSegunTamano(
                            hoja.precioUnitario,
                            controller.tamanoSeleccionado.value,
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(children: hojasWidgets);
                }),

                // Detalle de cada material - Ahora para múltiples laminados
                Obx(() {
                  List<Widget> laminadosWidgets = [];
                  for (var laminado in controller.laminadosSeleccionados) {
                    laminadosWidgets.add(
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: _buildDetalleItem(
                          'Laminado ${laminado.nombre}:',
                          _calcularCostoMaterialSegunTamano(
                            laminado.precioUnitario,
                            controller.tamanoSeleccionado.value,
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(children: laminadosWidgets);
                }),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: _buildDetalleItem(
                    'Tinta:',
                    controller.calcularCostoTinta(),
                  ),
                ),

                _buildDivider(),

                // Resto del componente sigue igual
                // ...

                // Desglose de costos fijos
                Obx(
                  () => _buildResumenItem(
                    'Costos Fijos:',
                    controller.costosFijos.value,
                  ),
                ),

                // Detalle de cada costo fijo activo
                Obx(() {
                  List<Widget> costosFijosWidgets = [];
                  for (var costo in calculadoraService.listaCostosFijos) {
                    if (costo.activo) {
                      costosFijosWidgets.add(
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: _buildDetalleItem(
                            '${costo.nombre}:',
                            costo.valor,
                          ),
                        ),
                      );
                    }
                  }
                  return Column(children: costosFijosWidgets);
                }),

                _buildDivider(),

                // Resto del código sigue igual
                // ...
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

  // Widget para construir items de detalle con menor jerarquía visual
  Widget _buildDetalleItem(String label, double valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
          ),
          Text(
            formatoMoneda.format(valor),
            style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
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

  // Método auxiliar para calcular el costo del material según el tamaño
  double _calcularCostoMaterialSegunTamano(
    double precioBase,
    TamanoSticker tamano,
  ) {
    switch (tamano) {
      case TamanoSticker.cuarto:
        return precioBase / 4;
      case TamanoSticker.medio:
        return precioBase / 2;
      case TamanoSticker.tresQuartos:
        return precioBase * 0.75;
      case TamanoSticker.completo:
        return precioBase;
      default:
        return precioBase / 4;
    }
  }
}
