import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../controllers/estadisticas_controller.dart';

class GraficosVentasComponent extends GetView<EstadisticasController> {
  const GraficosVentasComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Formato para moneda guatemalteca
    final formatoMoneda = NumberFormat.currency(
      locale: 'es_GT',
      symbol: 'Q',
      decimalDigits: 0,
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
            'Ventas por Día',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Gráfico de barras
          SizedBox(
            height: 250,
            child: Obx(() {
              // Si no hay datos, mostrar mensaje
              if (controller.datosGraficoVentas.isEmpty) {
                return const Center(
                  child: Text(
                    'No hay datos disponibles para mostrar',
                    style: TextStyle(
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                );
              }
              
              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _calcularMaximoY(),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: CupertinoColors.systemBackground,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final dato = controller.datosGraficoVentas[groupIndex];
                        return BarTooltipItem(
                          '${dato['dia']}: ${formatoMoneda.format(dato['total'])}',
                          const TextStyle(
                            color: CupertinoColors.systemBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value < 0 || value >= controller.datosGraficoVentas.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              controller.datosGraficoVentas[value.toInt()]['dia'],
                              style: const TextStyle(
                                color: CupertinoColors.systemGrey,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            formatoMoneda.format(value),
                            style: const TextStyle(
                              color: CupertinoColors.systemGrey,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: List.generate(
                    controller.datosGraficoVentas.length,
                    (index) {
                      final dato = controller.datosGraficoVentas[index];
                      final double valor = dato['total'] ?? 0;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: valor,
                            color: CupertinoColors.activeBlue,
                            width: 20,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: _calcularIntervaloY(),
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: CupertinoColors.systemGrey5,
                        strokeWidth: 1,
                      );
                    },
                    drawVerticalLine: false,
                  ),
                ),
              );
            }),
          ),
          
          const SizedBox(height: 8),
          
          // Leyenda o descripción adicional
          const Text(
            'Ventas diarias en los últimos 7 días',
            style: TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  // Calcular el valor máximo para el eje Y
  double _calcularMaximoY() {
    if (controller.datosGraficoVentas.isEmpty) {
      return 100; // Valor por defecto
    }
    
    double maxValue = 0;
    for (var dato in controller.datosGraficoVentas) {
      final double valor = dato['total'] ?? 0;
      if (valor > maxValue) {
        maxValue = valor;
      }
    }
    
    // Agregar un 20% adicional para que la barra más alta no toque el borde superior
    return maxValue * 1.2;
  }
  
  // Calcular el intervalo para las líneas horizontales
  double _calcularIntervaloY() {
    final maxY = _calcularMaximoY();
    
    // Determinar un intervalo que dé entre 4 y 6 líneas
    final int numIntervalos = 5;
    return maxY / numIntervalos;
  }
}