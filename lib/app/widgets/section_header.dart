// lib/app/widgets/section_header.dart

import 'package:flutter/cupertino.dart';
import '../utils/themes.dart';

/// Widget para encabezados de sección con estilos consistentes

class SectionHeader extends StatelessWidget {
  // Título de la sección
  final String title;
  
  // Subtítulo opcional
  final String? subtitle;
  
  // Acción opcional al extremo derecho
  final Widget? action;
  
  // Icono opcional
  final IconData? icon;
  
  // Padding personalizado
  final EdgeInsetsGeometry padding;
  
  // Si tiene borde inferior
  final bool hasDivider;
  
  // Estilo del título
  final TextStyle? titleStyle;
  
  // Constructor
  const SectionHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.action,
    this.icon,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 12.0,
    ),
    this.hasDivider = true,
    this.titleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: hasDivider ? Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: 0.5,
          ),
        ) : null,
      ),
      child: Row(
        children: [
          // Icono (opcional)
          if (icon != null) ...[
            Icon(
              icon,
              color: AppColors.primary,
              size: 22,
            ),
            const SizedBox(width: 10),
          ],
          
          // Título y subtítulo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  title,
                  style: titleStyle ?? AppTextStyle.title3,
                ),
                
                // Subtítulo (opcional)
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
          
          // Acción (opcional)
          if (action != null) action!,
        ],
      ),
    );
  }
  
  // Crear con acción de ver todos
  static Widget withViewAll({
    required String title,
    String? subtitle,
    IconData? icon,
    required VoidCallback onViewAll,
    String viewAllText = 'Ver todos',
  }) {
    return SectionHeader(
      title: title,
      subtitle: subtitle,
      icon: icon,
      action: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Text(
          viewAllText,
          style: AppTextStyle.body.copyWith(
            color: AppColors.primary,
          ),
        ),
        onPressed: onViewAll,
      ),
    );
  }
  
  // Crear para encabezado de formulario
  static Widget form({
    required String title,
    String? subtitle,
    Widget? action,
  }) {
    return SectionHeader(
      title: title,
      subtitle: subtitle,
      action: action,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      hasDivider: false,
      titleStyle: AppTextStyle.title2,
    );
  }
}