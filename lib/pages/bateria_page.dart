import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class BateriaPage extends StatefulWidget {
  const BateriaPage({super.key});
  @override
  State<BateriaPage> createState() => _BateriaPageState();
}

//variables de estado
class _BateriaPageState extends State<BateriaPage> {
  int? nivelBateria; //puede ser nula
  String modelo = 'Cargando...';

//para pedir los datos:
  @override
  void initState() {
    super.initState(); //apenas arraca se muestra:
    _cargarDatos(); //se llama una sola vez, al iniciar
  }

  Future<void> _cargarDatos() async { //esta función tarda un tiempo en completarse
    final bateria = await Battery().batteryLevel; //pregunta al sistema operativo el porcentaje de batería

    final deviceInfo = DeviceInfoPlugin();
    String nombreModelo = 'Desconocido';

    try {
      final androidInfo = await deviceInfo.androidInfo;
      nombreModelo = '${androidInfo.brand} ${androidInfo.model}';
    } catch (_) {
      nombreModelo = 'No es Android';
    }

    setState(() { //una vez ya tiene los datos los muestra
      nivelBateria = bateria;
      modelo = nombreModelo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Bateria: ${nivelBateria ?? '...'}%\nDispositivo: $modelo', //Mientras nivelBateria es null, muestra "..."
        style: const TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }
}
