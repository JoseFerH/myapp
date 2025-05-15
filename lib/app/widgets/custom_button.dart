// lib/app/widgets/custom_button.dart

import 'package:flutter/cupertino.dart';
import '../utils/themes.dart';

/// Botón personalizado con estilo coherente para la app

class CustomButton extends StatelessWidget {
  // Texto del botón
  final String text;

  // Acción al presionar
  final VoidCallback? onPressed;

  // Si es botón secundario (gris) en lugar de primario (azul)
  final bool isSecondary;

  // Si está en estado de carga
  final bool isLoading;

  // Si ocupa todo el ancho disponible
  final bool isFullWidth;

  // Icono opcional
  final IconData? icon;

  // Tipo de botón (afecta el estilo)
  final ButtonType type;

  // Tamaño del botón
  final ButtonSize size;

  // Padding interno
  final EdgeInsetsGeometry? padding;

  // Constructor
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.type = ButtonType.filled,
    this.size = ButtonSize.regular,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determinar colores según tipo y estado
    final Color backgroundColor = _getBackgroundColor();
    final Color textColor = _getTextColor();

    // Determinar padding según tamaño
    final EdgeInsetsGeometry buttonPadding = padding ?? _getPadding();

    // Determinar contenido del botón
    Widget buttonContent = _buildButtonContent(textColor);

    // Construir el botón según el tipo
    switch (type) {
      case ButtonType.filled:
        return _buildFilledButton(
          backgroundColor,
          buttonPadding,
          buttonContent,
        );
      case ButtonType.outlined:
        return _buildOutlinedButton(
          backgroundColor,
          textColor,
          buttonPadding,
          buttonContent,
        );
      case ButtonType.text:
        return _buildTextButton(textColor, buttonPadding, buttonContent);
    }
  }

  // Construir botón relleno
  Widget _buildFilledButton(
    Color backgroundColor,
    EdgeInsetsGeometry padding,
    Widget content,
  ) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: CupertinoButton(
        padding: padding,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
        onPressed: isLoading ? null : onPressed,
        disabledColor: AppColors.disabled,
        child: content,
      ),
    );
  }

  // Construir botón con borde
  Widget _buildOutlinedButton(
    Color borderColor,
    Color textColor,
    EdgeInsetsGeometry padding,
    Widget content,
  ) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: CupertinoButton(
        padding: padding,
        onPressed: isLoading ? null : onPressed,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: onPressed == null ? AppColors.disabled : borderColor,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
          ),
          padding: padding,
          child: content,
        ),
      ),
    );
  }

  // Construir botón de texto
  Widget _buildTextButton(
    Color textColor,
    EdgeInsetsGeometry padding,
    Widget content,
  ) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: CupertinoButton(
        padding: padding,
        onPressed: isLoading ? null : onPressed,
        child: content,
      ),
    );
  }

  // Construir contenido del botón (texto, icono, spinner)
  Widget _buildButtonContent(Color textColor) {
    // Determinar color del indicador de carga según tipo de botón
    // Siempre usar blanco para botones con fondo de color
    final Color loadingColor =
        type == ButtonType.filled ? CupertinoColors.white : textColor;

    if (isLoading) {
      return CupertinoActivityIndicator(color: loadingColor);
    }

    if (icon != null) {
      return Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: _getIconSize()),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: _getFontSize(),
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: _getFontSize(),
      ),
    );
  }

  // Obtener el color de fondo según tipo y estado
  Color _getBackgroundColor() {
    if (onPressed == null) {
      return AppColors.disabled;
    }

    if (isSecondary) {
      switch (type) {
        case ButtonType.filled:
          return AppColors.secondaryBackground;
        case ButtonType.outlined:
        case ButtonType.text:
          return CupertinoColors.transparent;
      }
    } else {
      switch (type) {
        case ButtonType.filled:
          return AppColors.primary;
        case ButtonType.outlined:
        case ButtonType.text:
          return CupertinoColors.transparent;
      }
    }
  }

  // Obtener color de texto según tipo y estado
  Color _getTextColor() {
    if (onPressed == null) {
      return AppColors.textTertiary;
    }

    if (isSecondary) {
      switch (type) {
        case ButtonType.filled:
          // Usar color oscuro para botones secundarios con fondo claro
          return AppColors.textPrimary;
        case ButtonType.outlined:
        case ButtonType.text:
          return AppColors.textSecondary;
      }
    } else {
      switch (type) {
        case ButtonType.filled:
          // SIEMPRE usar texto blanco para botones con fondo de color
          return CupertinoColors.white;
        case ButtonType.outlined:
        case ButtonType.text:
          return AppColors.primary;
      }
    }
  }

  // Obtener padding según tamaño
  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ButtonSize.regular:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    }
  }

  // Obtener tamaño de fuente según tamaño del botón
  double _getFontSize() {
    switch (size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.regular:
        return 16;
      case ButtonSize.large:
        return 18;
    }
  }

  // Obtener tamaño de icono según tamaño del botón
  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.regular:
        return 18;
      case ButtonSize.large:
        return 22;
    }
  }
}

// Tamaños de botón
enum ButtonSize {
  small, // Pequeño (útil para acciones secundarias)
  regular, // Tamaño estándar
  large, // Grande (para acciones principales)
}

// Tipos de botón
enum ButtonType {
  filled, // Botón con fondo (primario)
  outlined, // Botón con borde
  text, // Botón solo texto
}

// Botones especializados

// Botón de acción primaria
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isFullWidth;
  final ButtonSize size;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
    this.size = ButtonSize.regular,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      isFullWidth: isFullWidth,
      type: ButtonType.filled,
      size: size,
    );
  }
}

// Botón de acción secundaria
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isFullWidth;
  final ButtonSize size;

  const SecondaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
    this.size = ButtonSize.regular,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isSecondary: true,
      isLoading: isLoading,
      icon: icon,
      isFullWidth: isFullWidth,
      type: ButtonType.filled,
      size: size,
    );
  }
}

// Botón con borde
class OutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isFullWidth;
  final bool isSecondary;
  final ButtonSize size;

  const OutlinedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
    this.isSecondary = false,
    this.size = ButtonSize.regular,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isSecondary: isSecondary,
      isLoading: isLoading,
      icon: icon,
      isFullWidth: isFullWidth,
      type: ButtonType.outlined,
      size: size,
    );
  }
}

// Botón de texto
class TextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isSecondary;
  final ButtonSize size;

  const TextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isSecondary = false,
    this.size = ButtonSize.regular,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isSecondary: isSecondary,
      isLoading: isLoading,
      icon: icon,
      isFullWidth: false,
      type: ButtonType.text,
      size: size,
    );
  }
}

// Botón de icono (cuadrado o circular)
class IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isSecondary;
  final bool isCircular;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const IconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.isSecondary = false,
    this.isCircular = false,
    this.size = 40,
    this.backgroundColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Garantizar alto contraste: si hay fondo de color, usar icono blanco por defecto
    final Color bgColor =
        backgroundColor ??
        (isSecondary ? AppColors.secondaryBackground : AppColors.primary);

    final Color fgColor =
        iconColor ??
        (isSecondary ? AppColors.textPrimary : CupertinoColors.white);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius:
              isCircular
                  ? null
                  : BorderRadius.circular(AppDimensions.borderRadius8),
        ),
        child: Center(child: Icon(icon, color: fgColor, size: size * 0.5)),
      ),
    );
  }
}
