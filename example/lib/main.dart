import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:micco_platbook_tagging/micco_platbook_tagging.dart';
import 'dart:developer' as developer;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _miccoPlatbookTaggingPlugin = MiccoPlatbookTagging();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _miccoPlatbookTaggingPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(children: [
          MaterialButton(onPressed: loadLodel, child: const Text('Download')),
          MaterialButton(onPressed: startPrediction, child: const Text('predict'),)
        ],),
      ),
    );
  }

  loadLodel () {
    _miccoPlatbookTaggingPlugin.loadLodel();
  }

  startPrediction () {
    _miccoPlatbookTaggingPlugin.predict({"1": "boeuf", "2": "shrimp"})
    .then(print)
    .catchError((e) => developer.log(e.toString(), error: e));
  }
}
