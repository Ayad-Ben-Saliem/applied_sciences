import 'package:applied_sciences/models/student.dart';
import 'package:applied_sciences/models/user.dart';
import 'package:applied_sciences/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'semester.g.dart';

abstract class SemesterBase extends Equatable {
  @Index(unique: true)
  final Id? id;

  final String name;

  final DateTime start;

  final DateTime end;

  final DateTime? at;

  final by = IsarLink<User>();

  @ignore
  final int version;

  SemesterBase({
    this.id,
    required this.name,
    required this.start,
    required this.end,
    List<Student>? students,
    this.at,
    User? by,
    this.version = -1,
  }) : assert(start.isBefore(end)) {
    // print(students.runtimeType);
    // students = students?.toList();
    // print(students.runtimeType);
    // print(students);
    this.by.value = by;
  }


  @ignore
  JsonMap get toJson => {
        'id': id,
        'name': name,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
        'at': at?.toIso8601String(),
        'by': by.value?.toJson,
        'version': version,
      };

  @ignore
  @override
  List<Object?> get props => [
        id,
        name,
        start,
        end,
        at,
        by.value,
        version,
      ];

  @override
  bool? get stringify => true;
}

@Collection(
  accessor: 'Semesters',
  ignore: {'props', 'hashCode', 'stringify', 'version'},
)
class Semester extends SemesterBase {
  Semester({
    super.id,
    required super.name,
    required super.start,
    required super.end,
    super.students,
    super.at,
    super.by,
    super.version = -1,
  });

  Semester copyWith({
    Id? id,
    String? name,
    DateTime? start,
    DateTime? end,
    List<Student>? students,
    DateTime? at,
    User? by,
    int? version,
  }) {
    return Semester(
      id: id ?? this.id,
      name: name ?? this.name,
      start: start ?? this.start,
      end: end ?? this.end,
      at: at ?? this.at,
      by: by ?? this.by.value,
      version: version ?? this.version,
    );
  }
}

@Collection(
  accessor: 'SemestersHistory',
  ignore: {'props', 'hashCode', 'stringify', 'version'},
)
class SemesterHistory extends SemesterBase {
  final int semesterId;

  SemesterHistory({
    super.id,
    required this.semesterId,
    required super.name,
    required super.start,
    required super.end,
    super.students,
    super.at,
    super.by,
    super.version = -1,
  });

  factory SemesterHistory.from(Semester semester) => SemesterHistory(
        semesterId: semester.id!,
        name: semester.name,
        start: semester.start,
        end: semester.end,
        by: semester.by.value,
        at: semester.at,
        version: semester.version,
      );

  SemesterHistory copyWith({
    Id? id,
    int? semesterId,
    String? name,
    DateTime? start,
    DateTime? end,
    List<Student>? students,
    DateTime? at,
    User? by,
    int? version,
  }) {
    return SemesterHistory(
      id: id ?? this.id,
      semesterId: semesterId ?? this.semesterId,
      name: name ?? this.name,
      start: start ?? this.start,
      end: end ?? this.end,
      at: at ?? this.at,
      by: by ?? this.by.value,
      version: version ?? this.version,
    );
  }

  @ignore
  Semester get semester {
    return Semester(
      id: semesterId,
      name: name,
      start: start,
      end: end,
      by: by.value,
      at: at,
      version: version,
    );
  }
}
