// lib/app/widgets/card_item.dart

import 'package:flutter/cupertino.dart';
import '../utils/themes.dart';

/// Widget para mostrar un ítem con estilo de tarjeta

class CardItem extends StatelessWidget {
  // Título de la tarjeta
  final String title;
  
  // Subtítulo (opcional)
  final String? subtitle;
  
  // Descripción (opcional)
  final String? description;
  
  // Widget de líder (por ejemplo, icono, imagen)
  final Widget? leading;
  
  // Widget de trailing (por ejemplo, botón, contador)
  final Widget? trailing;
  
  // Acción al presionar
  final VoidCallback? onTap;
  
  // Si debe tener efecto de presionar
  final bool hasPressEffect;
  
  // Decoración personalizada
  final BoxDecoration? decoration;
  
  // Padding interno
  final EdgeInsetsGeometry padding;
  
  // Constructor
  const CardItem({
    Key? key,
    required this.title,
    this.subtitle,
    this.description,
    this.leading,
    this.trailing,
    this.onTap,
    this.hasPressEffect = true,
    this.decoration,
    this.padding = const EdgeInsets.all(16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: decoration ?? BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Widget líder (opcional)
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 16),
          ],
          
          // Contenido central
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  title,
                  style: AppTextStyle.bodyBold,
                ),
                
                // Subtítulo (opcional)
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: AppTextStyle.caption,
                  ),
                ],
                
                // Descripción (opcional)
                if (description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    description!,
                    style: AppTextStyle.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          
          // Widget trailing (opcional)
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
    
    // Si hay acción al presionar, hacerlo interactivo
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: hasPressEffect
            ? _buildPressEffectWrapper(content)
            : content,
      );
    }
    
    return content;
  }
  
  // Envolver con efecto de presionar
  Widget _buildPressEffectWrapper(Widget child) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: child,
    );
  }
  
  // Variantes estáticas
  
  // Ítem con símbolo de valor
  static Widget withValue({
    required String title,
    String? subtitle,
    required String value,
    String? valueSubtitle,
    Color? valueColor,
    Widget? leading,
    VoidCallback? onTap,
  }) {
    return CardItem(
      title: title,
      subtitle: subtitle,
      leading: leading,
      onTap: onTap,
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTextStyle.bodyBold.copyWith(
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
          if (valueSubtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              valueSubtitle,
              style: AppTextStyle.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  // Ítem con icono de flecha (utilizado para navegación)
  static Widget withArrow({
    required String title,
    String? subtitle,
    String? description,
    Widget? leading,
    required VoidCallback onTap,
  }) {
    return CardItem(
      title: title,
      subtitle: subtitle,
      description: description,
      leading: leading,
      onTap: onTap,
      trailing: const Icon(
        CupertinoIcons.chevron_right,
        color: AppColors.textTertiary,
        size: 20,
      ),
    );
  }
  
  // Ítem con un interruptor (switch)
  static Widget withSwitch({
    required String title,
    String? subtitle,
    Widget? leading,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return CardItem(
      title: title,
      subtitle: subtitle,
      leading: leading,
      hasPressEffect: false,
      trailing: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }
  
  // Ítem con una insignia de estado
  static Widget withStatus({
    required String title,
    String? subtitle,
    required String status,
    required Color statusColor,
    Widget? leading,
    VoidCallback? onTap,
  }) {
    return CardItem(
      title: title,
      subtitle: subtitle,
      leading: leading,
      onTap: onTap,
      trailing: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          status,
          style: AppTextStyle.caption.copyWith(
            color: statusColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}