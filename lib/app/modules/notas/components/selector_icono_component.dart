// lib/app/modules/notas/components/selector_icono_component.dart
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SelectorIconoComponent extends StatelessWidget {
  final RxString iconoSeleccionado;

  const SelectorIconoComponent({Key? key, required this.iconoSeleccionado})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lista de iconos disponibles
    final List<Map<String, dynamic>> iconos = [
      {'id': 'doc_text', 'icon': CupertinoIcons.doc_text, 'label': 'Nota'},
      {'id': 'cliente', 'icon': CupertinoIcons.person, 'label': 'Cliente'},
      {
        'id': 'proveedor',
        'icon': CupertinoIcons.building_2_fill,
        'label': 'Proveedor',
      },
      {'id': 'hoja', 'icon': CupertinoIcons.doc, 'label': 'Hoja'},
      {'id': 'laminado', 'icon': CupertinoIcons.layers, 'label': 'Laminado'},
      {'id': 'sticker', 'icon': CupertinoIcons.tag, 'label': 'Sticker'},
      {
        'id': 'estadistica',
        'icon': CupertinoIcons.graph_circle,
        'label': 'Estadística',
      },
      {'id': 'costos', 'icon': CupertinoIcons.money_dollar, 'label': 'Costos'},
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
          crossAxisCount: 4,
          childAspectRatio: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: iconos.length,
        itemBuilder: (context, index) {
          final icono = iconos[index];

          return Obx(
            () => GestureDetector(
              onTap: () => iconoSeleccionado.value = icono['id'],
              child: Container(
                decoration: BoxDecoration(
                  color:
                      iconoSeleccionado.value == icono['id']
                          ? CupertinoColors.activeBlue
                          : CupertinoColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        iconoSeleccionado.value == icono['id']
                            ? CupertinoColors.activeBlue
                            : CupertinoColors.systemGrey4,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icono['icon'],
                      color:
                          iconoSeleccionado.value == icono['id']
                              ? CupertinoColors.white
                              : CupertinoColors.systemGrey,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      icono['label'],
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            iconoSeleccionado.value == icono['id']
                                ? CupertinoColors.white
                                : CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
