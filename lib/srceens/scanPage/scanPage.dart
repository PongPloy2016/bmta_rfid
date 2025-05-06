import 'package:bmta_rfid_app/utils/zebra123.dart';
import 'package:flutter/material.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String _scanResult = 'No scan yet';

  void _startScan() async {
    try {
      final result = await Zebra123.startScan();
      setState(() {
        _scanResult = result ?? 'No result';
      });
    } catch (e) {
      setState(() {
        _scanResult = 'Error: $e';

        print("_scanResult Error ${_scanResult}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zebra Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Scan Result: $_scanResult'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startScan,
              child: Text('Start Scan'),
            ),
          ],
        ),
      ),
    );
  }
}