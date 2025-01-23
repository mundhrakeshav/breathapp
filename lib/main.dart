import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'deep_breath_screen.dart'; // Import the DeepBreathScreen

void main() {
  runApp(MyApp());
  _setupShortcutsChannel();
}

void _setupShortcutsChannel() {
  const channel = MethodChannel('shortcuts_channel');
  channel.setMethodCallHandler((call) async {
    if (call.method == 'triggerAction') {
      final action = call.arguments as String;
      if (action == 'search') {
        _performSearch();
      }
    }
  });
}

void _performSearch() {
  print("Search triggered via Shortcuts app!");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shortcuts App'),
      ),
      body: const Center(
        child: Text("Trigger the shortcut via the Shortcuts app!"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the DeepBreathScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DeepBreathScreen(),
            ),
          );
        },
        child: const Icon(Icons.self_improvement), // Breathing icon
      ),
    );
  }
}
