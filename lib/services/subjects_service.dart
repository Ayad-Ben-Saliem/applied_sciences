import 'package:applied_sciences/models/subject.dart';
import 'package:applied_sciences/storage/db.dart';
import 'package:isar/isar.dart';


abstract class SubjectsService {

  static Future<Subject> _getSubjectHistory(Id id, int version) async {
    var history = await db.writeTxn(
          () => db.SubjectsHistory.filter().idEqualTo(id).sortByAt().findAll(),
    );
    return history[version].subject.copyWith(version: version);
  }

  static Future<int> _getSubjectVersion(Id id) async {
    return _getSubjectVersionSync(id);
  }

  static int _getSubjectVersionSync(Id id) {
    var history =
    db.SubjectsHistory.filter().idEqualTo(id).sortByAt().findAllSync();
    return history.length + 1;
  }

  static Future<Subject?> getSubject(Id id, {int? version}) async {
    var subject = await db.writeTxn(() => db.Subjects.get(id));
    if (subject != null && version != null) {
      if (subject.version < version) return null;
      if (subject.version > version) return _getSubjectHistory(id, version);
    }
    return subject?.copyWith(version: await _getSubjectVersion(id));
  }

  static Stream<List<Subject?>> _getSubjects({List<Id>? ids}) async* {
    if (ids != null) {
      yield await db.writeTxn(() => db.Subjects.getAll(ids));
    }
    yield await db.writeTxn(() => db.Subjects.where().findAll());
    yield* db.Subjects.where().build().watch();
  }

  static Stream<List<Subject?>> subjects({List<Id>? ids}) async* {
    yield* _getSubjects(ids: ids).map((subjects) => [
      for (final subject in subjects)
        subject?.copyWith(version: _getSubjectVersionSync(subject.id!)),
    ]);
  }

  static Future<List<Subject?>> getAllSubjectHistory(int id) async {
    var history = await db.writeTxn(
          () => db.SubjectsHistory.filter().idEqualTo(id).sortByAt().findAll(),
    );
    var n = history.length;
    return history
        .map((history) => history.subject.copyWith(version: n--))
        .toList();
  }

  static Future<List<Subject?>> getAllSubjects(int id) async {
    final result = [await getSubject(id)];
    if (result[0] != null) {
      return result..addAll(await getAllSubjectHistory(id));
    }
    return [];
  }

  static Future<Subject> upsertSubject(Subject subject) async {
    if (subject.id != null) {
      final subject0 = await getSubject(subject.id!);
      if (subject0 != null) {
        if (subject0 == subject) {
          // Nothing to be updated
          return subject0;
        } else {
          _insertSubjectHistory(SubjectHistory.from(subject0));
        }
      }
    }

    subject = subject.copyWith(at: DateTime.now());
    return db.writeTxn(
          () async => subject.copyWith(id: await db.Subjects.put(subject)),
    );
  }

  static _insertSubjectHistory(SubjectHistory subjectHistory) async {
    return db.writeTxn(() => db.SubjectsHistory.put(subjectHistory));
  }
}
