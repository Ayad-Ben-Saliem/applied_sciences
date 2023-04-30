import 'package:applied_sciences/models/semester.dart';
import 'package:applied_sciences/models/student.dart';
import 'package:applied_sciences/models/user.dart';
import 'package:isar/isar.dart';

final db = Isar.openSync([
  UserSchema,
  StudentSchema,
  StudentHistorySchema,
  SemesterSchema,
]);
