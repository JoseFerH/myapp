// lib/app/utils/formatters.dart

import 'package:intl/intl.dart';

/// Utilidades para formateo de datos

// Formateador de moneda para Guatemala (Quetzales)
class CurrencyFormatter {
  static final NumberFormat _quetzalesFormat = NumberFormat.currency(
    locale: 'es_GT',
    symbol: 'Q',
    decimalDigits: 2,
  );
  
  // Formatear a Quetzales
  static String formatQuetzales(double amount) {
    return _quetzalesFormat.format(amount);
  }
  
  // Solo el número formateado sin símbolo
  static String formatNumber(double amount) {
    return _quetzalesFormat.format(amount).replaceAll(RegExp(r'Q\s?'), '');
  }
  
  // Parsear texto a valor numérico
  static double parseQuetzales(String text) {
    // Limpiar cualquier símbolo de moneda o separador
    final cleanText = text
        .replaceAll('Q', '')
        .replaceAll(',', '')
        .trim();
    
    return double.tryParse(cleanText) ?? 0.0;
  }
}

// Formateador de fechas para Guatemala
class DateFormatter {
  // Formato corto: dd/MM/yyyy
  static final DateFormat _shortFormat = DateFormat('dd/MM/yyyy');
  
  // Formato largo: dd de MMMM de yyyy
  static final DateFormat _longFormat = DateFormat('dd \'de\' MMMM \'de\' yyyy', 'es');
  
  // Formato con hora: dd/MM/yyyy HH:mm
  static final DateFormat _withTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  
  // Retorna fecha formateada en formato corto
  static String formatShort(DateTime date) {
    return _shortFormat.format(date);
  }
  
  // Retorna fecha formateada en formato largo
  static String formatLong(DateTime date) {
    return _longFormat.format(date);
  }
  
  // Retorna fecha con hora formateada
  static String formatWithTime(DateTime date) {
    return _withTimeFormat.format(date);
  }
  
  // Parsea una fecha en formato corto
  static DateTime? parseShort(String date) {
    try {
      return _shortFormat.parse(date);
    } catch (e) {
      return null;
    }
  }
}

// Formateador para nombres
class TextFormatter {
  // Convierte primera letra a mayúscula
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  
  // Formatea teléfono guatemalteco: XXXX-XXXX
  static String formatPhone(String phone) {
    // Eliminar caracteres no numéricos
    final digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.length == 8) {
      return '${digitsOnly.substring(0, 4)}-${digitsOnly.substring(4)}';
    }
    
    return phone; // Retornar original si no tiene 8 dígitos
  }
}