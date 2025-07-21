import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swasthya_doot/pages/auth/login_page.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String name = '';
  String role = '';
  String location = '';
  String preferredLanguage = '';
  String phone = '';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final uid = currentUser.uid;
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString('preferred_language') ?? 'Hindi';

      if (userDoc.exists) {
        final data = userDoc.data()!;
        setState(() {
          name = data['fullName'] ?? 'User';
          role = data['role'] ?? 'role';
          location = data['village'] ?? 'location';
          phone = data['phoneNumber'] ?? '';
          preferredLanguage = lang;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> setLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('preferred_language', lang);
    setState(() => preferredLanguage = lang);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your account information',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(size.height * 0.025),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0B80F2), Color(0xFF4DB6F7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade200, Colors.blue.shade600],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha((0.1 * 255).toInt()),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: size.height * 0.025,
                            child: SvgPicture.asset(
                              'assets/profile.svg',
                              width: size.height * 0.04,
                              height: size.height * 0.04,
                            ),
                          ),
                        ),
                              title: Text(
                                name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Chip(
                                    label: Text(
                                      role,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide.none,
                                    ),
                                    visualDensity: const VisualDensity(
                                      horizontal: 0.3,
                                      vertical: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    leading: const Icon(Icons.phone),
                                    title: const Text('Phone Number'),
                                    subtitle: Text('+91 $phone'),
                                  ),
                                  ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    leading: const Icon(Icons.location_on),
                                    title: const Text('Location'),
                                    subtitle: Text(location),
                                  ),
                                  ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    leading: const Icon(Icons.language),
                                    title: const Text('Preferred Language'),
                                    subtitle: Text(preferredLanguage),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(size.height * 0.025),
                      const Text(
                        'Language Preferences',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(size.height * 0.01),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _languageButton(
                            'Hindi',
                            preferredLanguage == 'Hindi',
                          ),
                          _languageButton(
                            'English',
                            preferredLanguage == 'English',
                          ),
                        ],
                      ),
                      Gap(size.height * 0.02),
                      const Text(
                        'Account Actions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              if (context.mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const PhoneLoginPage(),
                                  ),
                                  (route) => false,
                                );
                              }
                            },
                            icon: const Icon(Icons.logout, color: Colors.white),
                            label: const Text(
                              'Log Out',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      Gap(size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text(
                            'Terms & Services',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Contact Us',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _languageButton(String label, bool selected) {
    return OutlinedButton.icon(
      onPressed: () => setLanguage(label),
      icon: const Icon(Icons.language),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? Colors.blue : Colors.grey.shade100,
        foregroundColor: selected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: selected ? Colors.blue : Colors.grey.shade300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
