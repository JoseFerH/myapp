// lib/app/modules/registros/components/lista_registros_component.dart

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../controllers/registros_controller.dart';
import '../../../widgets/empty_state.dart';

class ListaRegistrosComponent extends GetView<RegistrosController> {
  final String tipo; // 'clientes', 'proveedores', 'materiales'
  final Function(BuildContext) onAgregar;
  // Change this line to include BuildContext in the function signature
  final Widget Function(BuildContext, int) itemBuilder;
  final String emptyTitle;
  final String emptyMessage;
  final IconData emptyIcon;
  
  const ListaRegistrosComponent({
    Key? key,
    required this.tipo,
    required this.onAgregar,
    required this.itemBuilder,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.emptyIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Lista de elementos
        Obx(() {
          int itemCount = 0;
          
          switch (tipo) {
            case 'clientes':
              itemCount = controller.clientesFiltrados.length;
              break;
            case 'proveedores':
              itemCount = controller.proveedoresFiltrados.length;
              break;
            case 'materiales':
              itemCount = controller.materialesFiltrados.length;
              break;
          }
          
          if (itemCount == 0) {
            return EmptyState(
              title: emptyTitle,
              message: emptyMessage,
              icon: emptyIcon,
              buttonText: 'Agregar',
              onButtonPressed: () => onAgregar(context),
            );
          }
          
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 80), // Espacio para el botón flotante
            itemCount: itemCount,
            // Correct this line to pass the context parameter to itemBuilder
            itemBuilder: (context, index) => itemBuilder(context, index),
            separatorBuilder: (context, index) => Container(height: 1),
          );
        }),
        
        // Botón flotante para agregar
        Positioned(
          right: 16,
          bottom: 16,
          child: CupertinoButton(
            padding: const EdgeInsets.all(16),
            color: CupertinoColors.activeBlue,
            child: const Icon(CupertinoIcons.add),
            onPressed: () => onAgregar(context),
          ),
        ),
      ],
    );
  }
}