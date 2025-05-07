import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/estadisticas_controller.dart';
import '../../../data/models/cliente_model.dart';

class TopClientesComponent extends GetView<EstadisticasController> {
  const TopClientesComponent({Key? key}) : super(key: key);

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
            'Top Clientes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Lista de top clientes
          Obx(() {
            if (controller.topClientes.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'No hay datos de clientes disponibles',
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
              itemCount: controller.topClientes.length,
              separatorBuilder: (context, index) => Container(height: 1),
              itemBuilder: (context, index) {
                final cliente = controller.topClientes[index];
                return _buildClienteItem(cliente, index + 1, formatoMoneda);
              },
            );
          }),
        ],
      ),
    );
  }
  
  // Construir item de cliente en la lista
  Widget _buildClienteItem(ClienteModel cliente, int posicion, NumberFormat formatoMoneda) {
    // Color según posición
    Color getColorByPosition(int pos) {
      switch (pos) {
        case 1:
          return CupertinoColors.systemYellow;
        case 2:
          return Color(0xFFAAAAAA); // Plata
        case 3:
          return Color(0xFFCD7F32); // Bronce
        default:
          return CupertinoColors.systemGrey;
      }
    }
    
    // Icono según posición
    IconData getIconByPosition(int pos) {
      switch (pos) {
        case 1:
          return CupertinoIcons.star_fill;
        case 2:
          return CupertinoIcons.star;
        case 3:
          return CupertinoIcons.star;
        default:
          return CupertinoIcons.person;
      }
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
              color: getColorByPosition(posicion).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$posicion',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: getColorByPosition(posicion),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Ícono según tipo de cliente
          Icon(
            getIconByPosition(posicion),
            color: getColorByPosition(posicion),
            size: 18,
          ),
          
          const SizedBox(width: 12),
          
          // Información del cliente
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cliente.nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Zona ${cliente.zona} • ${cliente.tipoCliente}',
                  style: const TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Monto total gastado
          Text(
            formatoMoneda.format(cliente.totalGastado),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}