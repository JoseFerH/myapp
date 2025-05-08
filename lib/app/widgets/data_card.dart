// lib/app/widgets/data_card.dart

import 'package:flutter/cupertino.dart';
import '../utils/themes.dart';

/// Widget para mostrar datos en formato de tarjeta

class DataCard extends StatelessWidget {
  // Título de la tarjeta
  final String title;

  // Subtítulo (opcional)
  final String? subtitle;

  // Color de fondo
  final Color? backgroundColor;

  // Color del borde
  final Color? borderColor;

  // Icono (opcional)
  final IconData? icon;

  // Color del icono
  final Color? iconColor;

  // Widget de acción (opcional)
  final Widget? action;

  // Lista de filas de datos
  final List<DataRow> rows;

  // Padding interno
  final EdgeInsetsGeometry padding;

  // Constructor
  const DataCard({
    Key? key,
    required this.title,
    this.subtitle,
    this.backgroundColor,
    this.borderColor,
    this.icon,
    this.iconColor,
    this.action,
    required this.rows,
    this.padding = const EdgeInsets.all(16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
        border: Border.all(color: borderColor ?? AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado con título e icono
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
                const SizedBox(width: 8),
              ],

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyle.bodyBold),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: AppTextStyle.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Acción opcional
              if (action != null) action!,
            ],
          ),

          // Divisor
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: CupertinoColors.systemGrey5,
          ),

          // Filas de datos
          ...rows,
        ],
      ),
    );
  }

  // Tarjeta de resumen de totales
  static Widget summary({
    required String title,
    IconData? icon,
    required List<SummaryItem> items,
    required String total,
    String? totalSubtitle,
    Color? totalColor,
  }) {
    // Convertir los items a filas de datos
    final List<DataRow> rows =
        items
            .map(
              (item) => DataRow(
                label: item.label,
                value: item.value,
                valueColor: item.color,
              ),
            )
            .toList();

    // Agregar el total como una fila separada
    rows.add(const DataRow.divider());
    rows.add(
      DataRow(
        label: 'Total',
        value: total,
        isTotal: true,
        valueColor: totalColor ?? AppColors.primary,
        valueSubLabel: totalSubtitle,
      ),
    );

    return DataCard(title: title, icon: icon, rows: rows);
  }
}

/// Fila de datos para DataCard
class DataRow extends StatelessWidget {
  // Etiqueta (izquierda)
  final String label;

  // Valor (derecha)
  final String value;

  // Sublabel para la etiqueta
  final String? subLabel;

  // Sublabel para el valor
  final String? valueSubLabel;

  // Color del valor
  final Color? valueColor;

  // Si es un total (formato especial)
  final bool isTotal;

  // Si es un divisor
  final bool isDivider;

  // Constructor
  const DataRow({
    Key? key,
    required this.label,
    required this.value,
    this.subLabel,
    this.valueSubLabel,
    this.valueColor,
    this.isTotal = false,
    this.isDivider = false,
  }) : super(key: key);

  // Constructor para divisor
  const DataRow.divider({Key? key})
    : label = '',
      value = '',
      subLabel = null,
      valueSubLabel = null,
      valueColor = null,
      isTotal = false,
      isDivider = true,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    // Si es divisor, solo mostrar línea
    if (isDivider) {
      return Container(
        height: 1,
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: CupertinoColors.systemGrey5,
      );
    }

    // Determinar estilos según si es total
    final TextStyle labelStyle =
        isTotal ? AppTextStyle.bodyBold : AppTextStyle.body;

    final TextStyle valueStyle =
        isTotal
            ? AppTextStyle.bodyBold.copyWith(
              color: valueColor ?? AppColors.textPrimary,
              fontSize: 18,
            )
            : AppTextStyle.body.copyWith(
              color: valueColor ?? AppColors.textPrimary,
            );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Etiqueta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: labelStyle),
                if (subLabel != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subLabel!,
                    style: AppTextStyle.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Valor
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: valueStyle, textAlign: TextAlign.right),
              if (valueSubLabel != null) ...[
                const SizedBox(height: 4),
                Text(
                  valueSubLabel!,
                  style: AppTextStyle.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// Elemento para tarjeta de resumen
class SummaryItem {
  final String label;
  final String value;
  final Color? color;

  const SummaryItem({required this.label, required this.value, this.color});
}
