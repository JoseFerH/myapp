// lib/app/widgets/status_badge.dart

import 'package:flutter/cupertino.dart';
import '../utils/themes.dart';

/// Widget para mostrar estados con insignias coloreadas

class StatusBadge extends StatelessWidget {
  // Texto a mostrar
  final String text;
  
  // Color principal
  final Color color;
  
  // Icono opcional
  final IconData? icon;
  
  // Si es de tamaño pequeño
  final bool small;
  
  // Estilo de borde
  final BadgeStyle style;
  
  // Constructor
  const StatusBadge({
    Key? key,
    required this.text,
    required this.color,
    this.icon,
    this.small = false,
    this.style = BadgeStyle.filled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determinar colores según estilo
    Color backgroundColor;
    Color textColor;
    
    switch (style) {
      case BadgeStyle.filled:
        backgroundColor = color;
        textColor = CupertinoColors.white;
        break;
      case BadgeStyle.light:
        backgroundColor = color.withOpacity(0.1);
        textColor = color;
        break;
      case BadgeStyle.outlined:
        backgroundColor = CupertinoColors.white;
        textColor = color;
        break;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8.0 : 10.0,
        vertical: small ? 2.0 : 4.0,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(small ? 10.0 : 12.0),
        border: style == BadgeStyle.outlined
            ? Border.all(color: color)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: textColor,
              size: small ? 10.0 : 14.0,
            ),
            SizedBox(width: small ? 4.0 : 6.0),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: small ? 10.0 : 12.0,
            ),
          ),
        ],
      ),
    );
  }
  
  // Badge de estado de venta
  static Widget estadoVenta(EstadoVenta estado, {bool small = false}) {
    // Configuración según estado
    String text;
    Color color;
    IconData? icon;
    
    switch (estado) {
      case EstadoVenta.cotizacion:
        text = 'Cotización';
        color = CupertinoColors.systemBlue;
        icon = CupertinoIcons.doc_text;
        break;
      case EstadoVenta.pendiente:
        text = 'Pendiente';
        color = CupertinoColors.systemOrange;
        icon = CupertinoIcons.clock;
        break;
      case EstadoVenta.completada:
        text = 'Completada';
        color = CupertinoColors.systemGreen;
        icon = CupertinoIcons.check_mark;
        break;
      case EstadoVenta.cancelada:
        text = 'Cancelada';
        color = CupertinoColors.systemRed;