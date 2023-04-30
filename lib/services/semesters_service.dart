import 'package:applied_sciences/models/semester.dart';
import 'package:applied_sciences/storage/db.dart';
import 'package:isar/isar.dart';


abstract class SemestersService {

  static Future<Semester> _getSemesterHistory(Id id, int version) async {
    var history = await db.writeTxn(
          () => db.SemestersHistory.filter().idEqualTo(id).sortByAt().findAll(),
    );
    return history[version].semester.copyWith(version: version);
  }

  static Future<int> _getSemesterVersion(Id id) async {
    return _getSemesterVersionSync(id);
  }

  static int _getSemesterVersionSync(Id id) {
    var history =
    db.SemestersHistory.filter().idEqualTo(id).sortByAt().findAllSync();
    return history.length + 1;
  }

  static Future<Semester?> getSemester(Id id, {int? version}) async {
    var semester = await db.writeTxn(() => db.Semesters.get(id));
    if (semester != null && version != null) {
      if (semester.version < version) return null;
      if (semester.version > version) return _getSemesterHistory(id, version);
    }
    return semester?.copyWith(version: await _getSemesterVersion(id));
  }

  static Stream<List<Semester?>> _getSemesters({List<Id>? ids}) async* {
    if (ids != null) {
      yield await db.writeTxn(() => db.Semesters.getAll(ids));
    }
    yield await db.writeTxn(() => db.Semesters.where().findAll());
    yield* db.Semesters.where().build().watch();
  }

  static Stream<List<Semester?>> semesters({List<Id>? ids}) async* {
    yield* _getSemesters(ids: ids).map((semesters) => [
      for (final semester in semesters)
        semester?.copyWith(version: _getSemesterVersionSync(semester.id!)),
    ]);
  }

  static Future<List<Semester?>> getAllSemesterHistory(int id) async {
    var history = await db.writeTxn(
          () => db.SemestersHistory.filter().idEqualTo(id).sortByAt().findAll(),
    );
    var n = history.length;
    return history
        .map((history) => history.semester.copyWith(version: n--))
        .toList();
  }

  static Future<List<Semester?>> getAllSemesters(int id) async {
    final result = [await getSemester(id)];
    if (result[0] != null) {
      return result..addAll(await getAllSemesterHistory(id));
    }
    return [];
  }

  static Future<Semester> upsertSemester(Semester semester) async {
    if (semester.id != null) {
      final semester0 = await getSemester(semester.id!);
      if (semester0 != null) {
        if (semester0 == semester) {
          // Nothing to be updated
          return semester0;
        } else {
          _insertSemesterHistory(SemesterHistory.from(semester0));
        }
      }
    }

    semester = semester.copyWith(at: DateTime.now());
    return db.writeTxn(
          () async => semester.copyWith(id: await db.Semesters.put(semester)),
    );
  }

  static _insertSemesterHistory(SemesterHistory semesterHistory) async {
    return db.writeTxn(() => db.SemestersHistory.put(semesterHistory));
  }
}
