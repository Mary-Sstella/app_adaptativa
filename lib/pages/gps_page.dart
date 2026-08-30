import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GpsPage extends StatefulWidget {
  const GpsPage({super.key});
  @override
  State<GpsPage> createState() => _GpsPageState();
}
//va
class _GpsPageState extends State<GpsPage> {
  String ubicacion = 'Presione el boton';

  Future<void> _obtenerUbicacion() async {
    bool servicioActivo = await Geolocator.isLocationServiceEnabled();
    if (!servicioActivo) {
      setState(() => ubicacion = 'Activa el GPS del dispositivo');
      return;
    }

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        setState(() => ubicacion = 'permiso denegado');
        return;
      }
    }
    if (permiso == LocationPermission.deniedForever) {
      setState(
        () => ubicacion =
            'permiso denegado permanentemente. Activalo manualmente',
      );
      return;
    }
    Position pos = await Geolocator.getCurrentPosition();
    setState(() => 'Lat: ${pos.latitude}\nLon: ${pos.longitude}');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ubicacion,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _obtenerUbicacion  , child: const Text('Obtener ubicación'),
          ),
        ],
      ),
    );
  }
}
