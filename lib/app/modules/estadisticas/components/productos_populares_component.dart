import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/estadisticas_controller.dart';
import '../../../data/models/item_venta_model.dart';

class ProductosPopularesComponent extends GetView<EstadisticasController> {
  const ProductosPopularesComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Formato para moneda guatemalteca
    final formatoMoneda = NumberFormat.currency(
      locale: 'es_GT',
      symbol: 'Q',
      decimalDigits: 2,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CupertinoColors.systemGrey5),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Productos Más Vendidos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 4),
          
          const Text(
            'Últimos 30 días',
            style: TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 12,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Lista de productos populares
          Obx(() {
            if (controller.productosPopulares.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'No hay datos de productos disponibles',
                    style: TextStyle(
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ),
              );
            }
            
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.productosPopulares.length,
              separatorBuilder: (context, index) => Container(height: 1),
              itemBuilder: (context, index) {
                final producto = controller.productosPopulares[index];
                return _buildProductoItem(producto, index + 1, formatoMoneda);
              },
            );
          }),
        ],
      ),
    );
  }
  
  // Construir item de producto en la lista
  Widget _buildProductoItem(Map<String, dynamic> producto, int posicion, NumberFormat formatoMoneda) {
    // Convertir el tamaño enumerado a texto
    String getTamanoText(dynamic tamano) {
      if (tamano is TamanoSticker) {
        switch (tamano) {
          case TamanoSticker.cuarto:
            return '1/4 hoja';
          case TamanoSticker.medio:
            return '1/2 hoja';
          case TamanoSticker.tresQuartos:
            return '3/4 hoja';
          case TamanoSticker.completo:
            return 'Hoja completa';
          default:
            return 'Desconocido';
        }
      } else if (tamano is String) {
        // Si es una cadena (posiblemente de la API), intentar convertirla
        if (tamano.contains('cuarto')) return '1/4 hoja';
        if (tamano.contains('medio')) return '1/2 hoja';
        if (tamano.contains('tresQuartos')) return '3/4 hoja';
        if (tamano.contains('completo')) return 'Hoja completa';
      }
      return 'Desconocido';
    }
    
    // Icono según el tamaño
    IconData getIconByTamano(dynamic tamano) {
      if (tamano is TamanoSticker) {
        switch (tamano) {
          case TamanoSticker.cuarto:
            return CupertinoIcons.square_split_1x2;
          case TamanoSticker.medio:
            return CupertinoIcons.square_split_2x1;
          case TamanoSticker.tresQuartos:
            return CupertinoIcons.square_split_2x2;
          case TamanoSticker.completo:
            return CupertinoIcons.square;
          default:
            return CupertinoIcons.square;
        }
      }
      return CupertinoIcons.square;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Número de posición
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: CupertinoColors.activeBlue.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$posicion',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: CupertinoColors.activeBlue,
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Icono según tamaño
          Icon(
            getIconByTamano(producto['tamano']),
            color: CupertinoColors.activeBlue,
            size: 22,
          ),
          
          const SizedBox(width: 12),
          
          // Información del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${producto['nombreHoja']} con ${producto['nombreLaminado']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${getTamanoText(producto['tamano'])} • ${producto['cantidad']} unidades',
                  style: const TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Monto total vendido
          Text(
            formatoMoneda.format(producto['ventas'] ?? 0),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}