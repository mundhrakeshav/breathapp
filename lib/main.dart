import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:convert/convert.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() async {
    var mnemonic = bip39.generateMnemonic(strength: 256);
    var seed = bip39.mnemonicToSeed(mnemonic, passphrase: "kesghacv");
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    final privateKey = hex.encode(master.key);
    final data = await ED25519_HD_KEY.derivePath("m/44'/60'/0'/0'", seed);
    print(hex.encode(data.key));
    print(hex.encode(data.chainCode));

    Credentials fromHex = EthPrivateKey.fromHex(hex.encode(data.key));
    final x = fromHex.toString();
    print("address: ${fromHex.address}, ${fromHex.runtimeType}");
    print("privateKey: $privateKey");
    var z = mnemonic.split(" ");
    print(
      "mnemonic: $mnemonic ${z.length}",
    );
    // final storage = new FlutterSecureStorage();
    // storage.write(
    //     key: "mnemonic",
    //     value: mnemonic,
    //     iOptions: IOSOptions(accessibility: IOSAccessibility.first_unlock));

    // storage.readAll().then((value) => print("value: $value"));

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MnemonicInputWidget(
                mnemonic: z,
                onChanged: (p0) => {},
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MnemonicInputWidget extends StatelessWidget {
  final List<String> mnemonic;
  final Function(List<String>) onChanged;

  MnemonicInputWidget({
    Key? key,
    required this.mnemonic,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(mnemonic.length == 24, "Mnemonic must have exactly 24 words");

    return Material(
      // Added Material widget
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: 24,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          return TextFormField(
            initialValue: mnemonic[index],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Word ${index + 1}',
            ),
            onChanged: (value) {
              mnemonic[index] = value;
              onChanged(mnemonic);
            },
          );
        },
      ),
    );
  }
}
