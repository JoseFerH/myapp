// lib/app/widgets/custom_textfield.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../utils/themes.dart';

/// TextField personalizado con estilos coherentes para la app

class CustomTextField extends StatefulWidget {
  // Controlador para el campo
  final TextEditingController? controller;
  
  // Texto de placeholder
  final String? placeholder;
  
  // Etiqueta encima del campo
  final String? label;
  
  // Texto de ayuda debajo del campo
  final String? helperText;
  
  // Mensaje de error
  final String? errorText;
  
  // Función de validación
  final String? Function(String?)? validator;
  
  // Tipo de teclado
  final TextInputType keyboardType;
  
  // Tipo de capitalización
  final TextCapitalization textCapitalization;
  
  // Formatters para el input
  final List<TextInputFormatter>? inputFormatters;
  
  // Texto autocorrección
  final bool autocorrect;
  
  // Prefijo (por ejemplo, para moneda)
  final Widget? prefix;
  
  // Sufijo (por ejemplo, para iconos de acción)
  final Widget? suffix;
  
  // Obscurecer texto (para contraseñas)
  final bool obscureText;
  
  // Número máximo de líneas
  final int? maxLines;
  
  // Número mínimo de líneas
  final int? minLines;
  
  // Longitud máxima de texto
  final int? maxLength;
  
  // Acción al cambiar texto
  final ValueChanged<String>? onChanged;
  
  // Acción al enviar
  final ValueChanged<String>? onSubmitted;
  
  // Acción al enfocar el campo
  final VoidCallback? onFocus;
  
  // Acción al perder el foco
  final VoidCallback? onBlur;
  
  // Solo lectura
  final bool readOnly;
  
  // Autofocus
  final bool autofocus;
  
  // Habilitado/Deshabilitado
  final bool enabled;
  
  // Padding interno
  final EdgeInsetsGeometry padding;
  
  // Constructor
  const CustomTextField({
    Key? key,
    this.controller,
    this.placeholder,
    this.label,
    this.helperText,
    this.errorText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autocorrect = false,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.onFocus,
    this.onBlur,
    this.readOnly = false,
    this.autofocus = false,
    this.enabled = true,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // Estado local para manejo de errores
  late String? _errorText;
  final FocusNode _focusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    _errorText = widget.errorText;
    
    // Configurar focus node
    _focusNode.addListener(_handleFocusChange);
  }
  
  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Actualizar error si cambió desde fuera
    if (widget.errorText != oldWidget.errorText) {
      setState(() {
        _errorText = widget.errorText;
      });
    }
  }
  
  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }
  
  // Manejar cambios de foco
  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      widget.onFocus?.call();
    } else {
      widget.onBlur?.call();
      // Validar al perder foco si hay validador
      if (widget.validator != null && widget.controller != null) {
        setState(() {
          _errorText = widget.validator!(widget.controller!.text);
        });
      }
    }
  }
  
  // Validar input al cambiar
  void _handleOnChanged(String value) {
    // Llamar al callback externo si existe
    widget.onChanged?.call(value);
    
    // Validar si hay validador
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Etiqueta (opcional)
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyle.body,
          ),
          const SizedBox(height: AppDimensions.spacing8),
        ],
        
        // Campo de texto
        CupertinoTextField(
          controller: widget.controller,
          focusNode: _focusNode,
          placeholder: widget.placeholder,
          placeholderStyle: AppTextStyle.caption.copyWith(
            color: AppColors.textTertiary,
          ),
          prefix: widget.prefix,
          suffix: widget.suffix,
          padding: widget.padding,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          inputFormatters: widget.inputFormatters,
          autocorrect: widget.autocorrect,
          obscureText: widget.obscureText,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          onChanged: _handleOnChanged,
          onSubmitted: widget.onSubmitted,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          decoration: BoxDecoration(
            color: widget.enabled 
                ? AppColors.secondaryBackground 
                : AppColors.disabled.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
            border: Border.all(
              color: _errorText != null 
                  ? AppColors.error 
                  : (_focusNode.hasFocus 
                      ? AppColors.primary 
                      : AppColors.border),
            ),
          ),
          style: AppTextStyle.body.copyWith(
            color: widget.enabled 
                ? AppColors.textPrimary 
                : AppColors.textTertiary,
          ),
        ),
        
        // Mensaje de error o ayuda
        if (_errorText != null || widget.helperText != null) ...[
          const SizedBox(height: AppDimensions.spacing4),
          Text(
            _errorText ?? widget.helperText ?? '',
            style: AppTextStyle.smallCaption.copyWith(
              color: _errorText != null 
                  ? AppColors.error 
                  : AppColors.textTertiary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Versiones especializadas del TextField personalizado

// Campo para moneda (Quetzales)
class CurrencyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  
  const CurrencyTextField({
    Key? key,
    required this.controller,
    this.label,
    this.placeholder = '0.00',
    this.helperText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      placeholder: placeholder,
      helperText: helperText,
      errorText: errorText,
      validator: validator,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      prefix: const Padding(
        padding: EdgeInsets.only(left: 16.0),
        child: Text(
          'Q',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      onChanged: onChanged,
      enabled: enabled,
    );
  }
}

// Campo para teléfono (Formato guatemalteco)
class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  
  const PhoneTextField({
    Key? key,
    required this.controller,
    this.label,
    this.placeholder = 'XXXX-XXXX',
    this.helperText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      placeholder: placeholder,
      helperText: helperText,
      errorText: errorText,
      validator: validator,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
        LengthLimitingTextInputFormatter(9), // 8 dígitos + posible guión
      ],
      prefix: const Padding(
        padding: EdgeInsets.only(left: 16.0),
        child: Icon(
          CupertinoIcons.phone,
          size: 18,
          color: AppColors.textSecondary,
        ),
      ),
      onChanged: onChanged,
      enabled: enabled,
    );
  }
}

// Campo para búsqueda
class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  
  const SearchTextField({
    Key? key,
    required this.controller,
    this.placeholder = 'Buscar',
    this.onChanged,
    this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      placeholder: placeholder,
      prefix: const Padding(
        padding: EdgeInsets.only(left: 12.0),
        child: Icon(
          CupertinoIcons.search,
          size: 18,
          color: AppColors.textSecondary,
        ),
      ),
      suffix: controller.text.isNotEmpty
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(
                CupertinoIcons.clear_circled_solid,
                size: 18,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                controller.clear();
                onClear?.call();
              },
            )
          : null,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      onChanged: onChanged,
    );
  }
}

