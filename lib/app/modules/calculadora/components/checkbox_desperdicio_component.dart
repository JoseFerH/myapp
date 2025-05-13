// lib/app/modules/calculadora/components/checkbox_desperdicio_component.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/calculadora_controller.dart';

class CheckboxDesperdicioComponent extends GetView<CalculadoraController> {
  const CheckboxDesperdicioComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalculadoraController>(
      builder:
          (controller) => Container(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: CupertinoColors.white,
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
                  'Aplicar Desperdicio',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Obx(
                      () => CupertinoSwitch(
                        value: controller.aplicarDesperdicio.value,
                        onChanged: (value) {
                          controller.toggleDesperdicio(value);
                        },
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Text('5% de desperdicio'),
                  ],
                ),

                const SizedBox(height: 8),

                const Text(
                  'Aplicar costo por material desperdiciado en el proceso',
                  style: TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
