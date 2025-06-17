import 'package:hive/hive.dart';

part 'employee_model.g.dart';

@HiveType(typeId: 0)
class EmployeeModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String designation;

  @HiveField(3)
  final String imgUrl;

  EmployeeModel({
    this.id = '',
    required this.name,
    required this.designation,
    required this.imgUrl,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: (json['id'] ?? '').toString(),
      name: json['employee_name'] ?? '',
      designation: json['designation'] ?? json['employee_name'] ?? '',
      imgUrl: json['profile_image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_name': name,
      'designation': designation,
      'profile_image': imgUrl,
    };
  }

  EmployeeModel copyWith({
    String? id,
    String? name,
    String? designation,
    String? imgUrl,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      designation: designation ?? this.designation,
      imgUrl: imgUrl ?? this.imgUrl,
    );
  }
}