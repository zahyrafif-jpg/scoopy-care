import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScoopyProvider(),
      child: MaterialApp(
        title: 'Scoopy Care',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class ScoopyProvider extends ChangeNotifier {
  double currentKm = 12500;
  DateTime? lastOilChange;

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    currentKm = prefs.getDouble('currentKm') ?? 12500;
    notifyListeners();
  }

  Future<void> updateKm(double km) async {
    currentKm = km;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('currentKm', km);
    notifyListeners();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScoopyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scoopy Care 🛵', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Odometer Saat Ini', style: TextStyle(fontSize: 18)),
                    Text('${provider.currentKm.toStringAsFixed(0)} km', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Update KM'),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Next Service', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Card(
              color: Colors.orange[100],
              child: const ListTile(
                leading: Icon(Icons.oil_barrel, color: Colors.orange, size: 40),
                title: Text('Ganti Oli Mesin'),
                subtitle: Text('Dalam 800 km lagi (sekitar 2 minggu)'),
                trailing: Text('3.000 km', style: TextStyle(fontSize: 18)),
              ),
            ),
            // Tambah card lain nanti
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Reminder'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'Tips'),
        ],
      ),
    );
  }
}
