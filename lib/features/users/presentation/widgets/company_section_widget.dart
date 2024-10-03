import 'package:flutter/material.dart';
import 'package:posts_app/features/users/domain/entities/company.dart';

class CompanySection extends StatelessWidget {
  final Company company;
  final bool isWideScreen;

  const CompanySection(
      {super.key, required this.company, required this.isWideScreen});

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
            Text('Company Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.business),
              title: Text(company!.name!),
              subtitle: Text(company.catchPhrase!),
            ),
          ],
        ),
      ),
    );
  }
}
