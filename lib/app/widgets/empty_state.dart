// lib/app/widgets/empty_state.dart

import 'package:flutter/cupertino.dart';
import '../utils/themes.dart';

/// Widget para mostrar estado vacío con diferentes estilos

class EmptyState extends StatelessWidget {
  // Título principal
  final String title;
  
  // Mensaje descriptivo
  final String message;
  
  // Icono a mostrar
  final IconData icon;
  
  // Color del icono
  final Color? iconColor;
  
  // Tamaño del icono
  final double iconSize;
  
  // Texto del botón (opcional)
  final String? buttonText;
  
  // Acción al presionar el botón
  final VoidCallback? onButtonPressed;
  
  // Si usa un estilo compacto (menos espacio)
  final bool compact;
  
  // Imagen en lugar de icono (opcional)
  final Widget? image;
  
  // Constructor
  const EmptyState({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
    this.iconColor,
    this.iconSize = 80,
    this.buttonText,
    this.onButtonPressed,
    this.compact = false,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? 16.0 : 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icono o imagen
            if (image != null) 
              image!
            else
              Icon(
                icon,
                size: iconSize,
                color: iconColor ?? AppColors.textSecondary,
              ),
            
            SizedBox(height: compact ? 16.0 : 24.0),
            
            // Título
            Text(
              title,
              style: compact ? AppTextStyle.title3 : AppTextStyle.title2,
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: compact ? 8.0 : 12.0),
            
            // Mensaje
            Text(
              message,
              style: AppTextStyle.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Botón (opcional)
            if (buttonText != null && onButtonPressed != null) ...[
              SizedBox(height: compact ? 24.0 : 32.0),
              
              CupertinoButton.filled(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 16.0 : 24.0,
                  vertical: compact ? 10.0 : 12.0,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
                child: Text(buttonText!),
                onPressed: onButtonPressed,
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  // Variantes predefinidas
  
  // Estado sin resultados
  static Widget noResults({
    required String message,
    required VoidCallback onResetFilters,
    bool compact = false,
  }) {
    return EmptyState(
      title: 'No hay resultados',
      message: message,
      icon: CupertinoIcons.search,
      buttonText: 'Limpiar filtros',
      onButtonPressed: onResetFilters,
      compact: compact,
    );
  }
  
  // Estado sin datos
  static Widget noData({
    required String title,
    required String message,
    required IconData icon,
    String? buttonText,
    VoidCallback? onButtonPressed,
    bool compact = false,
  }) {
    return EmptyState(
      title: title,
      message: message,
      icon: icon,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      compact: compact,
    );
  }
  
  // Estado de error
  static Widget error({
    String title = 'Algo salió mal',
    required String message,
    String buttonText = 'Intentar de nuevo',
    required VoidCallback onRetry,
    bool compact = false,
  }) {
    return EmptyState(
      title: title,
      message: message,
      icon: CupertinoIcons.exclamationmark_triangle,
      iconColor: AppColors.error,
      buttonText: buttonText,
      onButtonPressed: onRetry,
      compact: compact,
    );
  }
  
  // Estado de construcción
  static Widget underConstruction({
    String title = 'En construcción',
    String message = 'Esta funcionalidad estará disponible próximamente',
    bool compact = false,
  }) {
    return EmptyState(
      title: title,
      message: message,
      icon: CupertinoIcons.hammer,
      compact: compact,
    );
  }
}