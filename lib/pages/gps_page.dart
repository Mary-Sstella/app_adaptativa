import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GpsPage extends StatefulWidget {
  const GpsPage({super.key});

  @override
  State<GpsPage> createState() => _GpsPageState();
}

class _GpsPageState extends State<GpsPage> {
  String ubicacion = 'Presione el botón';

  // Función que se ejecuta cuando el usuario presiona el botón.
  // Es "async" porque todo lo que hace (revisar GPS, pedir
  // permiso, obtener posición) toma tiempo y no puede ser
  // instantáneo.
  Future<void> _obtenerUbicacion() async {

    setState(() => ubicacion = 'Buscando señal GPS...');

    // PASO 1: Verificar si el GPS del dispositivo está encendido
    bool servicioActivo = await Geolocator.isLocationServiceEnabled();
    if (!servicioActivo) {
      // Si el GPS físico está apagado, no tiene sentido seguir:
      // ni pidiendo permiso se puede obtener ubicación.
      setState(() => ubicacion = 'Activa el GPS del dispositivo');
      return; 
    }

    // PASO 2: Revisar si la app YA tiene permiso de ubicación.
    LocationPermission permiso = await Geolocator.checkPermission();

    // si el periso fue denegado "hace que pida el permiso" en pantalla.
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();

      if (permiso == LocationPermission.denied) {
        setState(() => ubicacion = 'Permiso denegado');
        return;
      }
    }

    // PASO 3: Caso especial — si el usuario ya negó el permiso
    // varias veces, Android deja de mostrar el permiso
    if (permiso == LocationPermission.deniedForever) {
      setState(() {
        ubicacion = 'Permiso denegado permanentemente. Actívalo en ajustes.';
      });
      return;
    }

    // PASO 4: Si se llegó hasta aquí, el GPS está prendido Y el
    // permiso fue concedido. Se intenta obtener la posición real.
    try {
      Position pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          // Si no consigue señal en 15 segundos, lanza un error
          // en vez de quedarse esperando para siempre.
          timeLimit: Duration(seconds: 15),
        ),
      );

      setState(() {
        ubicacion = 'Lat: ${pos.latitude}\nLon: ${pos.longitude}';
      });
    } catch (e) {
      setState(() => ubicacion = 'Error obteniendo ubicación: $e');
    }
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
          ElevatedButton(
            // Cada vez que se presiona, dispara toda la lógica
            // de permisos y obtención de ubicación de arriba.
            onPressed: _obtenerUbicacion,
            child: const Text('Obtener ubicación'),
          ),
        ],
      ),
    );
  }
}