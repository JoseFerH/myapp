import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/visualizacion_controller.dart';
import '../../../data/models/venta_model.dart';

class FiltrosComponent extends GetView<VisualizacionController> {
  const FiltrosComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: CupertinoColors.white,
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.systemGrey4,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          const Text(
            'Filtros',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Filtros en filas
          Row(
            children: [
              // Filtro de fecha
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rango de Fechas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildFechaSelector(context),
                  ],
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Filtro de estado
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estado',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildEstadoSelector(context),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Botón para limpiar filtros
          Align(
            alignment: Alignment.centerRight,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text('Limpiar Filtros'),
              onPressed: controller.limpiarFiltros,
            ),
          ),
        ],
      ),
    );
  }
  
  // Selector de rango de fechas
  Widget _buildFechaSelector(BuildContext context) {
    final formatoFecha = DateFormat('dd/MM/yyyy');
    
    return Obx(() => GestureDetector(
      onTap: () => _mostrarSelectorFechas(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: CupertinoColors.systemGrey4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${formatoFecha.format(controller.fechaInicio.value)} - ${formatoFecha.format(controller.fechaFin.value)}',
              style: const TextStyle(fontSize: 14),
            ),
            const Icon(
              CupertinoIcons.calendar,
              size: 16,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ),
      ),
    ));
  }
  
  // Selector de estado
  Widget _buildEstadoSelector(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: () => _mostrarSelectorEstado(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: CupertinoColors.systemGrey4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.estadoSeleccionado.value != null
                  ? _getTextoEstado(controller.estadoSeleccionado.value!)
                  : 'Todos los estados',
              style: const TextStyle(fontSize: 14),
            ),
            const Icon(
              CupertinoIcons.chevron_down,
              size: 16,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ),
      ),
    ));
  }
  
  // Mostrar selector de fechas
  void _mostrarSelectorFechas(BuildContext context) {
    // Valores temporales para el selector
    DateTime fechaInicioTemp = controller.fechaInicio.value;
    DateTime fechaFinTemp = controller.fechaFin.value;
    bool seleccionandoInicio = true;
    
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 400,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                // Selector entre fecha inicio y fin
                CupertinoSegmentedControl<bool>(
                  children: const {
                    true: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Fecha Inicio'),
                    ),
                    false: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Fecha Fin'),
                    ),
                  },
                  groupValue: seleccionandoInicio,
                  onValueChanged: (value) {
                    setState(() => seleccionandoInicio = value);
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Date picker
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: seleccionandoInicio ? fechaInicioTemp : fechaFinTemp,
                    minimumDate: seleccionandoInicio ? DateTime(2020) : fechaInicioTemp,
                    maximumDate: seleccionandoInicio ? fechaFinTemp : DateTime.now().add(const Duration(days: 1)),
                    onDateTimeChanged: (DateTime date) {
                      if (seleccionandoInicio) {
                        fechaInicioTemp = date;
                      } else {
                        fechaFinTemp = date;
                      }
                    },
                  ),
                ),
                
                // Botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      child: const Text('Cancelar'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    CupertinoButton(
                      child: const Text('Aceptar'),
                      onPressed: () {
                        controller.cambiarFechaInicio(fechaInicioTemp);
                        controller.cambiarFechaFin(fechaFinTemp);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            );
          }
        ),
      ),
    );
  }
  
  // Mostrar selector de estado
  void _mostrarSelectorEstado(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seleccionar Estado',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Lista de estados
            Expanded(
              child: ListView(
                children: [
                  // Opción "Todos"
                  _buildOpcionEstado(
                    context,
                    null,
                    'Todos los estados',
                    CupertinoColors.systemGrey,
                  ),
                  
                  // Estados específicos
                  _buildOpcionEstado(
                    context,
                    EstadoVenta.cotizacion,
                    'Cotización',
                    CupertinoColors.systemBlue,
                  ),
                  _buildOpcionEstado(
                    context,
                    EstadoVenta.pendiente,
                    'Pendiente',
                    CupertinoColors.systemOrange,
                  ),
                  _buildOpcionEstado(
                    context,
                    EstadoVenta.completada,
                    'Completada',
                    CupertinoColors.systemGreen,
                  ),
                  _buildOpcionEstado(
                    context,
                    EstadoVenta.cancelada,
                    'Cancelada',
                    CupertinoColors.systemRed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Construir opción de estado
  Widget _buildOpcionEstado(
    BuildContext context,
    EstadoVenta? estado,
    String texto,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        controller.filtrarPorEstado(estado);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CupertinoColors.systemGrey5,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Text(texto),
            const Spacer(),
            Obx(() => controller.estadoSeleccionado.value == estado
                ? const Icon(
                    CupertinoIcons.check_mark,
                    color: CupertinoColors.activeBlue,
                  )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
  
  // Obtener texto según estado
  String _getTextoEstado(EstadoVenta estado) {
    switch (estado) {
      case EstadoVenta.cotizacion:
        return 'Cotización';
      case EstadoVenta.pendiente:
        return 'Pendiente';
      case EstadoVenta.completada:
        return 'Completada';
      case EstadoVenta.cancelada:
        return 'Cancelada';
      default:
        return 'Desconocido';
    }
  }
}