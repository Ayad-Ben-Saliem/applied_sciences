import 'package:applied_sciences/models/student.dart';
import 'package:applied_sciences/storage/db.dart';
import 'package:isar/isar.dart';

abstract class StudentsService {
  static Future<Student> _getStudentHistory(Id id, int version) async {
    var history = await db.writeTxn(
      () => db.StudentsHistory.filter().idEqualTo(id).sortByAt().findAll(),
    );
    return history[version].student.copyWith(version: version);
  }

  static Future<int> _getStudentVersion(Id id) async {
    return _getStudentVersionSync(id);
  }

  static int _getStudentVersionSync(Id id) {
    var history =
        db.StudentsHistory.filter().idEqualTo(id).sortByAt().findAllSync();
    return history.length + 1;
  }

  static Future<Student?> getStudent(Id id, {int? version}) async {
    var student = await db.writeTxn(() => db.Students.get(id));
    if (student != null && version != null) {
      if (student.version < version) return null;
      if (student.version > version) return _getStudentHistory(id, version);
    }
    return student?.copyWith(version: await _getStudentVersion(id));
  }

  static Stream<List<Student?>> _getStudents({List<Id>? ids}) async* {
    if (ids != null) {
      yield await db.writeTxn(() => db.Students.getAll(ids));
    }
    yield await db.writeTxn(() => db.Students.where().findAll());
    yield* db.Students.where().build().watch();
  }

  static Stream<List<Student?>> getStudents({List<Id>? ids}) async* {
    yield* _getStudents(ids: ids).map((students) => [
          for (final student in students)
            student?.copyWith(version: _getStudentVersionSync(student.id!)),
        ]);
  }

  static Future<List<Student?>> getAllStudentHistory(int id) async {
    var history = await db.writeTxn(
      () => db.StudentsHistory.filter().idEqualTo(id).sortByAt().findAll(),
    );
    var n = history.length;
    return history
        .map((history) => history.student.copyWith(version: n--))
        .toList();
  }

  static Future<List<Student?>> getAllStudents(int id) async {
    final result = [await getStudent(id)];
    if (result[0] != null) {
      return result..addAll(await getAllStudentHistory(id));
    }
    return [];
  }

  static Future<Student> upsertStudent(Student student) async {
    if (student.id != null) {
      final student0 = await getStudent(student.id!);
      if (student0 != null) {
        if (student0 == student) {
          // Nothing to be updated
          return student0;
        } else {
          _insertStudentHistory(StudentHistory.from(student0));
        }
      }
    }

    student = student.copyWith(at: DateTime.now());
    return db.writeTxn(
      () async => student.copyWith(id: await db.Students.put(student)),
    );
  }

  static _insertStudentHistory(StudentHistory studentHistory) async {
    return db.writeTxn(() => db.StudentsHistory.put(studentHistory));
  }
}
