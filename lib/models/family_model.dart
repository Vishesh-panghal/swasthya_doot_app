import 'member_model.dart'; // Ensure this import exists

class FamilyModel {
  final String head;
  final String phone;
  final String village;
  final String address;
  final String aashaId;
  final String? familyId;
  final List<MemberModel> members; // ✅ Add this line

  FamilyModel({
    required this.head,
    required this.phone,
    required this.village,
    required this.address,
    required this.aashaId,
    this.familyId,
    this.members = const [], // ✅ Default to empty list
  });

  Map<String, dynamic> toMap() {
    return {
      'head': head,
      'phone': phone,
      'village': village,
      'address': address,
      'aasha_id': aashaId,
      if (familyId != null) 'family_id': familyId,
      'members': members.map((e) => e.toMap()).toList(), // ✅ Add this
    };
  }

  factory FamilyModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return FamilyModel(
      head: map['head'] ?? '',
      phone: map['phone'] ?? '',
      village: map['village'] ?? '',
      address: map['address'] ?? '',
      aashaId: map['aasha_id'] ?? '',
      familyId: id ?? map['family_id'],
      members: (map['members'] as List<dynamic>? ?? [])
          .map((e) => MemberModel.fromMap(e as Map<String, dynamic>))
          .toList(), // ✅ Parse members
    );
  }

  FamilyModel copyWith({
  String? head,
  String? phone,
  String? village,
  String? address,
  String? aashaId,
  List<MemberModel>? members,
}) {
  return FamilyModel(
    head: head ?? this.head,
    phone: phone ?? this.phone,
    village: village ?? this.village,
    address: address ?? this.address,
    aashaId: aashaId ?? this.aashaId,
    members: members ?? this.members,
  );
}
}
