import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeController extends GetxController {
  var scannedDataList = <String>[].obs;

  void setScannedData(String data) {
    scannedDataList.add(data);
  }
}

class QrCode extends StatelessWidget {
  QrCode({Key? key});
  final QRCodeController qrController = Get.put(QRCodeController());
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          "Scan QR Code",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                Lottie.asset(
                  "assets/images/qr1.json",
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Get.to(QRScannerScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff013274),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    minimumSize: Size(226, 46),
                  ),
                  child: Text(
                    'Scan QR Code',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Obx(
                  () => Column(
                    children: qrController.scannedDataList.map((data) {
                      return Card(
                        surfaceTintColor: Colors.grey,
                        color: Colors.white,
                        elevation: 1,
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: ListTile(
                          title: Text(
                            data,
                            style: TextStyle(fontSize: 18),
                          ),
                          trailing: IconButton(
                            icon: Icon(Iconsax.trash),
                            onPressed: () {
                              _showDeleteConfirmationDialog(context, data);
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: Text("Delete Confirmation"),
          content: Text("Are you sure you want to delete this QR code?"),
          actions: [
            TextButton(
              onPressed: () {
                qrController.scannedDataList.remove(data); // Remove the QR code
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}

class QRScannerScreen extends StatelessWidget {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 400.0;
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 10,
          borderLength: 50, // Increase the border length
          borderWidth: 15, // Increase the border width
          cutOutSize: scanArea,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      Get.find<QRCodeController>().setScannedData(scanData.code!);
      controller.dispose();
      Get.to(QrCode());
    });
  }
}
