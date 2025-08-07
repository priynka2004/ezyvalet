import 'package:ezyvalet/unused_screen/VehicleRegisteredScreen.dart';
import 'package:flutter/material.dart';

class VehicleSecureScreen extends StatelessWidget {
  const VehicleSecureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFFBF8F3);
    final cardBg = const Color(0xFFF4F1EA);
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Valet Parking',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const Text(
                'Your Vehicle is Secure',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Your vehicle is now in our care. Please keep this OTP safe for retrieval.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('OTP', style: TextStyle(color: Colors.black54)),
                    SizedBox(height: 8),
                    Text('123456', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Align(
                alignment: Alignment.centerLeft,
                child: Text('Vehicle Details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ),
              const SizedBox(height: 8),

              Card(
                color: cardBg,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  child: Column(
                    children: [
                      _detailRow('Make', 'Toyota'),
                      const Divider(),
                      _detailRow('Model', 'Camry'),
                      const Divider(),
                      _detailRow('Color', 'Silver'),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0C24A),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context){
                     return VehicleRegisteredScreen();
                   }));
                  },
                  child: const Text('Done', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Row(
      children: [
        Expanded(child: Text(title, style: const TextStyle(color: Colors.black54))),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
