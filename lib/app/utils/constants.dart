// lib/app/utils/constants.dart

/// Constantes globales para la aplicación

// Configuración de la app
class AppConstants {
  // Nombre de la aplicación
  static const String appName = 'Creati Calculator';
  
  // Versión
  static const String appVersion = '1.0.0';
  
  // Keys para almacenamiento local
  static const String storageKeyCarrito = 'carrito_data';
  static const String storageKeyConfig = 'configuracion';
  static const String storageKeyUser = 'user_data';
}

// Reglas de negocio
class BusinessRules {
  // Precios especiales
  static const double precioCuartoHoja = 20.0;     // 1/4 hoja a Q20
  static const double precioMediaHoja = 15.0;      // 1/2 hoja en adelante a Q15
  static const double precioPromoRedes = 90.0;     // Redes sociales: 3 por Q90 con envío
  
  // Descuentos por volumen
  static const int cantidadMayorista = 100;        // A partir de 100 unidades
  static const double precioMayorista = 10.0;      // Q10 c/u con diseño incluido
  
  // Costos de envío
  static const double costoEnvioNormal = 18.0;     // Envío normal Q18
  static const double costoEnvioExpress = 30.0;    // Envío express Q30
  
  // Porcentajes
  static const double porcentajeDesperdicio = 5.0; // 5% de desperdicio
  static const double porcentajeGananciaMin = 50.0; // Mínimo 50% de ganancia
}

// Firebase paths
class FirebasePaths {
  static const String clientes = 'clientes';
  static const String proveedores = 'proveedores';
  static const String materiales = 'materiales';
  static const String ventas = 'ventas';
  static const String costosFijos = 'costosFijos';
  static const String configuracion = 'configuracion';
}

// Valores predeterminados para formularios
class DefaultValues {
  static const int cantidadDefault = 1;
  static const bool aplicarDesperdicioDefault = true;
  static const String zonaDefaultGT = "Zona 10";
  static const double precioDisenioPersonalizadoDefault = 50.0;
}