// lib/app/modules/notas/components/nota_card_component.dart
import 'package:flutter/cupertino.dart';
import '../../../data/models/nota_model.dart';
import 'package:intl/intl.dart';

class NotaCardComponent extends StatelessWidget {
  final NotaModel nota;
  final VoidCallback onTap;

  const NotaCardComponent({Key? key, required this.nota, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Formato para fecha
    final formatoFecha = DateFormat('dd/MM/yyyy');

    // Obtener icono según string
    IconData getIcono(String iconoString) {
      switch (iconoString) {
        case 'cliente':
          return CupertinoIcons.person;
        case 'proveedor':
          return CupertinoIcons.building_2_fill;
        case 'hoja':
          return CupertinoIcons.doc;
        case 'laminado':
          return CupertinoIcons.layers;
        case 'sticker':
          return CupertinoIcons.tag;
        case 'estadistica':
          return CupertinoIcons.graph_circle;
        case 'costos':
          return CupertinoIcons.money_dollar;
        default:
          return CupertinoIcons.doc_text;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: nota.color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono y fecha
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    getIcono(nota.icono),
                    size: 24,
                    color: CupertinoColors.white,
                  ),
                  Text(
                    formatoFecha.format(nota.fechaModificacion),
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Título
              Text(
                nota.titulo,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Contenido
              Expanded(
                child: Text(
                  nota.contenido,
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 14,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Categoría
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: CupertinoColors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  nota.categoria,
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
