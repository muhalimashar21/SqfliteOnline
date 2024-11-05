import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CekKoneksi extends StatefulWidget {
  const CekKoneksi({super.key});

  @override
  State<CekKoneksi> createState() => _CekKoneksiState();
}

class _CekKoneksiState extends State<CekKoneksi> {
  String status = "Offline";
  late StreamSubscription<List<ConnectivityResult>> subscription;

 @override
  void initState() {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      setState(() {
        if (result.contains(ConnectivityResult.none)) {
          status = "Offline";
        } else {
          status = "Online";
        }
      });
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        status,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: status == "Online" ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}