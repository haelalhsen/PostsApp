import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';

class ContactSection extends StatelessWidget {
  final User user;
  final bool isWideScreen;

  const ContactSection(
      {super.key, required this.user, required this.isWideScreen});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(user.phone!),
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text(user.website!),
            ),
          ],
        ),
      ),
    );
  }
}
