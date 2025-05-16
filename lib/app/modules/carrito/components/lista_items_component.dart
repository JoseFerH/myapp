import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/carrito_controller.dart';
import '../../../data/models/item_venta_model.dart';

class ListaItemsComponent extends GetView<CarritoController> {
  ListaItemsComponent({Key? key}) : super(key: key);

  // Formato para moneda guatemalteca
  final formatoMoneda = NumberFormat.currency(
    locale: 'es_GT',
    symbol: 'Q',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CupertinoColors.systemGrey5),
      ),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Productos en Carrito',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${controller.items.length} ítem(s)',
                    style: const TextStyle(color: CupertinoColors.systemGrey),
                  ),
                ],
              ),
            ),

            // Lista de ítems
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.items.length,
              separatorBuilder:
                  (context, index) =>
                      Container(height: 1, color: CupertinoColors.systemGrey5),
              itemBuilder: (context, index) {
                final item = controller.items[index];
                return _buildItemCard(item, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Construir tarjeta de ítem
  Widget _buildItemCard(ItemVentaModel item, int index) {
    // Mapear tamaño a texto legible
    String tamanoText;
    switch (item.tamano) {
      case TamanoSticker.cuarto:
        tamanoText = '1/4 de hoja';
        break;
      case TamanoSticker.completo:
        tamanoText = 'Hoja completa';
        break;
      default:
        tamanoText = 'Tamaño personalizado';
    }

    // Descripción del diseño
    String disenoText =
        item.tipoDiseno == TipoDiseno.estandar
            ? 'Diseño estándar'
            : 'Diseño personalizado';

    return Dismissible(
      key: Key(item.id.isEmpty ? 'item-$index' : item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: CupertinoColors.systemRed,
        child: const Icon(CupertinoIcons.delete, color: CupertinoColors.white),
      ),
      onDismissed: (direction) {
        controller.eliminarItem(index);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primera fila - Nombre y precio total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Sticker ${item.nombreHoja}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  formatoMoneda.format(item.precioTotal),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Segunda fila - Detalles del ítem
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${item.cantidad}x $tamanoText'),
                      Text('Laminado: ${item.nombreLaminado}'),
                      Text(disenoText),
                    ],
                  ),
                ),
                Text(
                  '${formatoMoneda.format(item.precioUnitario)} c/u',
                  style: const TextStyle(color: CupertinoColors.systemGrey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
