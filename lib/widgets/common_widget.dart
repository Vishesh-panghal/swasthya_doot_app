// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swasthya_doot/models/family_model.dart';
import 'package:swasthya_doot/models/member_model.dart';

class NameLogoWidget extends StatelessWidget {
  Size size;
  NameLogoWidget({required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset('assets/logo.svg', width: 100, height: 100),
        Gap(size.height * 0.02),
        Text(
          'Swasthya Doot',
          style: GoogleFonts.roboto(
            fontSize: size.width * 0.08,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
            wordSpacing: 2,
          ),
        ),
        Text(
          'ASHA & ANM Companion App',
          style: GoogleFonts.openSans(
            fontSize: size.width * 0.04,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String inData;
  final String? title;
  final double size;
  final IconData? icn;
  final String? initialValue;
  final bool isEnabled;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;

  const CustomTextField({
    required this.inData,
    required this.size,
    this.title,
    this.icn,
    this.initialValue,
    this.isEnabled = true,
    this.onChanged,
    this.controller,
    this.focusNode,
    this.keyboardType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController internalController = TextEditingController(
      text: initialValue,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? "",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const Gap(8),
        TextField(
          controller: controller ?? internalController,
          focusNode: focusNode,
          textDirection: TextDirection.ltr,
          enabled: isEnabled,
          keyboardType: keyboardType ?? TextInputType.text,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            labelText: inData,
            prefixIcon: Icon(icn, size: 20),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0),
            ),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundClr;
  final Color textClr;
  final IconData? icn;
  final double fontSize;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final bool showIcon;

  const CustomElevatedButton({
    required this.text,
    required this.onPressed,
    required this.backgroundClr,
    required this.textClr,
    this.icn,
    this.fontSize = 16,
    this.iconSize = 22,
    this.padding = const EdgeInsets.symmetric(vertical: 14),
    this.showIcon = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundClr,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icn != null && showIcon) ...[
              Icon(icn, color: textClr, size: iconSize),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textClr,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SyncNotificationCard extends StatelessWidget {
  final int recordCount;
  final VoidCallback onSync;

  const SyncNotificationCard({
    super.key,
    required this.recordCount,
    required this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.notifications_none,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'You have $recordCount record(s) that need to be synced',
                        style: const TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
                Gap(6),
                GestureDetector(
                  onTap: onSync,
                  child: const Text(
                    'Sync Now',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color clr;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.clr,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: clr, width: 1),
        ),
        child: Row(
          children: [
            // Circular icon background
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF0F0F0),
              ),
              child: Icon(icon, color: Colors.black87),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListTileWidget extends StatelessWidget {
  String title;
  String workDay;
  IconData icn;
  final Color backgroundClr;
  final Color clr;
  CustomListTileWidget({
    required this.title,
    required this.workDay,
    required this.icn,
    required this.backgroundClr,
    required this.clr,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundClr),
        child: Icon(icn, color: clr),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      trailing: Text(workDay, style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class UsageTip extends StatelessWidget {
  final String text;
  const UsageTip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16, height: 1.4)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

//==================================================== MembersCard =========================================================== //
class MembersCard extends StatefulWidget {
  final String name;
  final String phone;
  final String date;
  final String village;
  final String address;
  final String aashaId;
  final List<MemberModel> members;
  final void Function(MemberModel) onAddMember;
  final VoidCallback? onRefresh;

  const MembersCard({
    super.key,
    required this.name,
    required this.phone,
    required this.date,
    required this.village,
    required this.address,
    required this.aashaId,
    required this.members,
    required this.onAddMember,
    this.onRefresh,
  });

  @override
  State<MembersCard> createState() => _MembersCardState();
}

class _MembersCardState extends State<MembersCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: Colors.blue, width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(widget.village),
                      ],
                    ),
                    Text(
                      "Phone: ${widget.phone}",
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.groups, size: 16, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text("${widget.members.length} members"),
                    ],
                  ),
                ),
              ],
            ),

            // Expand Toggle
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),

            // Expanded Details
            if (_expanded)
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.45,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      _infoRow('Family Head:', widget.name),
                      _infoRow('Phone:', widget.phone),
                      _infoRow('Village:', widget.village),
                      _infoRow('Address:', widget.address),
                      _infoRow('ASHA ID:', widget.aashaId),
                      const SizedBox(height: 8),
                      const Text(
                        'Family Members:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...widget.members.map(
                        (member) => _buildMemberCard(member),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.circle, size: 8, color: Colors.green),
                              SizedBox(width: 6),
                              Text(
                                'Synced',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              if (FirebaseAuth.instance.currentUser?.uid ==
                                  widget.aashaId)
                                TextButton(
                                  onPressed: () async {
                                    final updatedFamily =
                                        await showModalBottomSheet<FamilyModel>(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.white,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          builder:
                                              (context) => AddFamilyHeadForm(
                                                existingName: widget.name,
                                                existingPhone: widget.phone,
                                                existingAddress: widget.address,
                                              ),
                                        );
                                    if (updatedFamily != null) {
                                      setState(() {});
                                    }
                                  },
                                  child: const Text('Edit'),
                                ),
                              if (FirebaseAuth.instance.currentUser?.uid ==
                                  widget.aashaId)
                                TextButton(
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: const Text("Delete Family"),
                                            content: const Text(
                                              "Are you sure you want to delete this family and all its members?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      false,
                                                    ),
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      true,
                                                    ),
                                                child: const Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    );
                                    if (confirm == true) {
                                      await FirebaseFirestore.instance
                                          .collection("families")
                                          .where(
                                            "phone",
                                            isEqualTo: widget.phone,
                                          )
                                          .where(
                                            "aasha_id",
                                            isEqualTo: widget.aashaId,
                                          )
                                          .get()
                                          .then((snap) {
                                            for (final doc in snap.docs) {
                                              doc.reference.delete();
                                            }
                                          });
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Family deleted successfully",
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        widget.onRefresh?.call();
                                      }
                                    }
                                  },
                                  child: const Text(
                                    'Delete Head',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              const SizedBox(width: 6),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.red.shade600,
                                ),
                                onPressed: () async {
                                  final newMember =
                                      await showModalBottomSheet<MemberModel>(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.white,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                        ),
                                        builder:
                                            (context) => const AddMemberForm(),
                                      );
                                  if (newMember != null) {
                                    widget.onAddMember(newMember);
                                  }
                                },
                                child: const Text(
                                  'Add Member',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text('$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildMemberCard(MemberModel member) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                member.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  TextButton(
                    child: const Text("Edit", style: TextStyle(fontSize: 12)),
                    onPressed: () async {
                      final updatedMember =
                          await showModalBottomSheet<MemberModel>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder:
                                (context) =>
                                    AddMemberForm(existingMember: member),
                          );
                      if (updatedMember != null) {
                        setState(() {
                          final index = widget.members.indexOf(member);
                          if (index != -1) {
                            widget.members[index] = updatedMember;
                          }
                        });
                      }
                    },
                  ),
                  // --- Add Delete button for member ---
                  TextButton(
                    child: const Text(
                      "Delete",
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text("Delete Member"),
                              content: const Text(
                                "Are you sure you want to delete this member?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );

                      if (confirm == true) {
                        // Check if current user is ASHA for this family
                        if (FirebaseAuth.instance.currentUser?.uid !=
                            widget.aashaId) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Only ASHA can edit or delete this data.",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        // Remove locally, then refresh UI via onRefresh
                        widget.members.remove(member);
                        if (widget.onRefresh != null) {
                          widget.onRefresh!();
                        }

                        final snapshot =
                            await FirebaseFirestore.instance
                                .collection("families")
                                .where("phone", isEqualTo: widget.phone)
                                .where("aasha_id", isEqualTo: widget.aashaId)
                                .get();

                        for (final doc in snapshot.docs) {
                          final membersCollection = doc.reference.collection(
                            "members",
                          );
                          final query =
                              await membersCollection
                                  .where("name", isEqualTo: member.name)
                                  .where("aadhar", isEqualTo: member.aadhar)
                                  .where("relation", isEqualTo: member.relation)
                                  .get();

                          for (final mDoc in query.docs) {
                            await mDoc.reference.delete();
                          }

                          if (widget.onRefresh != null) {
                            widget.onRefresh!();
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Education: ${member.education}'),
              Text('Aadhar: ${member.aadhar}'),
            ],
          ),
          const SizedBox(height: 4),
          Text('${member.age} years, ${member.sex.toLowerCase()}'),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: -4,
            children: [
              if (member.isDisable)
                Chip(
                  label: Text("Disablity", style: TextStyle(fontSize: 12)),
                  backgroundColor: Colors.orange.shade100,
                ),
              if (member.isTB)
                Chip(
                  label: Text("TB", style: TextStyle(fontSize: 12)),
                  backgroundColor: Colors.blue.shade100,
                ),
              if (member.isSugar)
                Chip(
                  label: Text("Diabetes", style: TextStyle(fontSize: 12)),
                  backgroundColor: Colors.yellow.shade100,
                ),
              if (member.isPragnent)
                Chip(
                  label: Text("Pregenent", style: TextStyle(fontSize: 12)),
                  backgroundColor: Colors.orange.shade100,
                ),
              ...member.anyDisease.map(
                (disease) => Chip(
                  label: Text(disease, style: const TextStyle(fontSize: 12)),
                  backgroundColor: Colors.blue.shade100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text("Notes: ${member.other}", style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

String _formatTime(DateTime dt) {
  int hour = dt.hour;
  int minute = dt.minute;
  String period = hour >= 12 ? 'PM' : 'AM';
  hour = hour % 12;
  if (hour == 0) hour = 12;
  final minuteStr = minute.toString().padLeft(2, '0');
  return "$hour:$minuteStr $period";
}

// ================================================== AddFamilyHead Bottomsheet =================================================//

class AddFamilyHeadForm extends StatefulWidget {
  final String? existingName;
  final String? existingPhone;
  final String? existingAddress;

  const AddFamilyHeadForm({
    super.key,
    this.existingName,
    this.existingPhone,
    this.existingAddress,
  });

  @override
  State<AddFamilyHeadForm> createState() => _AddFamilyHeadFormState();
}

class _AddFamilyHeadFormState extends State<AddFamilyHeadForm> {
  final _formKey = GlobalKey<FormState>();
  final _headController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _headController.text = widget.existingName ?? '';
    _phoneController.text = widget.existingPhone ?? '';
    _addressController.text = widget.existingAddress ?? '';
  }

  @override
  void dispose() {
    _headController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid == null) return;

        final doc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        final village = doc.data()?['village'] ?? 'unknown';

        final family = FamilyModel(
          id: '',
          head: _headController.text.trim(),
          phone: _phoneController.text.trim(),
          village: village,
          address: _addressController.text.trim(),
          aashaId: uid,
          members: [],
        );

        await FirebaseFirestore.instance
            .collection('families')
            .add(family.toMap());

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('परिवार सफलतापूर्वक जोड़ा गया।'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, family);
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('कुछ गलत हो गया: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('कृपया सभी जरूरी जानकारी भरें।'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add New Family Head",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _headController,
                decoration: const InputDecoration(labelText: "Family Head *"),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Phone *"),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address *"),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Center(
                  child: Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================== AddFamily Members Bottomsheet  ==============================================//

class AddMemberForm extends StatefulWidget {
  final MemberModel? existingMember;
  const AddMemberForm({super.key, this.existingMember});

  @override
  State<AddMemberForm> createState() => _AddMemberFormState();
}

class _AddMemberFormState extends State<AddMemberForm> {
  final _formKey = GlobalKey<FormState>();
  String _sex = 'Male';
  String _relation = 'self';
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _educationController = TextEditingController();
  final _aadharController = TextEditingController();
  final _diseaseController = TextEditingController();
  final _otherController = TextEditingController();

  bool _isDisabled = false;
  bool _hasTB = false;
  bool _hasSugar = false;
  bool _isPragnent = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingMember != null) {
      final m = widget.existingMember!;
      _nameController.text = m.name;
      _ageController.text = m.age.toString();
      _sex = m.sex;
      _educationController.text = m.education;
      _aadharController.text = m.aadhar;
      _diseaseController.text = m.anyDisease.join(', ');
      _otherController.text = m.other;
      _isDisabled = m.isDisable;
      _hasTB = m.isTB;
      _hasSugar = m.isSugar;
      _isPragnent = m.isPragnent;
      _relation = m.relation;
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'कृपया सभी ज़रूरी जानकारी भरें (Please complete all required fields)',
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final member = MemberModel(
      name: _nameController.text.trim(),
      age: int.tryParse(_ageController.text.trim()) ?? 0,
      sex: _sex,
      isDisable: _isDisabled,
      isTB: _hasTB,
      isSugar: _hasSugar,
      isPragnent: _isPragnent,
      education: _educationController.text.trim(),
      anyDisease:
          _diseaseController.text
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList(),
      aadhar: _aadharController.text.trim(),
      other: _otherController.text.trim(),
      relation: _relation,
    );

    Navigator.pop(context, member);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = const SizedBox(height: 14);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Member",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Row: Name & Age
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Name *",
                        hintText: "Member name",
                      ),
                      validator:
                          (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Age *",
                        hintText: "Age",
                      ),
                      validator:
                          (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              spacing,

              // Row: Sex & Education
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _sex,
                      onChanged: (val) => setState(() => _sex = val ?? 'Male'),
                      decoration: const InputDecoration(labelText: "Sex *"),
                      items: const [
                        DropdownMenuItem(value: "Male", child: Text("Male")),
                        DropdownMenuItem(
                          value: "Female",
                          child: Text("Female"),
                        ),
                        DropdownMenuItem(value: "Other", child: Text("Other")),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _educationController,
                      decoration: const InputDecoration(
                        labelText: "Education",
                        hintText: "Education level",
                      ),
                    ),
                  ),
                ],
              ),
              spacing,

              // Aadhar
              TextFormField(
                controller: _aadharController,
                decoration: const InputDecoration(
                  labelText: "Aadhar Number",
                  hintText: "Aadhar number",
                ),
              ),
              spacing,
              DropdownButtonFormField<String>(
                value: _relation,
                onChanged: (val) => setState(() => _relation = val ?? 'self'),
                decoration: const InputDecoration(
                  labelText: "संबंध (Relation with Head) *",
                ),
                items: const [
                  DropdownMenuItem(value: "self", child: Text("खुद (Self)")),
                  DropdownMenuItem(
                    value: "husband",
                    child: Text("पति (Husband)"),
                  ),
                  DropdownMenuItem(value: "wife", child: Text("पत्नी (Wife)")),
                  DropdownMenuItem(value: "son", child: Text("बेटा (Son)")),
                  DropdownMenuItem(
                    value: "daughter",
                    child: Text("बेटी (Daughter)"),
                  ),
                  DropdownMenuItem(
                    value: "father",
                    child: Text("पिता (Father)"),
                  ),
                  DropdownMenuItem(
                    value: "mother",
                    child: Text("माता (Mother)"),
                  ),
                  DropdownMenuItem(value: "other", child: Text("अन्य (Other)")),
                ],
              ),
              spacing,
              // Health conditions
              const Text(
                "Health Conditions",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isDisabled,
                    onChanged: (v) => setState(() => _isDisabled = v ?? false),
                  ),
                  const Text("Disabled"),
                  Checkbox(
                    value: _hasTB,
                    onChanged: (v) => setState(() => _hasTB = v ?? false),
                  ),
                  const Text("TB"),
                  Checkbox(
                    value: _hasSugar,
                    onChanged: (v) => setState(() => _hasSugar = v ?? false),
                  ),
                  const Text("Diabetes"),
                  if (_sex == "Female") ...[
                    Checkbox(
                      value: _isPragnent,
                      onChanged:
                          (v) => setState(() => _isPragnent = v ?? false),
                    ),
                    const Text("Pregnant"),
                  ],
                ],
              ),
              spacing,

              // Other diseases
              const Text("अतिरिक्त बीमारी(Other Diseases)"),
              TextFormField(
                controller: _diseaseController,
                decoration: const InputDecoration(
                  hintText: "बिमारियों के नाम कॉमा से अलग करें",
                ),
              ),
              spacing,

              // Other notes
              const Text("अतिरिक्त जानकारी (Other Notes)"),
              TextFormField(
                controller: _otherController,
                decoration: const InputDecoration(
                  hintText: "Any other important notes",
                ),
              ),
              spacing,

              // Submit
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Center(
                  child: Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ====================================================== TypingIndicator ===================================================//

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 12,
            child: Text('🤖', style: TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 20, // increase height
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                DotBounce(delay: 0),
                SizedBox(width: 4),
                DotBounce(delay: 200),
                SizedBox(width: 4),
                DotBounce(delay: 400),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DotBounce extends StatefulWidget {
  final int delay;
  const DotBounce({super.key, required this.delay});

  @override
  State<DotBounce> createState() => _DotBounceState();
}

class _DotBounceState extends State<DotBounce>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: -4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder:
          (_, _) => Transform.translate(
            offset: Offset(0, _animation.value),
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
