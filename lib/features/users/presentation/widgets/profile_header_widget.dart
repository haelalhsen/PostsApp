import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';

class ProfileHeader extends StatelessWidget {
  final User user;
  final bool isWideScreen;

  const ProfileHeader(
      {super.key, required this.user, required this.isWideScreen});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: isWideScreen ? 60 : 40,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person,
                  size: isWideScreen ? 60 : 40, color: Colors.white),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name!,
                    style: TextStyle(
                        fontSize: isWideScreen ? 28 : 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text('@${user.username}',
                      style: TextStyle(
                          fontSize: isWideScreen ? 18 : 14,
                          color: Colors.grey)),
                  const SizedBox(height: 5),
                  Text(user.email!,
                      style: TextStyle(
                          fontSize: isWideScreen ? 18 : 14,
                          color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
