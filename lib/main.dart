import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'deep_breath_screen.dart';

// https://www.icloud.com/shortcuts/ee07115805d5467fb1a00fd166335b98
Uri url = Uri.parse('shortcuts://shortcuts/ee07115805d5467fb1a00fd166335b98');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breath Automations',
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/breath': (context) => const DeepBreathScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final MethodChannel _channel = const MethodChannel('shortcuts_channel');
  bool _processingAction = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeShortcuts();
    _initUniLinks();
  }

  void _initUniLinks() async {
    Uri? initialUri = await getInitialUri();
    _handleDeepLink(initialUri);
    uriLinkStream.listen(_handleDeepLink);
  }

  void _handleDeepLink(Uri? uri) {
    if (uri?.scheme == 'breathapp') {
      _navigateToDeepBreath();
    }
  }

  void _initializeShortcuts() {
    _checkForShortcutTrigger();
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'triggerAction') {
        _handleShortcutAction(call.arguments as String);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkForShortcutTrigger();
    }
  }

  void _checkForShortcutTrigger() async {
    if (_processingAction) return;
    _processingAction = true;

    try {
      final String? action = await _channel.invokeMethod('getLastAction');
      if (action == 'breath') {
        _navigateToDeepBreath();
      }
    } on PlatformException catch (e) {
      print("Action check error: ${e.message}");
    } finally {
      _processingAction = false;
    }
  }

  void _handleShortcutAction(String action) {
    if (action == 'breath') {
      _navigateToDeepBreath();
    }
  }

  void _navigateToDeepBreath() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const DeepBreathScreen(),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Breathing Shortcut')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // try {
                //   await _channel.invokeMethod('addShortcut');
                // } on PlatformException catch (e) {
                //   print("Shortcut error: ${e.message}");
                // }
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
              child: const Text('Create Shortcut'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                const url = 'shortcuts://create-automation?type=openApp';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                }
              },
              child: const Text('Setup App Trigger'),
            ),
          ],
        ),
      ),
    );
  }
}
