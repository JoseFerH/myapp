// lib/app/modules/estadisticas/estadisticas_view.dart

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
              
              // Contenido principal (scrollable con refresh control de Cupertino)
              Expanded(
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // Control de refresh estilo iOS
                    CupertinoSliverRefreshControl(
                      onRefresh: () => controller.actualizarDashboard(),
                    ),
                    
                    // Contenido principal
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Resumen de ventas del período seleccionado
                          const ResumenVentasComponent(),
                          
                          const SizedBox(height: 24),
                          
                          // Gráficos de ventas
                          const GraficosVentasComponent(),
                          
                          const SizedBox(height: 24),
                          
                          // Top clientes
                          const TopClientesComponent(),
                          
                          const SizedBox(height: 24),
                          
                          // Productos populares
                          const ProductosPopularesComponent(),
                          
                          const SizedBox(height: 24),
                          
                          // Alertas de inventario
                          const AlertasInventarioComponent(),
                          
                          const SizedBox(height: 16),
                        ]),
                      ),
                    ),
                  ],
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