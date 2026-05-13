import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'bloc/temp_bloc.dart';
import 'bloc/temp_event.dart';
import 'bloc/temp_state.dart';
import 'login_page.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TempBloc()),
        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LoginPage(), 
      ),
    );
  }
}

class KonversiSuhu extends StatelessWidget {
  const KonversiSuhu({super.key});

  double _toCelsius(double v, String dari) => switch (dari) {
        'Fahrenheit' => (v - 32) * 5 / 9,
        'Kelvin' => v - 273.15,
        'Reamur' => v * 5 / 4,
        _ => v,
      };

  double _fromCelsius(double c, String s) => switch (s) {
        'Fahrenheit' => c * 9 / 5 + 32,
        'Kelvin' => c + 273.15,
        'Reamur' => c * 4 / 5,
        _ => c,
      };

  String _simbol(String s) =>
      {'Celsius': '°C', 'Fahrenheit': '°F', 'Kelvin': 'K', 'Reamur': '°R'}[s]!;

  @override
  Widget build(BuildContext context) {
    final List<String> satuan = ['Celsius', 'Fahrenheit', 'Kelvin', 'Reamur'];

    return Scaffold(
      appBar: AppBar(title: const Text('Konversi Suhu BLoC'), centerTitle: true),
      body: BlocBuilder<TempBloc, TempState>(
        builder: (context, state) {
          final celsius = _toCelsius(state.input, state.dari);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Masukkan suhu',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    final val = double.tryParse(v) ?? 0;
                    context.read<TempBloc>().add(InputChanged(val));
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: state.dari,
                  decoration: const InputDecoration(
                    labelText: 'Satuan asal',
                    border: OutlineInputBorder(),
                  ),
                  items: satuan
                      .map((s) => DropdownMenuItem(value: s, child: Text('$s ${_simbol(s)}')))
                      .toList(),
                  onChanged: (v) => context.read<TempBloc>().add(UnitChanged(v!)),
                ),
                const SizedBox(height: 20),
                ...satuan.where((s) => s != state.dari).map((s) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text('$s ${_simbol(s)}'),
                        trailing: Text(
                          _fromCelsius(celsius, s).toStringAsFixed(2),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}