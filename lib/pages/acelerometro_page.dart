//el ecelerometro mide que tan rapido esta cambiando el movimiento del
//dispositivo en cada eje x,y,z

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AcelerometroPage extends StatefulWidget {
  const AcelerometroPage({super.key});

  @override
  State<AcelerometroPage> createState() => _AcelerometroPageState();
}

class _AcelerometroPageState extends State<AcelerometroPage> {
  double x = 0, y = 0, z = 0;

  @override
  void initState() {
    super.initState();
    accelerometerEventStream().listen((event) { //abre un flujo continuo de datos del sensor
    //.listen((event) {...}) se suscribe a ese flujo: cada vez que el acelerómetro manda un nuevo dato, ejecuta lo que está adentro
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Center( //centrar contenido
      child: Text(//texto con los tres valores
        'x: ${x.toStringAsFixed(2)}\ny: ${y.toStringAsFixed(2)}\nz: ${z.toStringAsFixed(2)}',
        style: const TextStyle(fontSize: 22),
        textAlign: TextAlign.center,
      ),
    );
  }
}