// Campo para fecha (con selector)
class DateTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final String? Function(String?)? validator;
  final ValueChanged<DateTime>? onDateSelected;
  final bool enabled;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  
  const DateTextField({
    Key? key,
    required this.controller,
    this.label,
    this.placeholder = 'DD/MM/AAAA',
    this.helperText,
    this.errorText,
    this.validator,
    this.onDateSelected,
    this.enabled = true,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      placeholder: placeholder,
      helperText: helperText,
      errorText: errorText,
      validator: validator,
      keyboardType: TextInputType.datetime,
      readOnly: true, // Siempre en solo lectura para forzar uso del selector
      prefix: const Padding(
        padding: EdgeInsets.only(left: 16.0),
        child: Icon(
          CupertinoIcons.calendar,
          size: 18,
          color: AppColors.textSecondary,
        ),
      ),
      onFocus: enabled ? () => _showDatePicker(context) : null,
      enabled: enabled,
    );
  }
  
  // Mostrar selector de fecha
  void _showDatePicker(BuildContext context) {
    // Cerrar teclado si está abierto
    FocusScope.of(context).requestFocus(FocusNode());
    
    // Obtener fecha actual del controlador o usar fecha actual
    DateTime initialDateTime = initialDate ?? DateTime.now();
    if (controller.text.isNotEmpty) {
      try {
        final parts = controller.text.split('/');
        if (parts.length == 3) {
          initialDateTime = DateTime(
            int.parse(parts[2]),  // año
            int.parse(parts[1]),  // mes
            int.parse(parts[0]),  // día
          );
        }
      } catch (e) {
        // Si hay error al parsear, usar la fecha por defecto
      }
    }
    
    // Fecha mínima y máxima
    final DateTime minDate = firstDate ?? DateTime(2000);
    final DateTime maxDate = lastDate ?? DateTime.now().add(const Duration(days: 365 * 10));
    
    // Fecha seleccionada
    DateTime selectedDate = initialDateTime;
    
    // Mostrar diálogo
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Botones de acciones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Cancelar'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: const Text('Listo'),
                    onPressed: () {
                      // Formatear fecha para mostrar (dd/MM/yyyy)
                      final formattedDate = 
                          '${selectedDate.day.toString().padLeft(2, '0')}/'
                          '${selectedDate.month.toString().padLeft(2, '0')}/'
                          '${selectedDate.year}';
                      
                      // Actualizar controlador
                      controller.text = formattedDate;
                      
                      // Notificar fecha seleccionada
                      onDateSelected?.call(selectedDate);
                      
                      // Cerrar diálogo
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              
              // Selector de fecha
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDateTime,
                  minimumDate: minDate,
                  maximumDate: maxDate,
                  onDateTimeChanged: (DateTime newDateTime) {
                    selectedDate = newDateTime;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Campo para números enteros
class IntTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final int? minValue;
  final int? maxValue;
  
  const IntTextField({
    Key? key,
    required this.controller,
    this.label,
    this.placeholder = '0',
    this.helperText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.minValue,
    this.maxValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      placeholder: placeholder,
      helperText: helperText,
      errorText: errorText,
      validator: (value) {
        // Validación básica
        if (value == null || value.isEmpty) {
          return null; // No validamos si está vacío (a menos que el validator lo haga)
        }
        
        // Verificar si es número
        final intValue = int.tryParse(value);
        if (intValue == null) {
          return 'Ingrese un número entero válido';
        }
        
        // Verificar rango
        if (minValue != null && intValue < minValue!) {
          return 'El valor mínimo es $minValue';
        }
        
        if (maxValue != null && intValue > maxValue!) {
          return 'El valor máximo es $maxValue';
        }
        
        // Ejecutar validador externo si existe
        return validator?.call(value);
      },
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: onChanged,
      enabled: enabled,
    );
  }
}