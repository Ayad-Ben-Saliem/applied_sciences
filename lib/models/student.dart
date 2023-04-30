import 'package:applied_sciences/models/user.dart';
import 'package:applied_sciences/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'student.g.dart';

abstract class StudentBase extends Equatable {
  final Id? id;

  final String name;

  @Index(unique: true)
  final String studentId;

  final String? photo;
  final DateTime? birthdate;
  final String? personalId;
  final String? passportNo;
  final String? nationalId;

  final DateTime? graduateDate;
  final double? grade;
  final double? percentage;

  final List<String> media;

  final DateTime? at;

  final _by = IsarLink<User>();

  @ignore
  User? get by => _by.value;

  @ignore
  final int version;

  StudentBase({
    this.id,
    required this.name,
    required this.studentId,
    this.photo,
    this.birthdate,
    this.personalId,
    this.passportNo,
    this.nationalId,
    this.graduateDate,
    this.grade,
    this.percentage,
    List<String> media = const [],
    this.at,
    User? by,
    this.version = -1,
  }) : media = List.unmodifiable(media) {
    _by.value = by;
  }

  StudentBase.fromJson(JsonMap json)
      : id = json['id'],
        name = json['name'],
        studentId = json['studentId'],
        photo = json['photo'],
        birthdate = DateTime.tryParse(json['birthdate']),
        personalId = json['personalId'],
        passportNo = json['passportNo'],
        nationalId = json['nationalId'],
        graduateDate = DateTime.tryParse(json['graduateDate']),
        grade = json['grade'],
        percentage = json['percentage'],
        media = List.unmodifiable(json['media']),
        at = DateTime.tryParse(json['at']),
        version = json['version'] {
    _by.value = User.fromJson(json['user']);
  }

  @ignore
  JsonMap get toJson => {
        'id': id,
        'name': name,
        'studentId': studentId,
        'photo': photo,
        'birthdate': birthdate?.toIso8601String(),
        'personalId': personalId,
        'passportNo': passportNo,
        'nationalId': nationalId,
        'graduateDate': graduateDate?.toIso8601String(),
        'grade': grade,
        'percentage': percentage,
        'media': media,
        'at': at?.toIso8601String(),
        'by': by?.toJson,
        'version': version,
      };

  @ignore
  @override
  List<Object?> get props => [
        id,
        name,
        studentId,
        photo,
        birthdate,
        personalId,
        passportNo,
        nationalId,
        graduateDate,
        grade,
        percentage,
        ...media,
        at,
        by,
        version,
      ];

  JsonMap compare(StudentBase other) {
    if (this == other) return {};
    return {
      if (name != other.name) 'name': name,
      if (studentId != other.studentId) 'studentId': studentId,
      if (photo != other.photo) 'photo': photo,
      if (birthdate != other.birthdate) 'birthdate': birthdate,
      if (personalId != other.personalId) 'personalId': personalId,
      if (passportNo != other.passportNo) 'name': passportNo,
      if (nationalId != other.nationalId) 'nationalId': nationalId,
      if (graduateDate != other.graduateDate) 'graduateDate': graduateDate,
      if (grade != other.grade) 'grade': grade,
      if (percentage != other.percentage) 'percentage': percentage,
      if (!media.equals(other.media)) 'media': media,
    };
  }
}

@Collection(
  accessor: 'Students',
  ignore: {'props', 'hashCode', 'stringify', 'version'},
)
class Student extends StudentBase {
  Student({
    super.id,
    required super.name,
    required super.studentId,
    super.photo,
    super.birthdate,
    super.personalId,
    super.passportNo,
    super.nationalId,
    super.graduateDate,
    super.grade,
    super.percentage,
    List<String> media = const [],
    super.version,
    super.at,
    User? by,
  }) : super(media: media, by: by);

  Student.fromJson(JsonMap json) : super.fromJson(json);

