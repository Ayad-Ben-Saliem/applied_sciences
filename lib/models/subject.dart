import 'package:applied_sciences/models/student.dart';
import 'package:applied_sciences/models/user.dart';
import 'package:applied_sciences/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'subject.g.dart';

abstract class SubjectBase extends Equatable {
  @Index(unique: true)
  final Id? id;

  final String name;

  final int units;

  final DateTime? at;

  final by = IsarLink<User>();

  @ignore
  final int version;

  SubjectBase({
    this.id,
    required this.name,
    required this.units,
    List<Student>? students,
    this.at,
    User? by,
    this.version = -1,
  }) {
    this.by.value = by;
  }


  @ignore
  JsonMap get toJson => {
    'id': id,
    'name': name,
    'units': units,
    'at': at?.toIso8601String(),
    'by': by.value?.toJson,
    'version': version,
  };

  @ignore
  @override
  List<Object?> get props => [
    id,
    name,
    units,
    at,
    by.value,
    version,
  ];

  @override
  bool? get stringify => true;
}

@Collection(
  accessor: 'Subjects',
  ignore: {'props', 'hashCode', 'stringify', 'version'},
)
class Subject extends SubjectBase {
  Subject({
    super.id,
    required super.name,
    required super.units,
    super.students,
    super.at,
    super.by,
    super.version = -1,
  });

  Subject copyWith({
    Id? id,
    String? name,
    int? units,
    List<Student>? students,
    DateTime? at,
    User? by,
    int? version,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      units: units ?? this.units,
      at: at ?? this.at,
      by: by ?? this.by.value,
      version: version ?? this.version,
    );
  }
}

@Collection(
  accessor: 'SubjectsHistory',
  ignore: {'props', 'hashCode', 'stringify', 'version'},
)
class SubjectHistory extends SubjectBase {
  final int subjectId;

  SubjectHistory({
    super.id,
    required this.subjectId,
    required super.name,
    required super.units,
    super.students,
    super.at,
    super.by,
    super.version = -1,
  });

  factory SubjectHistory.from(Subject subject) => SubjectHistory(
    subjectId: subject.id!,
    name: subject.name,
    units: subject.units,
    by: subject.by.value,
    at: subject.at,
    version: subject.version,
  );

  SubjectHistory copyWith({
    Id? id,
    int? subjectId,
    String? name,
    int? units,
    List<Student>? students,
    DateTime? at,
    User? by,
    int? version,
  }) {
    return SubjectHistory(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      name: name ?? this.name,
      units: units ?? this.units,
      at: at ?? this.at,
      by: by ?? this.by.value,
      version: version ?? this.version,
    );
  }

  @ignore
  Subject get subject {
    return Subject(
      id: subjectId,
      name: name,
      units: units,
      by: by.value,
      at: at,
      version: version,
    );
  }
}
