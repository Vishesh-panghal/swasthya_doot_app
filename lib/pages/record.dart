import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:swasthya_doot/models/family_model.dart';
import 'package:swasthya_doot/models/member_model.dart';
import 'package:swasthya_doot/widgets/common_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyRecordScreen extends StatefulWidget {
  const MyRecordScreen({super.key});

  @override
  State<MyRecordScreen> createState() => _MyRecordScreenState();
}

class _MyRecordScreenState extends State<MyRecordScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  List<FamilyModel> _families = [];
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    fetchFamilies();
  }

  Future<void> fetchFamilies() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!userDoc.exists) return;

    final userData = userDoc.data()!;
    final role = userData['role'];
    final village = userData['village'];
    final area = userData['area'];
    final aashaId = uid;

    Query familiesQuery = FirebaseFirestore.instance.collection('families');

    if (role == 'ANM') {
      familiesQuery = familiesQuery.where('village', isEqualTo: village);
    } else if (role == 'ASHA') {
      familiesQuery = familiesQuery.where('aasha_id', isEqualTo: aashaId);
    }

    final querySnapshot = await familiesQuery.get();
    final families =
        querySnapshot.docs
            .map(
              (doc) => FamilyModel.fromMap(
                doc.data() as Map<String, dynamic>,
                id: doc.id,
              ),
            )
            .toList();

    setState(() {
      _userRole = role;
      _families = families;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          child: ListView(
            children: [
              Text(
                'Family Records',
                style: TextStyle(
                  fontSize: size.height * 0.03,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'View and manage family member records',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              Gap(size.height * 0.02),
              CustomTextField(
                inData: 'Search by patient name or ID',
                title: '',
                size: size.height * 0.08,
                icn: Icons.search_rounded,
              ),
              Gap(size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_userRole == 'ASHA')
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blue.shade600,
                      ),
                      onPressed: () async {
                        final newFamily =
                            await showModalBottomSheet<FamilyModel>(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => const AddFamilyHeadForm(),
                            );

                        if (newFamily != null) {
                          setState(() {
                            _families.add(newFamily);
                          });
                        }
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.orange.shade600,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Filter',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(size.height * 0.02),
              _families.isEmpty
                  ? Lottie.asset(
                    'assets/animations/heart_beat.json',
                    controller: _controller,
                    onLoaded: (composition) {
                      _controller
                        ..duration = composition.duration * 2
                        ..repeat();
                    },
                  )
                  : Column(
                    children:
                        _families.map((family) {
                          return MembersCard(
                            name: family.head,
                            phone: family.phone,
                            date: "", // add if needed
                            village: family.village,
                            time: "",
                            address: family.address,
                            aashaId: family.aashaId,
                            members: family.members,
                            onAddMember: (newMember) {
                              setState(() {
                                final updatedMembers = List<MemberModel>.from(
                                  family.members,
                                )..add(newMember);
                                final updatedFamily = family.copyWith(
                                  members: updatedMembers,
                                );
                                final index = _families.indexOf(family);
                                _families[index] = updatedFamily;
                              });
                            },
                          );
                        }).toList(),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}