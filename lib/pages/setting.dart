import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MySettingScreen extends StatelessWidget {
  const MySettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            padding: EdgeInsets.only(bottom: size.height * 0.1),
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: size.height * 0.03,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Configure app preferences and storage',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Number',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Edit and manage the emergency contact who will be alerted with your location.',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            isScrollControlled: true,
                            builder: (_) => EmergencyNumberEditor(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Edit Emergency Number'),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Feedback & Rating',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        icon: Icon(Icons.feedback, color: Colors.white),
                        label: Text(
                          'Send Feedback',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'support@swasthyadoot.app',
                            queryParameters: {'subject': 'App Feedback'},
                          );
                          await launchUrl(emailLaunchUri);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        icon: Icon(Icons.star_rate, color: Colors.white),
                        label: Text(
                          'Rate This App',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          final url = Uri.parse(
                            'https://play.google.com/store/apps/details?id=com.example.swasthya_doot',
                          );
                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Help & Training Resources',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        leading: Icon(
                          Icons.ondemand_video,
                          color: Colors.redAccent,
                        ),
                        title: Text('Watch Training Videos'),
                        onTap: () async {
                          final url = Uri.parse(
                            'https://youtube.com/playlist?list=YOUR_PLAYLIST_ID',
                          );
                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.picture_as_pdf,
                          color: Colors.blueAccent,
                        ),
                        title: Text('Download PDF Guide'),
                        onTap: () async {
                          final url = Uri.parse(
                            'https://yourdomain.com/swasthya_doot_guide.pdf',
                          );
                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                      ),
                      // ListTile(
                      //   leading: Icon(
                      //     Icons.question_answer,
                      //     color: Colors.green,
                      //   ),
                      //   title: Text('FAQs & Community Support'),
                      //   onTap: () async {
                      //     final url = Uri.parse(
                      //       'https://yourcommunityforum.com',
                      //     );
                      //     if (await canLaunchUrl(url)) {
                      //       await launchUrl(
                      //         url,
                      //         mode: LaunchMode.externalApplication,
                      //       );
                      //     }
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'App Information',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Version: 0.0.1'),
                      SizedBox(height: 4),
                      Text('© 2025 Ministry of Health, Government of India'),
                      SizedBox(height: 4),
                      Text('Developed for ASHA and ANM workers'),
                      Text('Developed by Vishesh panghal with ❤️'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmergencyNumberEditor extends StatefulWidget {
  const EmergencyNumberEditor({super.key});

  @override
  EmergencyNumberEditorState createState() => EmergencyNumberEditorState();
}

class EmergencyNumberEditorState extends State<EmergencyNumberEditor> {
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedNumber();
  }

  void _loadSavedNumber() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNumber = prefs.getString('emergency_number') ?? '';
    phoneController.text = savedNumber;
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Edit Emergency Number",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: 'Enter emergency phone number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();

              final input = phoneController.text.trim();

              await prefs.setString('emergency_number', input);

              debugPrint("📞 Emergency number saved: $input");

              if (!context.mounted) return;
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade400,
              foregroundColor: Colors.white,
            ),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
