// lib/app/widgets/confirmation_dialog.dart

import 'package:flutter/cupertino.dart';
import '../utils/themes.dart';

/// Dialog de confirmación estilo iOS (Cupertino)

class ConfirmationDialog extends StatelessWidget {
  // Título del dialog
  final String title;
  
  // Mensaje o contenido
  final String message;
  
  // Texto del botón de cancelar
  final String cancelText;
  
  // Texto del botón de confirmar
  final String confirmText;
  
  // Acciones a ejecutar
  final VoidCallback? onCancel;
  final VoidCallback onConfirm;
  
  // Tipo de diálogo (afecta colores)
  final DialogType type;
  
  // Constructor
  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    this.cancelText = 'Cancelar',
    required this.confirmText,
    this.onCancel,
    required this.onConfirm,
    this.type = DialogType.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        style: AppTextStyle.title3,
      ),
      content: Text(
        message,
        style: AppTextStyle.body,
      ),
      actions: [
        // Botón de cancelar (opcional)
        if (onCancel != null)
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
              onCancel?.call();
            },
            child: Text(cancelText),
          ),
        
        // Botón de confirmar
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          isDefaultAction: type == DialogType.normal,
          isDestructiveAction: type == DialogType.destructive,
          child: Text(
            confirmText,
            style: TextStyle(
              color: _getConfirmButtonColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  
  // Obtener color según el tipo de diálogo
  Color _getConfirmButtonColor() {
    switch (type) {
      case DialogType.normal:
        return AppColors.primary;
      case DialogType.destructive:
        return AppColors.error;
      case DialogType.success:
        return AppColors.success;
      case DialogType.warning:
        return AppColors.warning;
    }
  }
  
  // Mostrar el diálogo de confirmación
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String cancelText = 'Cancelar',
    required String confirmText,
    VoidCallback? onCancel,
    required VoidCallback onConfirm,
    DialogType type = DialogType.normal,
  }) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        cancelText: cancelText,
        confirmText: confirmText,
        onCancel: onCancel,
        onConfirm: onConfirm,
        type: type,
      ),
    );
  }
  
  // Métodos estáticos para diálogos específicos
  
  // Diálogo de eliminación
  static Future<void> showDelete({
    required BuildContext context,
    required String itemType,
    required String itemName,
    required VoidCallback onConfirmDelete,
  }) {
    return show(
      context: context,
      title: 'Confirmar Eliminación',
      message: '¿Está seguro que desea eliminar ${itemType.toLowerCase()} "$itemName"?',
      confirmText: 'Eliminar',
      onConfirm: onConfirmDelete,
      type: DialogType.destructive,
    );
  }
  
  // Diálogo de guardado
  static Future<void> showSave({
    required BuildContext context,
    required String message,
    required VoidCallback onConfirmSave,
  }) {
    return show(
      context: context,
      title: 'Guardar Cambios',
      message: message,
      confirmText: 'Guardar',
      onConfirm: onConfirmSave,
      type: DialogType.normal,
    );
  }
  
  // Diálogo de acción importante
  static Future<void> showImportantAction({
    required BuildContext context,
    required String title,
    required String message,
    required String actionText,
    required VoidCallback onConfirmAction,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      confirmText: actionText,
      onConfirm: onConfirmAction,
      type: DialogType.warning,
    );
  }
  
  // Diálogo de éxito con acción opcional
  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String? actionText,
    VoidCallback? onAction,
  }) {
    if (actionText != null && onAction != null) {
      return show(
        context: context,
        title: title,
        message: message,
        cancelText: 'Cerrar',
        confirmText: actionText,
        onCancel: () {},
        onConfirm: onAction,
        type: DialogType.success,
      );
    } else {
      // Solo mostrar mensaje sin acciones
      return showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  
  // Diálogo de error
  static Future<void> showError({
    required BuildContext context,
    String title = 'Error',
    required String message,
  }) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Tipos de diálogo para afectar apariencia
enum DialogType {
  normal,        // Diálogo estándar (azul)
  destructive,   // Acción destructiva (rojo)
  success,       // Acción exitosa (verde)
  warning,       // Advertencia (naranja)
}

// Diálogo para selección simple de opciones
class SelectionDialog<T> extends StatelessWidget {
  // Título del diálogo
  final String title;
  
  // Mensaje opcional
  final String? message;
  
  // Lista de opciones
  final List<SelectionOption<T>> options;
  
  // Opción seleccionada actualmente
  final T? selectedValue;
  
  // Función que se ejecuta al seleccionar una opción
  final Function(T) onSelect;
  
  // Constructor
  const SelectionDialog({
    Key? key,
    required this.title,
    this.message,
    required this.options,
    this.selectedValue,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              style: AppTextStyle.body,
            ),
            const SizedBox(height: 16),
          ],
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: options.map((option) {
                  final bool isSelected = option.value == selectedValue;
                  
                  return CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onSelect(option.value);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option.label,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              if (option.description != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  option.description!,
                                  style: AppTextStyle.caption.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            CupertinoIcons.check_mark,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
  
  // Mostrar el diálogo
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? message,
    required List<SelectionOption<T>> options,
    T? selectedValue,
    required Function(T) onSelect,
  }) async {
    return showCupertinoDialog<T?>(
      context: context,
      builder: (context) => SelectionDialog<T>(
        title: title,
        message: message,
        options: options,
        selectedValue: selectedValue,
        onSelect: onSelect,
      ),
    );
  }
}

// Opción para el diálogo de selección
class SelectionOption<T> {
  final String label;
  final String? description;
  final T value;
  
  const SelectionOption({
    required this.label,
    this.description,
    required this.value,
  });
}