import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/configuracion_controller.dart';

class PorcentajesComponent extends GetView<ConfiguracionController> {
  const PorcentajesComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        const Text(
          'Porcentajes de Ganancia',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        const Text(
          'Configura los porcentajes de ganancia para los cálculos de precios.',
          style: TextStyle(
            color: CupertinoColors.systemGrey,
            fontSize: 14,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Porcentaje de ganancia mínimo
        _buildPorcentajeSection(
          'Porcentaje Mínimo de Ganancia',
          'Este es el porcentaje mínimo de ganancia que se aplicará en todos los cálculos.',
          controller.porcentajeGananciasMin,
          (value) => controller.porcentajeGananciasMin.value = value,
        ),
        
        const SizedBox(height: 24),
        
        // Porcentaje de ganancia predeterminado
        _buildPorcentajeSection(
          'Porcentaje Predeterminado de Ganancia',
          'Este porcentaje se aplicará por defecto en la calculadora.',
          controller.porcentajeGananciasDefault,
          (value) => controller.porcentajeGananciasDefault.value = value,
        ),
        
        const SizedBox(height: 24),
        
        // Porcentaje de desperdicio
        _buildPorcentajeSection(
          'Porcentaje de Desperdicio',
          'Porcentaje adicional que se aplica para cubrir materiales desperdiciados.',
          controller.porcentajeDesperdicio,
          (value) => controller.porcentajeDesperdicio.value = value,
        ),
        
        const SizedBox(height: 24),
        
        // Aplicar desperdicio por defecto
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: CupertinoColors.systemGrey5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aplicar Desperdicio por Defecto',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Activar o desactivar el cálculo de desperdicio por defecto.',
                      style: TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() => CupertinoSwitch(
                value: controller.aplicarDesperdicioDefault.value,
                onChanged: (value) => controller.aplicarDesperdicioDefault.value = value,
              )),
            ],
          ),
        ),
      ],
    );
  }
  
  // Construir sección de porcentaje con slider
  Widget _buildPorcentajeSection(
    String title,
    String description,
    RxDouble value,
    Function(double) onChanged,
  ) {
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
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Slider para ajustar porcentaje
              Expanded(
                child: Obx(() => CupertinoSlider(
                  value: value.value,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  onChanged: onChanged,
                )),
              ),
              // Valor actual
              Container(
                width: 60,
                alignment: Alignment.center,
                child: Obx(() => Text(
                  '${value.value.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}