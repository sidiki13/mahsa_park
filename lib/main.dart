// lib/main.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Correct import

import 'payment_options_screen.dart'; // Import the new screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDFUn0GA10hXNgxypuWmRbrzELaDQ8rhv8',
      appId: '1:964212159005:android:575fa4cb83196526a0ccf4',
      messagingSenderId: '964212159005',
      projectId: 'mahsapark-9a3a7',
      measurementId: "G-989ENKDZ0B",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mahsa Parking',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 224, 219, 228),
        scaffoldBackgroundColor: Color(0xFFE0F7FA), // Light blue background
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 14, 190, 23),
            foregroundColor: Colors.white,
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
      home: CarCheckScreen(),
    );
  }
}

class CarCheckScreen extends StatefulWidget {
  @override
  _CarCheckScreenState createState() => _CarCheckScreenState();
}

class _CarCheckScreenState extends State<CarCheckScreen> {
  final TextEditingController _plateController = TextEditingController();
  String? plateNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Mahsa Parking')),
        backgroundColor: Color.fromARGB(255, 238, 238, 241), // Darker blue for AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              TextField(
                controller: _plateController,
                decoration: InputDecoration(
                  labelText: 'Enter License Plate Number',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    plateNumber = _plateController.text.trim();
                  });
                },
                child: Text('Check Car Status'),
              ),
              SizedBox(height: 20),
              if (plateNumber != null && plateNumber!.isNotEmpty)
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('cars')
                      .doc(plateNumber)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Text('No data available for this car.');
                    } else {
                      var carData = snapshot.data!.data() as Map<String, dynamic>;
                      bool checkedInStatus = carData['checked_in'] ?? false;
                      bool checkedOutStatus = carData['checked_out'] ?? false;
                      bool paidStatus = carData['paid'] ?? false;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildInfoBox('Car Information', plateNumber ?? 'No plate number entered'),
                          _buildInfoBox('Checked In', checkedInStatus ? 'Yes' : 'No'),
                          _buildInfoBox('Checked Out', checkedOutStatus ? 'Yes' : 'No'),
                          _buildInfoBox('Paid', paidStatus ? 'Yes' : 'No'),
                          if (!paidStatus)
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PaymentOptionsScreen()),
                                );
                              },
                              child: Text('Pay Now'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                        ],
                      );
                    }
                  },
                ),
              SizedBox(height: 1),
              Center(
                child: Text(
                  'Welcome to Mahsa University!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 14, 190, 23),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildInfoBox(String title, String content) {
    Color statusColor = Colors.black; // Default color
    if (content == 'Yes') {
      statusColor = Color.fromARGB(255, 23, 24, 23); // Green color for "Yes"
    } else if (content == 'No') {
      statusColor = Colors.red; // Red color for "No"
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white, // Info box background color
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF007F4D),
            ),
          ),
          SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(fontSize: 18, color: statusColor),
          ),
        ],
      ),
    );
  }
}
