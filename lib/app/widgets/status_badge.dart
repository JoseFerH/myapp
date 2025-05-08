// lib/app/widgets/status_badge.dart

import 'package:flutter/cupertino.dart';
import '../utils/themes.dart';
import '../data/models/venta_model.dart';

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
        icon = CupertinoIcons.xmark_circle;
        break;
    }
    
    return StatusBadge(
      text: text,
      color: color,
      icon: icon,
      small: small,
      style: small ? BadgeStyle.light : BadgeStyle.filled,
    );
  }
  
  // Badge de nivel de stock
  static Widget nivelStock(int cantidad, int minimo, {bool small = false}) {
    // Calcular nivel basado en cantidad mínima
    final double ratio = cantidad / minimo;
    
    String text;
    Color color;
    IconData? icon;
    
    if (cantidad <= 0) {
      text = 'Agotado';
      color = CupertinoColors.systemRed;
      icon = CupertinoIcons.exclamationmark_circle;
    } else if (ratio <= 0.5) {
      text = 'Crítico';
      color = CupertinoColors.systemOrange;
      icon = CupertinoIcons.exclamationmark_triangle;
    } else if (ratio <= 1.0) {
      text = 'Bajo';
      color = CupertinoColors.systemYellow;
      icon = CupertinoIcons.arrow_down;
    } else {
      text = 'Normal';
      color = CupertinoColors.systemGreen;
      icon = CupertinoIcons.checkmark_circle;
    }
    
    return StatusBadge(
      text: text,
      color: color,
      icon: icon,
      small: small,
      style: small ? BadgeStyle.light : BadgeStyle.filled,
    );
  }
  
  // Badge de tipo de cliente
  static Widget tipoCliente(String tipo, {bool small = false}) {
    Color color;
    IconData? icon;
    
    switch (tipo.toLowerCase()) {
      case 'vip':
        color = CupertinoColors.systemYellow;
        icon = CupertinoIcons.star_fill;
        break;
      case 'frecuente':
        color = CupertinoColors.activeBlue;
        icon = CupertinoIcons.person_2_fill;
        break;
      case 'regular':
      default:
        color = CupertinoColors.systemGrey;
        icon = CupertinoIcons.person_fill;
        break;
    }
    
    return StatusBadge(
      text: tipo,
      color: color,
      icon: icon,
      small: small,
      style: BadgeStyle.light,
    );
  }
  
  // Badge personalizado con estilo predefinido
  static Widget custom({
    required String text, 
    required Color color,
    IconData? icon,
    bool small = false,
    BadgeStyle style = BadgeStyle.filled,
  }) {
    return StatusBadge(
      text: text,
      color: color,
      icon: icon,
      small: small,
      style: style,
    );
  }
}

// Enum para definir el estilo del badge
enum BadgeStyle {
  filled,    // Fondo de color sólido, texto blanco
  light,     // Fondo de color con opacidad, texto del color principal
  outlined,  // Fondo blanco, borde y texto del color principal
}