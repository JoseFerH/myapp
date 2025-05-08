// lib/app/widgets/custom_dropdown.dart

import 'package:flutter/cupertino.dart';
import '../utils/themes.dart';

/// Dropdown personalizado estilo iOS (Cupertino)
class CustomDropdown<T> extends StatelessWidget {
  // Título o etiqueta
  final String? title;
  
  // Lista de elementos
  final List<T> items;
  
  // Elemento seleccionado actualmente
  final T? selectedItem;
  
  // Callback al cambiar selección
  final Function(T?) onChanged;
  
  // Builder para mostrar cada item
  final Widget Function(T) itemBuilder;
  
  // Builder para mostrar el item seleccionado (opcional, usa itemBuilder por defecto)
  final Widget Function(T)? selectedItemBuilder;
  
  // Texto placeholder cuando no hay selección
  final String hint;
  
  // Mensaje de error
  final String? errorText;
  
  // Anchura máxima (null = expandirse)
  final double? maxWidth;
  
  // Si está deshabilitado
  final bool enabled;
  
  // Decoración personalizada
  final BoxDecoration? decoration;
  
  // Constructor
  const CustomDropdown({
    Key? key,
    this.title,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.itemBuilder,
    this.selectedItemBuilder,
    this.hint = 'Seleccione una opción',
    this.errorText,
    this.maxWidth,
    this.enabled = true,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título (opcional)
        if (title != null) ...[
          Text(
            title!,
            style: AppTextStyle.body,
          ),
          const SizedBox(height: AppDimensions.spacing8),
        ],
        
        // Botón de selección
        GestureDetector(
          onTap: enabled ? () => _showPicker(context) : null,
          child: Container(
            constraints: maxWidth != null 
                ? BoxConstraints(maxWidth: maxWidth!) 
                : null,
            decoration: decoration ?? BoxDecoration(
              color: enabled 
                  ? AppColors.secondaryBackground 
                  : AppColors.disabled.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
              border: Border.all(
                color: errorText != null 
                    ? AppColors.error 
                    : AppColors.border,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing16,
                vertical: AppDimensions.spacing12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Elemento seleccionado o placeholder
                  Expanded(
                    child: selectedItem != null
                        ? (selectedItemBuilder != null 
                            ? selectedItemBuilder!(selectedItem!) 
                            : itemBuilder(selectedItem!))
                        : Text(
                            hint,
                            style: AppTextStyle.body.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                  ),
                  
                  // Icono de desplegable
                  Icon(
                    CupertinoIcons.chevron_down,
                    size: AppDimensions.iconSizeSmall,
                    color: enabled 
                        ? AppColors.textSecondary 
                        : AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Mensaje de error (opcional)
        if (errorText != null) ...[
          const SizedBox(height: AppDimensions.spacing4),
          Text(
            errorText!,
            style: AppTextStyle.smallCaption.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }
  
  // Mostrar selector modal
  void _showPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                // Barra superior con botones
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      if (title != null)
                        Text(
                          title!,
                          style: AppTextStyle.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Listo'),
                      ),
                    ],
                  ),
                ),
                
                // Selector giratorio
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    onSelectedItemChanged: (int index) {
                      onChanged(items[index]);
                    },
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedItem != null 
                          ? items.indexOf(selectedItem!) 
                          : 0,
                    ),
                    children: items.map((item) => Center(
                      child: itemBuilder(item),
                    )).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // Versión para selección desde lista en lugar de selector giratorio
  static Future<T?> showAsListPicker<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required Widget Function(T) itemBuilder,
    T? selected,
  }) async {
    T? result = selected;
    
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTextStyle.title3,
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text('Cerrar'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.spacing16),
            
            // Lista de opciones
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = item == selected;
                  
                  return CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      result = item;
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.spacing12,
                        horizontal: AppDimensions.spacing8,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.border,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          itemBuilder(item),
                          if (isSelected)
                            const Icon(
                              CupertinoIcons.check_mark,
                              color: AppColors.primary,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
    
    return result;
  }
}