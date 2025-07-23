import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swasthya_doot/pages/askDidi.dart';
import 'package:swasthya_doot/pages/detect.dart';
import 'package:swasthya_doot/pages/record.dart';
import 'package:swasthya_doot/pages/setting.dart';
import 'package:swasthya_doot/pages/profile.dart';
import 'package:swasthya_doot/widgets/common_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:flutter/services.dart';

class MyDashboardScreen extends StatefulWidget {
  final Function(int)? onTabSelected;
  const MyDashboardScreen({super.key, this.onTabSelected});

  @override
  State<MyDashboardScreen> createState() => _MyDashboardScreenState();
}

class _MyDashboardScreenState extends State<MyDashboardScreen> {
  final QuickActions quickActions = const QuickActions();

  @override
  void initState() {
    super.initState();
    quickActions.setShortcutItems([
      const ShortcutItem(
        type: 'emergency',
        localizedTitle: 'Send Emergency',
        icon: 'icon_emergency', // ensure you add this asset in Android
      ),
    ]);

    quickActions.initialize((type) {
      if (type == 'emergency') {
        _sendEmergencyLocation();
      }
    });
  }

  Future<void> _sendEmergencyLocation() async {
    final locationStatus = await permission.Permission.location.request();

    if (locationStatus != permission.PermissionStatus.granted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permission is required.'),
        ),
      );
      return;
    }

    try {
      const platform = MethodChannel('emergency_channel');
      await platform.invokeMethod('startEmergencyService');

      // UI fallback: show confirmation
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🚨 Emergency background alert triggered")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to trigger emergency service: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            // added comma after opening parenthesis and before padding
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.01,
              horizontal: size.width * 0.03,
            ),
            children: [
              FutureBuilder<DocumentSnapshot>(
                future:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .get(),
                builder: (context, snapshot) {
                  String getGreeting() {
                    final hour = DateTime.now().hour;
                    if (hour < 12) return 'Good Morning';
                    if (hour < 17) return 'Good Afternoon';
                    return 'Good Evening';
                  }

                  String userName = 'User';

                  if (snapshot.hasData && snapshot.data!.exists) {
                    userName = snapshot.data!.get('fullName') ?? 'User';
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${getGreeting()}, $userName',
                        style: TextStyle(
                          fontSize: size.height * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyProfilePage(),
                              ),
                            ),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade200,
                                Colors.blue.shade600,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(
                                  (0.1 * 255).toInt(),
                                ),
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
                      ),
                    ],
                  );
                },
              ),
              Text(
                'Welcome to Swasthya Doot',
                style: TextStyle(
                  fontSize: size.height * 0.02,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              Gap(size.height * 0.02),
              SyncNotificationCard(recordCount: 3, onSync: () {}),
              Gap(size.height * 0.04),
              DashboardCard(
                title: 'Ask Didi',
                subtitle: 'Voice assistant for health information',
                icon: Icons.mic_none_rounded,
                clr: Color.fromARGB(255, 0, 97, 253),
                onTap: () => widget.onTabSelected?.call(1),
              ),
              Gap(size.height * 0.02),
              DashboardCard(
                title: 'Medicine Detection',
                subtitle: 'Identify medicines using your camera',
                icon: Icons.camera_alt_outlined,
                clr: Color(0xFFFA8900),
                onTap: () => widget.onTabSelected?.call(2),
              ),
              Gap(size.height * 0.02),
              DashboardCard(
                title: 'Patient Records',
                subtitle: 'View and manage all patient interaction records',
                icon: Icons.description_outlined,
                clr: Color(0xFF4DB051),
                onTap: () => widget.onTabSelected?.call(3),
              ),
              Gap(size.height * 0.03),
              Text(
                'Recent Activities',
                style: TextStyle(
                  fontSize: size.height * 0.03,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(size.height * 0.02),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CustomListTileWidget(
                      title: '4 members added today',
                      workDay: 'Today',
                      icn: Icons.people,
                      backgroundClr: Colors.greenAccent.shade100,
                      clr: Colors.green,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomListTileWidget(
                            title: 'Emergency',
                            workDay: '',
                            icn: Icons.warning_amber_rounded,
                            backgroundClr: Colors.red.shade100,
                            clr: Colors.redAccent,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ElevatedButton(
                            onPressed: _sendEmergencyLocation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 20,
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Send Location'),
                          ),
                        ),
                      ],
                    ),
                    Gap(size.height * 0.01),
                    CustomListTileWidget(
                      title: 'New guideline available',
                      workDay: '2 days ago',
                      icn: Icons.notifications_none,
                      clr: Colors.orange,
                      backgroundClr: Colors.orange.shade200,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> get _screens => [
    MyDashboardScreen(
      onTabSelected: (index) {
        setState(() => _selectedIndex = index);
      },
    ),
    MyAskDidiScreen(),
    MyDetectScreen(),
    MyRecordScreen(),
    MySettingScreen(),
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.mic,
    Icons.camera_alt_outlined,
    Icons.folder_copy_outlined,
    Icons.settings,
  ];

  final List<String> _labels = [
    'Home',
    'Ask Didi',
    'Detect',
    'Records',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          height: 65,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_icons.length, (index) {
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _icons[index],
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _labels[index],
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
