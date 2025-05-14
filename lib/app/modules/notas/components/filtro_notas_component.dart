// lib/app/modules/notas/components/filtro_notas_component.dart
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/notas_controller.dart';

class FiltroNotasComponent extends GetView<NotasController> {
  const FiltroNotasComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtener categorías únicas de las notas
    List<String> obtenerCategorias() {
      final categorias = ['Todas'];

      for (var nota in controller.notas) {
        if (!categorias.contains(nota.categoria)) {
          categorias.add(nota.categoria);
        }
      }

      return categorias;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: CupertinoColors.white,
        border: Border(
          bottom: BorderSide(color: CupertinoColors.systemGrey4, width: 0.5),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(() {
          final categorias = obtenerCategorias();

          return Row(
            children:
                categorias.map((categoria) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      color:
                          controller.filtroCategoria.value == categoria
                              ? CupertinoColors.activeBlue
                              : CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(20),
                      onPressed:
                          () => controller.cambiarFiltroCategoria(categoria),
                      child: Text(
                        categoria,
                        style: TextStyle(
                          color:
                              controller.filtroCategoria.value == categoria
                                  ? CupertinoColors.white
                                  : CupertinoColors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          );
        }),
      ),
    );
  }
}
