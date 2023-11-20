import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:window_size/window_size.dart';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:think_leds/morse.dart';
import 'package:url_launcher/url_launcher.dart';

const lightStyle = TextStyle(color: Colors.white);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowMaxSize(const Size(500, 320));
    setWindowMinSize(const Size(500, 320));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThinkLED',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.red,
          primary: Colors.red,
          background: const Color.fromARGB(255, 32, 32, 32),
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _dotLedValue = true;
  bool _powerLedValue = true;
  final _controller = TextEditingController();
  bool enabled = true;

  @override
  void initState() {
    final dot = Led('tpacpi::lid_logo_dot');
    final pwr = Led('tpacpi::power');
    _dotLedValue = dot.getBrightness() == 1 ? true : false;
    _powerLedValue = pwr.getBrightness() == 1 ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  children: [
                    ListTile(
                      title: const Text(
                        "Lid LED",
                        style: lightStyle,
                      ),
                      trailing: Switch(
                        value: _dotLedValue,
                        onChanged: (bool value) {
                          setState(() {
                            _dotLedValue = value;
                          });
                          var led = Led('tpacpi::lid_logo_dot');
                          switch (value) {
                            case false:
                              led.setBrightness(0);
                              break;
                            default:
                              led.setBrightness(1);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                ListTile(
                  trailing: Switch(
                    value: _powerLedValue,
                    onChanged: (bool value) {
                      setState(() {
                        _powerLedValue = value;
                      });
                      var led = Led('tpacpi::power');
                      switch (value) {
                        case false:
                          led.setBrightness(0);
                          break;
                        default:
                          led.setBrightness(1);
                      }
                    },
                  ),
                  title: const Text(
                    "Power LED",
                    style: lightStyle,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  enabled: enabled,
                  controller: _controller,
                  onSubmitted: (value) async {
                    await blinkLight(value, Led('tpacpi::lid_logo_dot'));
                  },
                  style: lightStyle,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    disabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 128, 128, 128)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.flashlight_on_outlined),
                      color: Colors.white,
                      onPressed: () async {
                        setState(() {
                          enabled = false;
                        });
                        await blinkLight(
                          _controller.text,
                          Led('tpacpi::lid_logo_dot'),
                        ).then(
                          (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Transmission complete",
                                  style: lightStyle,
                                ),
                                backgroundColor: Colors.red,
                                shape: StadiumBorder(),
                                duration: Duration(milliseconds: 750),
                              ),
                            );
                          },
                        );
                        _controller.clear();
                        setState(() {
                          enabled = true;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                Row(children: [
                  const Spacer(),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.circleUser),
                    onPressed: () =>
                        launchUrl(Uri.parse('https://dragon863.github.io/')),
                  ),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.circleExclamation),
                    onPressed: () => launchUrl(Uri.parse(
                        'https://github.com/Dragon863/ThinkLED/issues')),
                  ),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.github),
                    onPressed: () => launchUrl(
                        Uri.parse('https://github.com/Dragon863/ThinkLED')),
                  )
                ])
              ],
            ),
          ],
        ),
      ),
    );
  }
}
