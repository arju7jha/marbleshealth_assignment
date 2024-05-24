import 'package:flutter/material.dart';

class SavedDataDisplay extends StatelessWidget {
  final String labelText;
  final String infoText;
  final bool required;

  SavedDataDisplay({required this.labelText, required this.infoText, required this.required});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text.rich(
              TextSpan(
                text: labelText,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                children: required ? [TextSpan(text: '*', style: TextStyle(color: Colors.red))] : [],
              ),
            ),
            SizedBox(height: 8), // Match spacing for better alignment
            Container(
              padding: EdgeInsets.all(8.0), // Match padding
              decoration: BoxDecoration(
                color: Colors.white, // Match background color
                border: Border.all(color: Colors.black12), // Match border color
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(infoText),
            ),
          ],
        ),
      ),
    );
  }
}