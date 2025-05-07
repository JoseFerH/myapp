import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/estadisticas_controller.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';
import 'components/resumen_ventas_component.dart';
import 'components/graficos_ventas_component.dart';
import 'components/top_clientes_component.dart';
import 'components/productos_populares_component.dart';
import 'components/alertas_inventario_component.dart';

class EstadisticasView extends GetView<EstadisticasController> {
  const EstadisticasView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Obx(() {
          // Mostrar loading si está cargando
          if (controller.cargando.value) {
            return const LoadingIndicator(message: 'Cargando estadísticas...');
          }
          
          // Mostrar error si existe
          if (controller.error.value.isNotEmpty) {
            return ErrorMessage(
              message: controller.error.value,
              onRetry: () => controller.actualizarDashboard(),
            );
          }
          
          return Column(
            children: [
              // Selector de período
              _buildPeriodoSelector(),
              
              // Contenido principal (scrollable)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => controller.actualizarDashboard(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        // Resumen de ventas del período seleccionado
                        ResumenVentasComponent(),
                        
                        SizedBox(height: 24),
                        
                        // Gráficos de ventas
                        GraficosVentasComponent(),
                        
                        SizedBox(height: 24),
                        
                        // Top clientes
                        TopClientesComponent(),
                        
                        SizedBox(height: 24),
                        
                        // Productos populares
                        ProductosPopularesComponent(),
                        
                        SizedBox(height: 24),
                        
                        // Alertas de inventario
                        AlertasInventarioComponent(),
                        
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
  
  // Selector de período para estadísticas
  Widget _buildPeriodoSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: CupertinoColors.white,
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.systemGrey4,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Período:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          
          Expanded(
            child: Obx(() => CupertinoSlidingSegmentedControl<String>(
              groupValue: controller.periodoSeleccionado.value,
              children: const {
                'dia': Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text('Hoy'),
                ),
                'semana': Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text('Semana'),
                ),
                'mes': Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text('Mes'),
                ),
              },
              onValueChanged: (value) {
                if (value != null) {
                  controller.cambiarPeriodo(value);
                }
              },
            )),
          ),
          
          // Botón para actualizar datos
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.refresh),
            onPressed: controller.actualizarDashboard,
          ),
        ],
      ),
    );
  }
}