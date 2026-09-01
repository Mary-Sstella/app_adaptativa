import 'package:flutter/material.dart';
import 'pages/acelerometro_page.dart';
import 'pages/bateria_page.dart';
import 'pages/gps_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Adaptativa',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    AcelerometroPage(),
    BateriaPage(),
    GpsPage(),
  ];

  final List<NavigationDestination> _destinations = const [
    NavigationDestination(icon: Icon(Icons.speed), label: 'Acelerómetro'),
    NavigationDestination(icon: Icon(Icons.battery_full), label: 'Batería'),
    NavigationDestination(icon: Icon(Icons.gps_fixed), label: 'GPS'),
  ];

  final List<NavigationRailDestination> _railDestinations = const [
    NavigationRailDestination(icon: Icon(Icons.speed), label: Text('Acelerómetro')),
    NavigationRailDestination(icon: Icon(Icons.battery_full), label: Text('Batería')),
    NavigationRailDestination(icon: Icon(Icons.gps_fixed), label: Text('GPS')),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width < 600) {
          return Scaffold(
            appBar: AppBar(title: const Text('App Adaptativa')),
            body: SafeArea(child: _pages[_selectedIndex]),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _selectedIndex,
              destinations: _destinations,
              onDestinationSelected: (i) => setState(() => _selectedIndex = i),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('App Adaptativa')),
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: _selectedIndex,
                destinations: _railDestinations,
                onDestinationSelected: (i) => setState(() => _selectedIndex = i),
                labelType: NavigationRailLabelType.all,
              ),
              const VerticalDivider(width: 1),
              Expanded(child: SafeArea(child: _pages[_selectedIndex])),
            ],
          ),
        );
      },
    );
  }
}