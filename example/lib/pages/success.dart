import 'package:flutter/material.dart';

class SuccessPay extends StatelessWidget {
  const SuccessPay({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 100),
          SizedBox(height: 20),
          Text(
            'Payment Successful!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text('Return to Home'),
          ),
        ],
      ),
    );
  }
}
