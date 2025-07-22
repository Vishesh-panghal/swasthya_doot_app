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

class MyDashboardScreen extends StatelessWidget {
  final Function(int)? onTabSelected;
  const MyDashboardScreen({super.key, this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.01,
            horizontal: size.width * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                onTap: () => onTabSelected?.call(1),
              ),
              Gap(size.height * 0.02),
              DashboardCard(
                title: 'Medicine Detection',
                subtitle: 'Identify medicines using your camera',
                icon: Icons.camera_alt_outlined,
                clr: Color(0xFFFA8900),
                onTap: () => onTabSelected?.call(2),
              ),
              Gap(size.height * 0.02),
              DashboardCard(
                title: 'Patient Records',
                subtitle: 'View and manage all patient interaction records',
                icon: Icons.description_outlined,
                clr: Color(0xFF4DB051),
                onTap: () => onTabSelected?.call(3),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: size.height * 0.2,
                    width: size.width * 0.9,
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
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        CustomListTileWidget(
                          title: '4 patients visited today',
                          workDay: 'Today',
                          icn: Icons.people,
                          backgroundClr: Colors.greenAccent.shade100,
                          clr: Colors.green,
                        ),
                        CustomListTileWidget(
                          title: 'Health camp scheduled',
                          workDay: 'Tomorrow',
                          icn: Icons.info_outline,
                          clr: Colors.blue,
                          backgroundClr: Colors.blue.shade200,
                        ),
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
              ),
            ],
          ),
        ),
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
