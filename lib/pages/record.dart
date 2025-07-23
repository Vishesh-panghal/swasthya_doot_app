import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:swasthya_doot/models/family_model.dart';
import 'package:swasthya_doot/models/member_model.dart';
import 'package:swasthya_doot/widgets/common_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

  bool _filterPregnant = false;
  bool _filterSugar = false;
  bool _filterAgeAbove60 = false;
  bool _age0to5 = false;
  bool _age0to15 = false;

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    final familiesToExport = _families.where((family) {
      final filteredMembers = family.members.where((member) {
        if (_filterPregnant && !member.isPragnent) return false;
        if (_filterSugar && !member.isSugar) return false;
        if (_filterAgeAbove60 && member.age <= 60) return false;
        if (_age0to5 && (member.age < 0 || member.age > 5)) return false;
        if (_age0to15 && (member.age < 0 || member.age > 15)) return false;
        return true;
      }).toList();
      return filteredMembers.isNotEmpty || !(_filterPregnant || _filterSugar || _filterAgeAbove60 || _age0to5 || _age0to15);
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'Swasthya Doot Family Records',
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          ...familiesToExport.map((family) {
            final filteredMembers = family.members.where((member) {
              if (_filterPregnant && !member.isPragnent) return false;
              if (_filterSugar && !member.isSugar) return false;
              if (_filterAgeAbove60 && member.age <= 60) return false;
              if (_age0to5 && (member.age < 0 || member.age > 5)) return false;
              if (_age0to15 && (member.age < 0 || member.age > 15)) return false;
              return true;
            }).toList();

            return pw.Container(
              margin: const pw.EdgeInsets.symmetric(vertical: 12),
              padding: const pw.EdgeInsets.all(14),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey500),
                borderRadius: pw.BorderRadius.circular(8),
                color: PdfColors.grey100,
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Family Head: ${family.head}',
                      style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 4),
                  pw.Text('Phone: ${family.phone}'),
                  pw.Text('Village: ${family.village}'),
                  pw.Text('Address: ${family.address}'),
                  pw.SizedBox(height: 10),
                  if (filteredMembers.isNotEmpty) ...[
                    pw.Text('Family Members:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 6),
                    pw.Table.fromTextArray(
                      headers: ['Name', 'Age', 'Sex', 'Sugar', 'Pregnant', 'TB'],
                      data: filteredMembers.map((m) {
                        return [
                          m.name,
                          m.age.toString(),
                          m.sex,
                          m.isSugar ? 'Yes' : 'No',
                          m.isPragnent ? 'Yes' : 'No',
                          m.isTB ? 'Yes' : 'No',
                        ];
                      }).toList(),
                      border: null,
                      headerStyle: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                      headerDecoration: const pw.BoxDecoration(
                        color: PdfColors.blue600,
                      ),
                      cellAlignment: pw.Alignment.centerLeft,
                      cellStyle: const pw.TextStyle(fontSize: 10),
                    ),
                  ] else
                    pw.Text('No members match filter.'),
                ],
              ),
            );
          }),
        ],
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final file = File("${tempDir.path}/family_report.pdf");
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/pdf')],
      text: "Swasthya Doot Family Report",
    );
  }

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
    final aashaId = uid;

    Query familiesQuery = FirebaseFirestore.instance.collection('families');

    if (role == 'ANM' && village != null) {
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
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 30,
            ),
            child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Family Records',
                      style: TextStyle(
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.picture_as_pdf, color: Colors.red),
                      tooltip: 'Generate PDF',
                      onPressed: _generatePdf,
                    ),
                  ),
                ],
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
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => StatefulBuilder(
                          builder: (context, setModalState) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Apply Filters", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      FilterChip(
                                        label: const Text('Pregnant'),
                                        selected: _filterPregnant,
                                        onSelected: (val) {
                                          setModalState(() => _filterPregnant = val);
                                          setState(() => _filterPregnant = val);
                                        },
                                      ),
                                      FilterChip(
                                        label: const Text('Sugar'),
                                        selected: _filterSugar,
                                        onSelected: (val) {
                                          setModalState(() => _filterSugar = val);
                                          setState(() => _filterSugar = val);
                                        },
                                      ),
                                      FilterChip(
                                        label: const Text('Age > 60'),
                                        selected: _filterAgeAbove60,
                                        onSelected: (val) {
                                          setModalState(() => _filterAgeAbove60 = val);
                                          setState(() => _filterAgeAbove60 = val);
                                        },
                                      ),
                                      FilterChip(
                                        label: const Text('Age 0-5'),
                                        selected: _age0to5,
                                        onSelected: (val) {
                                          setModalState(() => _age0to5 = val);
                                          setState(() => _age0to5 = val);
                                        },
                                      ),
                                      FilterChip(
                                        label: const Text('Age 0-15'),
                                        selected: _age0to15,
                                        onSelected: (val) {
                                          setModalState(() => _age0to15 = val);
                                          setState(() => _age0to15 = val);
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    child: const Text("Close"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
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
                          final filteredMembers = family.members.where((member) {
                            if (_filterPregnant && !(member.isPragnent)) return false;
                            if (_filterSugar && !(member.isSugar)) return false;
                            if (_filterAgeAbove60 && member.age <= 60) return false;
                            if (_age0to5 && (member.age < 0 || member.age > 5)) return false;
                            if (_age0to15 && (member.age < 0 || member.age > 15)) return false;
                            return true;
                          }).toList();

                          if (filteredMembers.isEmpty &&
                              (_filterPregnant || _filterSugar || _filterAgeAbove60 || _age0to5 || _age0to15)) {
                            return const SizedBox();
                          }

                          return MembersCard(
                            name: family.head,
                            phone: family.phone,
                            date: "", // add if needed
                            village: family.village,
                            time: "",
                            address: family.address,
                            aashaId: family.aashaId,
                            members: filteredMembers,
                            onAddMember: (newMember) async {
                              List<MemberModel> updatedMembers = [];
                              setState(() {
                                updatedMembers = List<MemberModel>.from(
                                  family.members,
                                )..add(newMember);
                                final updatedFamily = family.copyWith(
                                  members: updatedMembers,
                                );
                                final index = _families.indexOf(family);
                                _families[index] = updatedFamily;
                              });

                              try {
                                await FirebaseFirestore.instance
                                    .collection('families')
                                    .doc(family.id)
                                    .update({
                                  'members': updatedMembers.map((e) => e.toMap()).toList(),
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error saving member: $e')),
                                );
                              }
                            },
                            onRefresh: () async {
                              await fetchFamilies();
                            },
                          );
                        }).toList(),
                  ),
            ],
          ),
        ),
      ),
    ));
  }
}