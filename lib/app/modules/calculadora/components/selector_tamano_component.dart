import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/calculadora_controller.dart';
import '../../../data/models/item_venta_model.dart';

class SelectorTamanoComponent extends GetView<CalculadoraController> {
  const SelectorTamanoComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tamaño del Sticker',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Obx(
              () => CupertinoSegmentedControl<TamanoSticker>(
                children: const {
                  TamanoSticker.cuarto: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("1/4"),
                  ),
                  TamanoSticker.completo: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("Completo"),
                  ),
                },
                groupValue: controller.tamanoSeleccionado.value,
                onValueChanged: (value) {
                  controller.seleccionarTamano(value);
                },
              ),
            ),

            const SizedBox(height: 8),

            // Texto explicativo
            const Text(
              'El tamaño afecta la cantidad de material utilizado y el precio final.',
              style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
            ),
          ],
        ),
      ),
    );
  }
}
