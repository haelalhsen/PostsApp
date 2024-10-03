import 'package:flutter/material.dart';
import 'package:posts_app/features/users/domain/entities/user.dart';

import '../widgets/address_section_widget.dart';
import '../widgets/company_section_widget.dart';
import '../widgets/contact_section_widget.dart';
import '../widgets/profile_header_widget.dart';

class UserProfilePage extends StatelessWidget {
  final User user;

  const UserProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWideScreen = constraints.maxWidth > 600;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  ProfileHeader(user: user, isWideScreen: isWideScreen),

                  const SizedBox(height: 20),

                  // Contact Information
                  ContactSection(user: user, isWideScreen: isWideScreen),

                  const SizedBox(height: 20),

                  // Address Section
                  AddressSection(
                      address: user.address!, isWideScreen: isWideScreen),

                  const SizedBox(height: 20),

                  // Company Details
                  CompanySection(
                      company: user.company!, isWideScreen: isWideScreen),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
