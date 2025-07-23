import 'member_model.dart'; // Ensure this import exists

class FamilyModel {
  final String id; // 🔥 Add this
  final String head;
  final String phone;
  final String village;
  final String address;
  final String aashaId;
  final String? familyId;
  final List<MemberModel> members;

  FamilyModel({
    required this.id, // 🔥 Add this
    required this.head,
    required this.phone,
    required this.village,
    required this.address,
    required this.aashaId,
    this.familyId,
    this.members = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'head': head,
      'phone': phone,
      'village': village,
      'address': address,
      'aasha_id': aashaId,
      if (familyId != null) 'family_id': familyId,
      'members': members.map((e) => e.toMap()).toList(),
    };
  }

  factory FamilyModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return FamilyModel(
      id: id,
      head: map['head'] ?? '',
      phone: map['phone'] ?? '',
      village: map['village'] ?? '',
      address: map['address'] ?? '',
      aashaId: map['aasha_id'] ?? '',
      familyId: map['family_id'],
      members: (map['members'] as List<dynamic>? ?? [])
          .map((e) => MemberModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  FamilyModel copyWith({
    String? id,
    String? head,
    String? phone,
    String? village,
    String? address,
    String? aashaId,
    List<MemberModel>? members,
  }) {
    return FamilyModel(
      id: id ?? this.id,
      head: head ?? this.head,
      phone: phone ?? this.phone,
      village: village ?? this.village,
      address: address ?? this.address,
      aashaId: aashaId ?? this.aashaId,
      familyId: familyId,
      members: members ?? this.members,
    );
  }
}
