import 'dart:math' show Random;
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

void main() {
  runApp(
    MaterialApp(
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _color1 = Colors.blue;
  var _color2 = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: AvailableColorsWidget(
        color1: _color1,
        color2: _color2,
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _color1 = colors.getRandomElement();
                    });
                  },
                  child: const Text('Change color 1'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _color2 = colors.getRandomElement();
                    });
                  },
                  child: const Text('Change color 2'),
                ),
              ],
            ),
            const ColorWidget(color: AvailableColors.one),
            const ColorWidget(color: AvailableColors.two),
          ],
        ),
      ),
    );
  }
}

enum AvailableColors { one, two }

class AvailableColorsWidget extends InheritedModel<AvailableColors> {
  final MaterialColor color1;
  final MaterialColor color2;

  const AvailableColorsWidget({
    Key? key,
    required this.color1,
    required this.color2,
    required Widget child,
  }) : super(key: key, child: child);

  static AvailableColorsWidget of(
      BuildContext context, AvailableColors aspect) {
    return InheritedModel.inheritFrom<AvailableColorsWidget>(
      context,
      aspect: aspect,
    )!;
  }

  @override
  bool updateShouldNotify(covariant AvailableColorsWidget oldWidget) {
    final val = color1 != oldWidget.color1 || color2 != oldWidget.color2;
    devtools.log('updateShouldNotify: $val');
    return val;
  }

  @override
  bool updateShouldNotifyDependent(
    covariant AvailableColorsWidget oldWidget,
    Set<AvailableColors> dependencies,
  ) {
    devtools.log('updateShouldNotifyDependent');
    if (dependencies.contains(AvailableColors.one) &&
        color1 != oldWidget.color1) {
      return true;
    }
    if (dependencies.contains(AvailableColors.two) &&
        color2 != oldWidget.color2) {
      return true;
    }
    return false;
  }
}

class ColorWidget extends StatelessWidget {
  final AvailableColors color;
  const ColorWidget({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    switch (color) {
      case AvailableColors.one:
        devtools.log('color1 widget rebuilt');
        break;
      case AvailableColors.two:
        devtools.log('color2 widget rebuilt');
        break;
    }

    final provider = AvailableColorsWidget.of(
      context,
      color,
    );

    return Container(
        height: 100,
        color:
            color == AvailableColors.one ? provider.color1 : provider.color2);
  }
}

final colors = [
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.cyan,
  Colors.brown,
  Colors.amber,
  Colors.deepPurple,
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(Random().nextInt(length));
}
