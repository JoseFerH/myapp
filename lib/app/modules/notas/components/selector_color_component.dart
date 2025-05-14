// lib/app/modules/notas/components/selector_color_component.dart
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SelectorColorComponent extends StatelessWidget {
  final Rx<Color> colorSeleccionado;

  const SelectorColorComponent({Key? key, required this.colorSeleccionado})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lista de colores disponibles
    final List<Color> colores = [
      const Color(0xFF9E9E9E), // Gris
      const Color(0xFFF44336), // Rojo
      const Color(0xFFE91E63), // Rosa
      const Color(0xFF9C27B0), // Púrpura
      const Color(0xFF673AB7), // Morado
      const Color(0xFF3F51B5), // Azul Índigo
      const Color(0xFF2196F3), // Azul
      const Color(0xFF03A9F4), // Azul Claro
      const Color(0xFF00BCD4), // Cian
      const Color(0xFF009688), // Verde Azulado
      const Color(0xFF4CAF50), // Verde
      const Color(0xFF8BC34A), // Verde Claro
      const Color(0xFFCDDC39), // Lima
      const Color(0xFFFFEB3B), // Amarillo
      const Color(0xFFFFC107), // Ámbar
      const Color(0xFFFF9800), // Naranja
    ];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CupertinoColors.systemGrey4),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          childAspectRatio: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: colores.length,
        itemBuilder: (context, index) {
          final color = colores[index];

          return Obx(
            () => GestureDetector(
              onTap: () => colorSeleccionado.value = color,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        colorSeleccionado.value == color
                            ? CupertinoColors.white
                            : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow:
                      colorSeleccionado.value == color
                          ? [
                            BoxShadow(
                              color: CupertinoColors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : [],
                ),
                child:
                    colorSeleccionado.value == color
                        ? const Icon(
                          CupertinoIcons.checkmark_alt,
                          color: CupertinoColors.white,
                          size: 16,
                        )
                        : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
