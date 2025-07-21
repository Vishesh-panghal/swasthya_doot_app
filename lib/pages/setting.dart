import 'package:flutter/material.dart';
import 'package:swasthya_doot/widgets/common_widget.dart';

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
            padding: EdgeInsets.only(bottom: size.height*0.1),
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
                        'Network',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ListTile(
                        leading: Icon(Icons.wifi, color: Colors.green),
                        title: Text('Connected to network'),
                        subtitle: Text('All features available'),
                      ),
                      SwitchListTile(
                        title: Text('Offline Mode'),
                        subtitle: Text('Force offline mode to save data'),
                        value: false,
                        onChanged: (val) {},
                      ),
                      SwitchListTile(
                        title: Text('Auto Sync'),
                        subtitle: Text('Automatically sync when online'),
                        value: true,
                        onChanged: (val) {},
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Storage section
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
                        'Storage',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Used Storage  24.5 / 500 MB'),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(value: 24.5 / 500),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.storage),
                              Text(
                                'Database\n16.2 MB',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.lock_outline),
                              Text(
                                'Media Cache\n8.3 MB',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: Text('Cache Images'),
                        subtitle: Text('Store images offline for faster access'),
                        value: true,
                        onChanged: (val) {},
                      ),
                      CustomElevatedButton(
                        text: 'Clear Cache',
                        onPressed: () {},
                        backgroundClr: Colors.blue,
                        textClr: Colors.white,
                      ),
                    ],
                  ),
                ),
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
                        'Notifications',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SwitchListTile(
                        title: Text('Push Notifications'),
                        subtitle: Text('Receive alerts and reminders'),
                        value: true,
                        onChanged: (val) {},
                      ),
                      SwitchListTile(
                        title: Text('Speech Feedback'),
                        subtitle: Text('Read responses aloud'),
                        value: true,
                        onChanged: (val) {},
                      ),
                    ],
                  ),
                ),
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
                        'App Information',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Version: 0.0.1'),
                      const SizedBox(height: 4),
                      Text('© 2025 Ministry of Health, Government of India'),
                      const SizedBox(height: 4),
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