  Student copyWith({
    Id? id,
    String? name,
    String? studentId,
    String? photo,
    DateTime? birthdate,
    String? personalId,
    String? passportNo,
    String? nationalId,
    DateTime? graduateDate,
    double? grade,
    double? percentage,
    List<String>? media,
    int? version,
    DateTime? at,
    User? by,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      studentId: studentId ?? this.studentId,
      photo: photo ?? this.photo,
      birthdate: birthdate ?? this.birthdate,
      personalId: personalId ?? this.personalId,
      passportNo: passportNo ?? this.passportNo,
      nationalId: nationalId ?? this.nationalId,
      graduateDate: graduateDate ?? this.graduateDate,
      grade: grade ?? this.grade,
      percentage: percentage ?? this.percentage,
      media: media ?? this.media,
      version: version ?? this.version,
      at: at,
      by: by,
    );
  }

  @Index()
  @override
  Id? get id => super.id;
}

@Collection(
  accessor: 'StudentsHistory',
  ignore: {'props', 'hashCode', 'stringify', 'version'},
)
class StudentHistory implements StudentBase {
  StudentHistory({
    int? id,
    required String name,
    required String studentId,
    String? photo,
    DateTime? birthdate,
    String? personalId,
    String? passportNo,
    String? nationalId,
    DateTime? graduateDate,
    double? grade,
    double? percentage,
    List<String> media = const [],
    DateTime? at,
    User? by,
    int version = -1,
  }) : student = Student(
          id: id,
          name: name,
          studentId: studentId,
          photo: photo,
          birthdate: birthdate,
          personalId: personalId,
          passportNo: passportNo,
          nationalId: nationalId,
          graduateDate: graduateDate,
          grade: grade,
          percentage: percentage,
          media: media,
          version: version,
        );

  factory StudentHistory.from(Student student) => StudentHistory(
        id: student.id,
        name: student.name,
        studentId: student.studentId,
        photo: student.photo,
        birthdate: student.birthdate,
        personalId: student.personalId,
        passportNo: student.passportNo,
        nationalId: student.nationalId,
        graduateDate: student.graduateDate,
        grade: student.grade,
        percentage: student.percentage,
        media: student.media,
        version: student.version,
      );

  StudentHistory.fromJson(JsonMap json) : student = Student.fromJson(json);

  @override
  JsonMap compare(StudentBase other) => student.compare(other);

  StudentBase copyWith({
    int? id,
    String? name,
    String? studentId,
    String? photo,
    DateTime? birthdate,
    String? personalId,
    String? passportNo,
    String? nationalId,
    DateTime? graduateDate,
    double? grade,
    double? percentage,
    List<String>? media,
    int? version,
  }) =>
      student.copyWith(
        id: id,
        name: name,
        studentId: studentId,
        photo: photo,
        birthdate: birthdate,
        personalId: personalId,
        passportNo: passportNo,
        nationalId: nationalId,
        graduateDate: graduateDate,
        grade: grade,
        percentage: percentage,
        media: media,
        version: version,
      );

  @ignore
  final Student student;

  @Index()
  Id? get objectId => Isar.autoIncrement;

  @override
  int? get id => student.id;

  @override
  String get name => student.name;

  @override
  String get studentId => student.studentId;

  @override
  String? get photo => student.photo;

  @override
  DateTime? get birthdate => student.birthdate;

  @override
  String? get personalId => student.personalId;

  @override
  String? get nationalId => student.nationalId;

  @override
  String? get passportNo => student.passportNo;

  @override
  double? get grade => student.grade;

  @override
  DateTime? get graduateDate => student.graduateDate;

  @override
  double? get percentage => student.percentage;

  @override
  List<String> get media => student.media;

  @override
  DateTime? get at => student.at;

  @ignore
  @override
  IsarLink<User> get _by => student._by;

  int? get userId => _by.value?.id;

  @ignore
  @override
  JsonMap get toJson => student.toJson;

  @ignore
  @override
  int get version => student.version;

  @ignore
  @override
  List<Object?> get props => student.props;

  @ignore
  @override
  bool? get stringify => student.stringify;

  @ignore
  @override
  User? get by => student.by;
}
