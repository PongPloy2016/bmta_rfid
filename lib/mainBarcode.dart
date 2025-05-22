
import 'package:flutter/material.dart';
import 'package:zebra_scan_datawedge/zebra_datawedge.dart';

void main() {
  runApp(const MainBarcode());
}

class MainBarcode extends StatefulWidget {
  const MainBarcode({super.key});

  @override
  State<MainBarcode> createState() => _MainBarcodeState();
}

class _MainBarcodeState extends State<MainBarcode> {
  final zebraSdk = ZebraDataWedge();

  @override
  void initState() {
    super.initState();
    zebraSdk.initialized();
    zebraSdk.createDataWedgeProfile(profileName: "BMTA_PROD");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Zebra SDK Plugin'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: StreamBuilder(
                          stream: zebraSdk.getStreamOfData,
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return Text(
                                snap.data ?? "No Data Available",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              );
                            } else {
                              return const Text(
                                "Scan new data...",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey),
                              );
                            }
                          }),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          TextButton(
                              onPressed: zebraSdk.startScan,
                              child: const Text("Start Scan")),
                          TextButton(
                              onPressed: zebraSdk.stopScan,
                              child: const Text("Stop Scan")),
                        ],
                      ),
                      Column(
                        children: [
                          TextButton(
                              onPressed: zebraSdk.disableDataWedge,
                              child: const Text("Disable Data Wedge")),
                          TextButton(
                              onPressed: zebraSdk.enableDataWedge,
                              child: const Text("Enable Data Wedge")),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}