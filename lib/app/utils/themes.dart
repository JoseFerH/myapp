// lib/app/utils/themes.dart

import 'package:flutter/cupertino.dart';

/// Tema y estilos para la aplicación Cupertino (iOS)

// Colores de la aplicación
class AppColors {
  // Colores primarios
  static const Color primary = Color(0xFF007AFF);          // Azul iOS
  static const Color secondary = Color(0xFF5AC8FA);        // Azul secundario iOS
  static const Color accent = Color(0xFF5856D6);           // Púrpura iOS
  
  // Colores semánticos
  static const Color success = Color(0xFF4CD964);          // Verde iOS
  static const Color warning = Color(0xFFFF9500);          // Naranja iOS
  static const Color error = Color(0xFFFF3B30);            // Rojo iOS
  static const Color info = Color(0xFF5AC8FA);             // Azul claro iOS
  
  // Colores de fondo
  static const Color background = CupertinoColors.systemBackground;
  static const Color cardBackground = CupertinoColors.white;
  static const Color secondaryBackground = CupertinoColors.systemGrey6;
  
  // Colores de texto
  static const Color textPrimary = CupertinoColors.label;
  static const Color textSecondary = CupertinoColors.secondaryLabel;
  static const Color textTertiary = CupertinoColors.tertiaryLabel;
  
  // Colores de borde
  static const Color border = CupertinoColors.systemGrey5;
  static const Color divider = CupertinoColors.systemGrey4;
  
  // Color para elementos deshabilitados
  static const Color disabled = CupertinoColors.systemGrey4;
  
  // Sombras
  static const Color shadowColor = Color(0x1A000000);
}

// Tema principal de la aplicación
class AppTheme {
  // Tema principal
  static CupertinoThemeData get theme {
    return const CupertinoThemeData(
      primaryColor: AppColors.primary,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: CupertinoTextThemeData(
        primaryColor: AppColors.textPrimary,
        textStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontFamily: 'SF Pro Display',
        ),
      ),
    );
  }
  
  // Tema oscuro (por si se implementa en el futuro)
  static CupertinoThemeData get darkTheme {
    return const CupertinoThemeData(
      primaryColor: AppColors.primary,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: CupertinoColors.black,
      textTheme: CupertinoTextThemeData(
        primaryColor: CupertinoColors.white,
        textStyle: TextStyle(
          color: CupertinoColors.white,
          fontSize: 16,
          fontFamily: 'SF Pro Display',
        ),
      ),
    );
  }
}

// Estilos de texto predefinidos
class AppTextStyle {
  // Estilos para títulos
  static const TextStyle title1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontFamily: 'SF Pro Display',
    color: AppColors.textPrimary,
  );
  
  static const TextStyle title2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontFamily: 'SF Pro Display',
    color: AppColors.textPrimary,
  );
  
  static const TextStyle title3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: 'SF Pro Display',
    color: AppColors.textPrimary,
  );
  
  // Estilos para cuerpos de texto
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontFamily: 'SF Pro Text',
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: 'SF Pro Text',
    color: AppColors.textPrimary,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontFamily: 'SF Pro Text',
    color: AppColors.textSecondary,
  );
  
  static const TextStyle smallCaption = TextStyle(
    fontSize: 12,
    fontFamily: 'SF Pro Text',
    color: AppColors.textTertiary,
  );
}

// Decoración para containers y cards
class AppDecoration {
  // Card estándar
  static BoxDecoration card = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: AppColors.border),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowColor,
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  // Contenedor simple
  static BoxDecoration container = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColors.border),
  );
  
  // Contenedor de selección
  static BoxDecoration selectionContainer = BoxDecoration(
    color: AppColors.secondaryBackground,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColors.border),
  );
  
  // Contenedor con borde de estado (success, warning, error)
  static BoxDecoration statusContainer(Color color) {
    return BoxDecoration(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color),
    );
  }
}

// Dimensiones y espaciados estándar
class AppDimensions {
  // Espaciados
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  
  // Radios de bordes
  static const double borderRadius4 = 4.0;
  static const double borderRadius8 = 8.0;
  static const double borderRadius12 = 12.0;
  static const double borderRadius16 = 16.0;
  
  // Iconos
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  
  // Alturas estándar
  static const double buttonHeight = 48.0;
  static const double inputHeight = 44.0;
  static const double cardMinHeight = 80.0;
}