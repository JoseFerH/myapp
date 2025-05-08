// lib/app/utils/validators.dart

/// Validadores para formularios y entrada de datos

// Validador de texto general
class TextValidator {
  // Verificar si es requerido
  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }
  
  // Verificar longitud mínima
  static String? minLength(String? value, int minLength) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (value.length < minLength) {
      return 'Debe tener al menos $minLength caracteres';
    }
    return null;
  }
  
  // Verificar longitud máxima
  static String? maxLength(String? value, int maxLength) {
    if (value == null || value.isEmpty) {
      return null; // No validamos si está vacío
    }
    if (value.length > maxLength) {
      return 'No debe exceder $maxLength caracteres';
    }
    return null;
  }
  
  // Longitud exacta (útil para códigos)
  static String? exactLength(String? value, int length) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (value.length != length) {
      return 'Debe tener exactamente $length caracteres';
    }
    return null;
  }
  
  // Combinación de validadores
  static String? compose(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}

// Validador para correos electrónicos
class EmailValidator {
  // Verificar formato de email
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return null; // No validamos si está vacío
    }
    
    // Expresión regular para validar email
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);
    
    if (!regExp.hasMatch(value)) {
      return 'Ingrese un correo electrónico válido';
    }
    
    return null;
  }
  
  // Requerido + validación
  static String? validateRequired(String? value) {
    final required = TextValidator.required(value);
    if (required != null) {
      return required;
    }
    
    return validate(value);
  }
}

// Validador para números de teléfono de Guatemala
class PhoneValidator {
  // Verificar formato de teléfono guatemalteco (8 dígitos)
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return null; // No validamos si está vacío
    }
    
    // Eliminar cualquier caracter no numérico
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.length != 8) {
      return 'El número debe tener 8 dígitos';
    }
    
    return null;
  }
  
  // Requerido + validación
  static String? validateRequired(String? value) {
    final required = TextValidator.required(value);
    if (required != null) {
      return required;
    }
    
    return validate(value);
  }
}

// Validador para valores numéricos
class NumberValidator {
  // Verificar si es un número válido
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return null; // No validamos si está vacío
    }
    
    // Verificar si es un número (entero o decimal)
    if (double.tryParse(value) == null) {
      return 'Ingrese un valor numérico válido';
    }
    
    return null;
  }
  
  // Verificar si es un número positivo
  static String? positive(String? value) {
    final numberValidation = validate(value);
    if (numberValidation != null) {
      return numberValidation;
    }
    
    final number = double.parse(value!);
    if (number <= 0) {
      return 'El valor debe ser mayor a cero';
    }
    
    return null;
  }
  
  // Verificar si es un número dentro de un rango
  static String? range(String? value, double min, double max) {
    final numberValidation = validate(value);
    if (numberValidation != null) {
      return numberValidation;
    }
    
    final number = double.parse(value!);
    if (number < min) {
      return 'El valor mínimo es $min';
    }
    
    if (number > max) {
      return 'El valor máximo es $max';
    }
    
    return null;
  }
  
  // Requerido + validación
  static String? validateRequired(String? value) {
    final required = TextValidator.required(value);
    if (required != null) {
      return required;
    }
    
    return validate(value);
  }
}

// Validador para fechas
class DateValidator {
  // Verificar si es una fecha válida
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return null; // No validamos si está vacío
    }
    
    try {
      // Probar formatos comunes (dd/MM/yyyy)
      final parts = value.split('/');
      if (parts.length != 3) {
        return 'Use el formato dd/mm/aaaa';
      }
      
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      
      if (day < 1 || day > 31 || month < 1 || month > 12) {
        return 'Fecha inválida';
      }
      
      // Validación básica de días por mes
      if (month == 2 && day > 29) {
        return 'Febrero no puede tener más de 29 días';
      }
      
      if ([4, 6, 9, 11].contains(month) && day > 30) {
        return 'Este mes solo tiene 30 días';
      }
      
      // Validar año razonable
      final currentYear = DateTime.now().year;
      if (year < 2000 || year > currentYear + 1) {
        return 'Año fuera de rango permitido';
      }
      
      return null;
    } catch (e) {
      return 'Fecha inválida';
    }
  }
  
  // Verificar si fecha está en el pasado
  static String? isPast(String? value) {
    final dateValidation = validate(value);
    if (dateValidation != null) {
      return dateValidation;
    }
    
    try {
      final parts = value!.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      
      final date = DateTime(year, month, day);
      final now = DateTime.now();
      
      if (date.isAfter(now)) {
        return 'La fecha debe ser en el pasado';
      }
      
      return null;
    } catch (e) {
      return 'Fecha inválida';
    }
  }
  
  // Verificar si fecha está en el futuro
  static String? isFuture(String? value) {
    final dateValidation = validate(value);
    if (dateValidation != null) {
      return dateValidation;
    }
    
    try {
      final parts = value!.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      
      final date = DateTime(year, month, day);
      final now = DateTime.now();
      
      if (date.isBefore(now)) {
        return 'La fecha debe ser en el futuro';
      }
      
      return null;
    } catch (e) {
      return 'Fecha inválida';
    }
  }
}