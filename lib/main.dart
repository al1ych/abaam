import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() => runApp(const AntiBaamApp());

class AntiBaamApp extends StatelessWidget {
  const AntiBaamApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'AntiBaam',
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final apiUrl = 'https://abaam-server.herokuapp.com';
  final Dio dio = Dio();
  String qr = "";

  void _requestQr() async {
    final r = await dio.get("$apiUrl/qr");
    final x = jsonDecode(r.data);
    qr = x['qr'];
    print("qr is now: $qr");
  }

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      _requestQr();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (qr != "")
            Center(
              child: QrImage(
                data: qr,
                version: QrVersions.auto,
                size: 200,
                gapless: false,
              ),
            ),
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: MobileScanner(
                // allowDuplicates: true,
                onDetect: (Barcode data, args) {
                  var x = data.rawValue;
                  print("detected! $x");
                  dio.post('$apiUrl/qr', data: jsonEncode({'qr': x}));
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
