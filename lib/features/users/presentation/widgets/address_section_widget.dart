import 'package:flutter/material.dart';
import 'package:posts_app/features/users/domain/entities/address.dart';

class AddressSection extends StatelessWidget {
  final Address address;
  final bool isWideScreen;

  const AddressSection(
      {super.key, required this.address, required this.isWideScreen});

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
            Text('Address',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('${address!.suite!}, ${address.street}'),
              subtitle: Text('${address.city}, ${address.zipcode}'),
            ),
          ],
        ),
      ),
    );
  }
}
