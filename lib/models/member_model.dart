


class MemberModel {
  final String name;
  final int age;
  final String sex;
  final bool isDisable;
  final bool isTB;
  final bool isSugar;
  final bool isPragnent;
  final String education;
  final List<String> anyDisease;
  final String aadhar;
  final String other;
  final String relation;

  MemberModel({
    required this.name,
    required this.age,
    required this.sex,
    required this.isDisable,
    required this.isTB,
    required this.isSugar,
    required this.isPragnent,
    required this.education,
    required this.anyDisease,
    required this.aadhar,
    required this.other,
    required this.relation,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'sex': sex,
      'isDisable': isDisable,
      'isTB': isTB,
      'isSugar': isSugar,
      'isPragnent': isPragnent,
      'education': education,
      'any_desease': anyDisease,
      'aadhar': aadhar,
      'other': other,
      'relation': relation,
    };
  }

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      sex: map['sex'] ?? '',
      isDisable: map['isDisable'] ?? false,
      isTB: map['isTB'] ?? false,
      isSugar: map['isSugar'] ?? false,
      isPragnent: map['isPragnent'] ?? false,
      education: map['education'] ?? '',
      anyDisease: List<String>.from(map['any_desease'] ?? []),
      aadhar: map['aadhar'] ?? '',
      other: map['other'] ?? '',
      relation: map['relation'] ?? '',
    );
  }
}