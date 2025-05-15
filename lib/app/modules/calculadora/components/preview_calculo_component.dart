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

                // Detalle de cada material
                Obx(() {
                  if (controller.hojaSeleccionada.value != null) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: _buildDetalleItem(
                        'Hoja ${controller.hojaSeleccionada.value?.nombre}:',
                        _calcularCostoMaterialSegunTamano(
                          controller.hojaSeleccionada.value!.precioUnitario,
                          controller.tamanoSeleccionado.value,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                Obx(() {
                  if (controller.laminadoSeleccionada.value != null) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: _buildDetalleItem(
                        'Laminado ${controller.laminadoSeleccionada.value?.nombre}:',
                        _calcularCostoMaterialSegunTamano(
                          controller.laminadoSeleccionada.value!.precioUnitario,
                          controller.tamanoSeleccionado.value,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: _buildDetalleItem(
                    'Tinta:',
                    controller.calcularCostoTinta(),
                  ),
                ),

                _buildDivider(),

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

                // Subtotal sin desperdicio
                Obx(() {
                  final subtotalSinDesperdicio =
                      controller.costoMateriales.value +
                      controller.costosFijos.value +
                      (controller.tipoDiseno.value == TipoDiseno.estandar
                          ? calculadoraService
                              .configuracion
                              .precioDisenioEstandar
                          : controller.precioDiseno.value);
                  return _buildDetalleItem(
                    'Subtotal (sin desperdicio):',
                    subtotalSinDesperdicio,
                  );
                }),

                // Desperdicio (si está activado)
                Obx(() {
                  if (controller.aplicarDesperdicio.value) {
                    final subtotalSinDesperdicio =
                        controller.costoMateriales.value +
                        controller.costosFijos.value;
                    final valorDesperdicio =
                        subtotalSinDesperdicio *
                        (calculadoraService
                                .configuracion
                                .porcentajeDesperdicio /
                            100);
                    return _buildDetalleItem(
                      'Desperdicio (${calculadoraService.configuracion.porcentajeDesperdicio}%):',
                      valorDesperdicio,
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // Diseño
                Obx(() {
                  final valorDiseno =
                      controller.tipoDiseno.value == TipoDiseno.estandar
                          ? calculadoraService
                              .configuracion
                              .precioDisenioEstandar
                          : controller.precioDiseno.value;

                  if (valorDiseno > 0) {
                    return _buildDetalleItem('Diseño:', valorDiseno);
                  }
                  return const SizedBox.shrink();
                }),

                _buildDivider(),

                Obx(
                  () =>
                      _buildResumenItem('Subtotal:', controller.subtotal.value),
                ),

                _buildDivider(),

                // Ganancia con porcentaje real
                Obx(() {
                  final porcentajeGanancia =
                      calculadoraService
                          .configuracion
                          .porcentajeGananciasDefault;
                  return _buildResumenItem(
                    'Ganancia (${porcentajeGanancia.toStringAsFixed(0)}%):',
                    controller.ganancia.value,
                  );
                }),

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

                // Indicador de regla especial aplicada
                // Indicador de regla especial aplicada
                Obx(() {
                  // Ahora solo verificamos la regla de mayorista
                  final calculado =
                      controller.subtotal.value + controller.ganancia.value;
                  // La regla de mayorista es la única que puede hacer que el precio calculado
                  // sea diferente al precio unitario final
                  if (calculado != controller.precioUnitario.value &&
                      controller.tamanoSeleccionado.value ==
                          TamanoSticker.cuarto &&
                      controller.cantidad.value >=
                          calculadoraService.configuracion.cantidadMayorista) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '* Se aplicó precio especial para compras mayoristas',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                          color: CupertinoColors.systemBlue,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
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
