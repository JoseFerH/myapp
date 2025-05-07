import 'package:cloud_firestore/cloud_firestore.dart';

class ConfiguracionModel {
  String id;
  double porcentajeGananciasMin;
  double porcentajeGananciasDefault;
  double precioDisenioEstandar;
  double precioDisenioPersonalizado;
  double costoEnvioNormal; // Q18
  double costoEnvioExpress; // Q30
  bool aplicarDesperdicioDefault;
  double porcentajeDesperdicio; // 5%
  
  // Precios especiales según reglas de negocio
  double precioCuartoHoja; // Q20
  double precioMediaHoja;  // Q15
  double precioRedesSociales; // 3 por Q90 con envío
  double precioMayorista;  // A partir de 100, Q10 c/u
  int cantidadMayorista;   // 100 unidades
  
  ConfiguracionModel({
    this.id = 'config',
    required this.porcentajeGananciasMin,
    required this.porcentajeGananciasDefault,
    required this.precioDisenioEstandar,
    required this.precioDisenioPersonalizado,
    required this.costoEnvioNormal,
    required this.costoEnvioExpress,
    this.aplicarDesperdicioDefault = true,
    this.porcentajeDesperdicio = 5.0,
    required this.precioCuartoHoja,
    required this.precioMediaHoja,
    required this.precioRedesSociales,
    required this.precioMayorista,
    this.cantidadMayorista = 100,
  });
  
  // Constructor desde Firestore
  factory ConfiguracionModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ConfiguracionModel(
      id: doc.id,
      porcentajeGananciasMin: (data['porcentajeGananciasMin'] ?? 50).toDouble(),
      porcentajeGananciasDefault: (data['porcentajeGananciasDefault'] ?? 50).toDouble(),
      precioDisenioEstandar: (data['precioDisenioEstandar'] ?? 0).toDouble(),
      precioDisenioPersonalizado: (data['precioDisenioPersonalizado'] ?? 0).toDouble(),
      costoEnvioNormal: (data['costoEnvioNormal'] ?? 18).toDouble(),
      costoEnvioExpress: (data['costoEnvioExpress'] ?? 30).toDouble(),
      aplicarDesperdicioDefault: data['aplicarDesperdicioDefault'] ?? true,
      porcentajeDesperdicio: (data['porcentajeDesperdicio'] ?? 5).toDouble(),
      precioCuartoHoja: (data['precioCuartoHoja'] ?? 20).toDouble(),
      precioMediaHoja: (data['precioMediaHoja'] ?? 15).toDouble(),
      precioRedesSociales: (data['precioRedesSociales'] ?? 90).toDouble(),
      precioMayorista: (data['precioMayorista'] ?? 10).toDouble(),
      cantidadMayorista: data['cantidadMayorista'] ?? 100,
    );
  }
  
  // Convertir a mapa para Firestore
  Map<String, dynamic> toMap() => {
    'porcentajeGananciasMin': porcentajeGananciasMin,
    'porcentajeGananciasDefault': porcentajeGananciasDefault,
    'precioDisenioEstandar': precioDisenioEstandar,
    'precioDisenioPersonalizado': precioDisenioPersonalizado,
    'costoEnvioNormal': costoEnvioNormal,
    'costoEnvioExpress': costoEnvioExpress,
    'aplicarDesperdicioDefault': aplicarDesperdicioDefault,
    'porcentajeDesperdicio': porcentajeDesperdicio,
    'precioCuartoHoja': precioCuartoHoja,
    'precioMediaHoja': precioMediaHoja,
    'precioRedesSociales': precioRedesSociales,
    'precioMayorista': precioMayorista,
    'cantidadMayorista': cantidadMayorista,
  };
  
  // Método para crear una configuración predeterminada
  factory ConfiguracionModel.defaultConfig() {
    return ConfiguracionModel(
      porcentajeGananciasMin: 50.0,
      porcentajeGananciasDefault: 50.0,
      precioDisenioEstandar: 0.0,
      precioDisenioPersonalizado: 50.0,
      costoEnvioNormal: 18.0,
      costoEnvioExpress: 30.0,
      aplicarDesperdicioDefault: true,
      porcentajeDesperdicio: 5.0,
      precioCuartoHoja: 20.0,
      precioMediaHoja: 15.0,
      precioRedesSociales: 90.0,
      precioMayorista: 10.0,
      cantidadMayorista: 100,
    );
  }
  
  // Crear copia con campos actualizados
  ConfiguracionModel copyWith({
    double? porcentajeGananciasMin,
    double? porcentajeGananciasDefault,
    double? precioDisenioEstandar,
    double? precioDisenioPersonalizado,
    double? costoEnvioNormal,
    double? costoEnvioExpress,
    bool? aplicarDesperdicioDefault,
    double? porcentajeDesperdicio,
    double? precioCuartoHoja,
    double? precioMediaHoja,
    double? precioRedesSociales,
    double? precioMayorista,
    int? cantidadMayorista,
  }) {
    return ConfiguracionModel(
      id: this.id,
      porcentajeGananciasMin: porcentajeGananciasMin ?? this.porcentajeGananciasMin,
      porcentajeGananciasDefault: porcentajeGananciasDefault ?? this.porcentajeGananciasDefault,
      precioDisenioEstandar: precioDisenioEstandar ?? this.precioDisenioEstandar,
      precioDisenioPersonalizado: precioDisenioPersonalizado ?? this.precioDisenioPersonalizado,
      costoEnvioNormal: costoEnvioNormal ?? this.costoEnvioNormal,
      costoEnvioExpress: costoEnvioExpress ?? this.costoEnvioExpress,
      aplicarDesperdicioDefault: aplicarDesperdicioDefault ?? this.aplicarDesperdicioDefault,
      porcentajeDesperdicio: porcentajeDesperdicio ?? this.porcentajeDesperdicio,
      precioCuartoHoja: precioCuartoHoja ?? this.precioCuartoHoja,
      precioMediaHoja: precioMediaHoja ?? this.precioMediaHoja,
      precioRedesSociales: precioRedesSociales ?? this.precioRedesSociales,
      precioMayorista: precioMayorista ?? this.precioMayorista,
      cantidadMayorista: cantidadMayorista ?? this.cantidadMayorista,
    );
  }
}