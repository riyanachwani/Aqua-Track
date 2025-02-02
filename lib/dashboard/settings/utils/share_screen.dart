import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard functionality
import 'package:url_launcher/url_launcher.dart'; // For email functionality
  // Function to copy text to clipboard
  void copyToClipboard(BuildContext context, String message) {
    Clipboard.setData(ClipboardData(text: message));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message copied to clipboard!')),
    );
  }

  // Function to open email client
  void sendEmail(String subject, String body) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: '',
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not open email client';
    }
  }

  void openCustomShareDialog(BuildContext context) {
    final String message =
        'Check out AquaTrack app for better hydration management!';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Share AquaTrack'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  copyToClipboard(context, message);
                  Navigator.pop(context); // Close dialog after copying
                },
                child: const Text('Copy to Clipboard'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  sendEmail(
                      'AquaTrack App Recommendation', message);
                  Navigator.pop(context); // Close dialog after sending email
                },
                child: const Text('Email to Friend'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Add your social media share options here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Social media share coming soon!')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Share on Social Media'),
              ),
            ],
          ),
        );
      },
    );
  }

class ShareScreen extends StatelessWidget {
  const ShareScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share AquaTrack'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => openCustomShareDialog(context),
          child: const Text('Open Custom Share Dialog'),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ShareScreen(),
  ));
}
