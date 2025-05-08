// lib/app/utils/helpers.dart

import '../data/models/item_venta_model.dart';
import 'constants.dart';

/// Funciones de ayuda para cálculos y operaciones comunes

// Cálculos para el módulo de calculadora
class CalculoHelper {
  // Calcular costo de material según tamaño
  static double calcularCostoMaterialPorTamano(double costoBase, TamanoSticker tamano) {
    switch (tamano) {
      case TamanoSticker.cuarto:
        return costoBase / 4;
      case TamanoSticker.medio:
        return costoBase / 2;
      case TamanoSticker.tresQuartos:
        return costoBase * 0.75;
      case TamanoSticker.completo:
        return costoBase;
      default:
        return costoBase / 4;
    }
  }
  
  // Calcular desperdicio (5% por defecto)
  static double calcularDesperdicio(double subtotal, [double porcentaje = BusinessRules.porcentajeDesperdicio]) {
    return subtotal * (porcentaje / 100);
  }
  
  // Calcular ganancia según porcentaje
  static double calcularGanancia(double subtotal, double porcentajeGanancia) {
    // No permitir porcentaje menor al mínimo
    if (porcentajeGanancia < BusinessRules.porcentajeGananciaMin) {
      porcentajeGanancia = BusinessRules.porcentajeGananciaMin;
    }
    
    return subtotal * (porcentajeGanancia / 100);
  }
  
  // Aplicar reglas especiales de precio
  static double aplicarReglasEspeciales(
    double precioUnitario,
    TamanoSticker tamano,
    int cantidad
  ) {
    // Regla: 1/4 De hoja a Q20
    if (tamano == TamanoSticker.cuarto) {
      precioUnitario = BusinessRules.precioCuartoHoja;
    }
    
    // Regla: 1/2 Hoja en adelante a Q15 c/u
    else if (tamano == TamanoSticker.medio || 
        tamano == TamanoSticker.tresQuartos || 
        tamano == TamanoSticker.completo) {
      precioUnitario = BusinessRules.precioMediaHoja;
    }
    
    // Regla: Mayorista (a partir de 100 unidades de 1/4 de hoja: Q10 c/u)
    if (tamano == TamanoSticker.cuarto && cantidad >= BusinessRules.cantidadMayorista) {
      precioUnitario = BusinessRules.precioMayorista;
    }
    
    return precioUnitario;
  }
  
  // Verificar si se puede aplicar promoción de redes sociales
  static bool esPaqueteRedesSociales(List<ItemVentaModel> items) {
    return items.length == 3 && 
        items.every((item) => item.tamano == TamanoSticker.cuarto && item.cantidad == 1);
  }
  
  // Calcular el costo de tinta según el tamaño
  static double calcularCostoTinta(TamanoSticker tamano) {
    // Valor base para un cuarto de hoja
    double costoCuarto = 2.0;
    
    switch (tamano) {
      case TamanoSticker.cuarto:
        return costoCuarto;
      case TamanoSticker.medio:
        return costoCuarto * 2;
      case TamanoSticker.tresQuartos:
        return costoCuarto * 3;
      case TamanoSticker.completo:
        return costoCuarto * 4;
      default:
        return costoCuarto;
    }
  }
}

// Helpers para inventario
class InventarioHelper {
  // Calcular uso de material según tamaño y cantidad
  static int calcularUsoMaterial(TamanoSticker tamano, int cantidad) {
    double factorHoja;
    
    switch (tamano) {
      case TamanoSticker.cuarto:
        factorHoja = 0.25;
        break;
      case TamanoSticker.medio:
        factorHoja = 0.5;
        break;
      case TamanoSticker.tresQuartos:
        factorHoja = 0.75;
        break;
      case TamanoSticker.completo:
        factorHoja = 1.0;
        break;
      default:
        factorHoja = 0.25;
    }
    
    // Redondear hacia arriba para no quedarse corto en material
    return (cantidad * factorHoja).ceil();
  }
  
  // Calcular días de stock restante basado en tendencia de ventas
  static int calcularDiasRestantes(int stockActual, double promedioUsoSemanal) {
    if (promedioUsoSemanal <= 0) return 999; // Evitar división por cero
    
    // Convertir uso semanal a uso diario y calcular días
    double usoDiario = promedioUsoSemanal / 7;
    return (stockActual / usoDiario).floor();
  }
}

// Utilidades generales
class GeneralHelper {
  // Generar ID único para identificar elementos localmente
  static String generarIdLocal() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
  
  // Limitar un número entre un mínimo y máximo
  static double limitarValor(double valor, double min, double max) {
    if (valor < min) return min;
    if (valor > max) return max;
    return valor;
  }
  
  // Calcular porcentaje de variación entre dos valores
  static double calcularVariacionPorcentual(double valorActual, double valorAnterior) {
    if (valorAnterior == 0) return 0;
    return ((valorActual - valorAnterior) / valorAnterior) * 100;
  }
}