// lib/app/widgets/loading_indicator.dart

import 'package:flutter/cupertino.dart';
import '../utils/themes.dart';

/// Widget para mostrar indicadores de carga con estilos coherentes

class LoadingIndicator extends StatelessWidget {
  // Mensaje opcional
  final String? message;
  
  // Tamaño del indicador
  final double size;
  
  // Color del indicador (para usar un color diferente al de tema)
  final Color? color;
  
  // Si debe mostrar fondo transparente o con blur
  final bool transparent;
  
  // Si debe ocupar toda la pantalla o ser inline
  final bool fullScreen;
  
  // Constructor
  const LoadingIndicator({
    Key? key,
    this.message,
    this.size = 20.0,
    this.color,
    this.transparent = false,
    this.fullScreen = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget loadingContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: fullScreen ? MainAxisSize.max : MainAxisSize.min,
      children: [
        // Spinner
        CupertinoActivityIndicator(
          radius: size,
          color: color,
        ),
        
        // Mensaje (opcional)
        if (message != null) ...[
          const SizedBox(height: 16.0),
          Text(
            message!,
            textAlign: TextAlign.center,
            style: AppTextStyle.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
    
    // Si debe ocupar toda la pantalla
    if (fullScreen) {
      if (transparent) {
        return Center(
          child: loadingContent,
        );
      }
      
      // Con fondo y blur
      return Container(
        color: CupertinoColors.systemBackground.withOpacity(0.7),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 24.0,
            ),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.black.withOpacity(0.1),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: loadingContent,
          ),
        ),
      );
    }
    
    // Versión inline (no pantalla completa)
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: loadingContent,
    );
  }
  
  // Variantes predefinidas
  
  // Indicador de carga de página
  static Widget pageLoading({String? message}) {
    return LoadingIndicator(
      message: message ?? 'Cargando...',
      size: 20.0,
      transparent: true,
    );
  }
  
  // Indicador de carga de modal
  static Widget modalLoading({String? message}) {
    return LoadingIndicator(
      message: message,
      size: 20.0,
      transparent: false,
      fullScreen: true,
    );
  }
  
  // Indicador pequeño (para botones o elementos de UI)
  static Widget smallLoading({Color? color}) {
    return LoadingIndicator(
      size: 12.0,
      color: color,
      transparent: true,
      fullScreen: false,
    );
  }
  
  // Overlay para operaciones largas
  static OverlayEntry createOverlay({
    required BuildContext context,
    String? message,
  }) {
    return OverlayEntry(
      builder: (context) => LoadingIndicator(
        message: message,
        transparent: false,
      ),
    );
  }
}