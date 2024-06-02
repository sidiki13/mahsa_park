
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Payment Options')),
        backgroundColor: Color.fromARGB(255, 238, 238, 241),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                _launchURL('https://www.mahsa.edu.my/epay/online-payment.php');
              },
              child: Text('Finance Link Payment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement Touch 'n Go QR Code Scanner
              },
              child: Text('Touch \'n Go QR Code Scanner'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Cash Payment'),
                    content: Text('Please go to the Booth counter to pay in cash.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Cash Payment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Payment Status: ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Payment Successful',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            // In case of payment failure, you can display a retry option
            Container(
  width: 250, // Adjust the width as needed
  child: ElevatedButton(
    onPressed: () {
      // Retry payment logic
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        'Just a friendly reminder: Parking entry fee is only: \n',
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
    ),
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.zero, backgroundColor: Color.fromARGB(255, 248, 248, 245), // Remove default padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Apply border radius
      ),
      elevation: 0,
    ),
  ),
  
),

        
            SizedBox(height: 25),
            
          ],
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

}
