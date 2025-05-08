// lib/app/widgets/error_message.dart

import 'package:flutter/cupertino.dart';
import '../utils/themes.dart';

/// Widget para mostrar mensajes de error con diferentes estilos

class ErrorMessage extends StatelessWidget {
  // Mensaje de error
  final String message;
  
  // Acción al reintentar (opcional)
  final VoidCallback? onRetry;
  
  // Título del error (opcional)
  final String? title;
  
  // Icono personalizado (opcional)
  final IconData? icon;
  
  // Si muestra un layout compacto
  final bool compact;
  
  // Si el error debe ocupar la pantalla completa
  final bool fullScreen;

  // Constructor
  const ErrorMessage({
    Key? key,
    required this.message,
    this.onRetry,
    this.title,
    this.icon,
    this.compact = false,
    this.fullScreen = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget errorContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: fullScreen ? MainAxisSize.max : MainAxisSize.min,
      children: [
        // Icono
        Icon(
          icon ?? CupertinoIcons.exclamationmark_triangle,
          color: AppColors.error,
          size: compact ? 40.0 : 60.0,
        ),
        
        SizedBox(height: compact ? 12.0 : 16.0),
        
        // Título (opcional)
        if (title != null) ...[
          Text(
            title!,
            style: compact ? AppTextStyle.bodyBold : AppTextStyle.title3,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: compact ? 8.0 : 12.0),
        ],
        
        // Mensaje de error
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyle.body.copyWith(
            fontSize: compact ? 14.0 : 16.0,
            color: AppColors.textSecondary,
          ),
        ),
        
        // Botón de reintentar (opcional)
        if (onRetry != null) ...[
          SizedBox(height: compact ? 16.0 : 24.0),
          CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: const Text('Reintentar'),
            onPressed: onRetry,
          ),
        ],
      ],
    );
    
    // Si es pantalla completa, centrar en la pantalla
    if (fullScreen) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: errorContent,
        ),
      );
    } 
    
    // Si no es pantalla completa, mostrar como un contenedor
    return Container(
      padding: EdgeInsets.all(compact ? 12.0 : 16.0),
      margin: EdgeInsets.all(compact ? 8.0 : 16.0),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: errorContent,
    );
  }
  
  // Variantes predefinidas
  
  // Error de conexión
  static Widget networkError({
    required VoidCallback onRetry,
    bool compact = false,
  }) {
    return ErrorMessage(
      title: 'Error de conexión',
      message: 'No se pudo conectar al servidor. Por favor verifica tu conexión a internet e intenta nuevamente.',
      icon: CupertinoIcons.wifi_slash,
      onRetry: onRetry,
      compact: compact,
    );
  }
  
  // Error de permisos
  static Widget permissionError({
    required String permission,
    VoidCallback? onRetry,
    bool compact = false,
  }) {
    return ErrorMessage(
      title: 'Permiso requerido',
      message: 'No se tiene permiso para acceder a $permission. Por favor otorga los permisos necesarios para continuar.',
      icon: CupertinoIcons.lock,
      onRetry: onRetry,
      compact: compact,
    );
  }
  
  // Error de validación
  static Widget validationError({
    required String message,
    bool compact = false,
  }) {
    return ErrorMessage(
      message: message,
      icon: CupertinoIcons.exclamationmark_circle,
      compact: compact,
      fullScreen: false,
    );
  }
}