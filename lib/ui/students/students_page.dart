import 'dart:convert';

import 'package:applied_sciences/services/students_service.dart';
import 'package:applied_sciences/ui/custom_dialog.dart';
import 'package:applied_sciences/ui/custom_switch.dart';
import 'package:applied_sciences/ui/students/student_history_view.dart';
import 'package:applied_sciences/ui/students/student_view.dart';
import 'package:applied_sciences/utils.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applied_sciences/models/student.dart';
import 'package:applied_sciences/ui/students/student_form.dart';

final students = StreamProvider((ref) => StudentsService.getStudents());

class StudentsPage extends StatelessWidget {
  const StudentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Students Page')),
      body: Column(
        children: [
          _buttons(),
          const Divider(height: 0),
          Expanded(child: _studentsView()),
        ],
      ),
    );
  }

  Widget _buttons() {
    return Builder(builder: (context) {
      return Row(
        children: [
          _button(
            onPressed: () => _addEditStudentDialog(context),
            child: Column(
              children: const [
                Icon(Icons.add),
                Text('Add Student'),
              ],
            ),
          ),
          _button(
            onPressed: () => _importStudents(context),
            child: Column(
              children: const [
                Icon(Icons.arrow_downward),
                Text('Import'),
              ],
            ),
          ),
          _button(
            onPressed: () => _exportStudentsDialog(context),
            child: Column(
              children: const [
                Icon(Icons.arrow_upward),
                Text('Export'),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _button({required VoidCallback? onPressed, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }

  Widget _studentsView() {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(students).when(
              loading: () => const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(),
              ),
              data: (students) {
                return _studentsList(students);
              },
              error: (error, stackTrace) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('$error'),
                    ),
                    const Divider(),
                    ListView(
                      shrinkWrap: true,
                      children: [Text('$stackTrace')],
                    ),
                  ],
                );
              },
            );
      },
    );
  }

  Widget _studentsList(List<Student?> students) {
    return ListView.separated(
      itemCount: students.length,
      itemBuilder: (_, index) {
        if (students[index] == null) {
          return const Text('Student is null');
        }
        return _studentTile(students[index]!);
      },
      separatorBuilder: (_, index) => const Divider(
        height: 0,
        thickness: 0.5,
      ),
    );
  }

  Widget _studentTile(Student student) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () => _studentViewDialog(context, student),
        onDoubleTap: () => _addEditStudentDialog(context, student: student),
        child: ListTile(
          title: Text(student.name),
          subtitle: Text(student.studentId),
          trailing: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => StudentHistoryView(id: student.id!));
            },
            icon: Text('${student.version}'),
          ),
        ),
      );
    });
  }

  void _addEditStudentDialog(BuildContext context, {Student? student}) {
    showDialog(
      context: context,
      builder: (_) {
        return CustomDialog(child: StudentForm(student: student));
      },
    );
  }

  void _studentViewDialog(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (_) {
        return CustomDialog(child: StudentView(student));
      },
    );
  }

  void _importStudents(BuildContext context) {
    FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'],
    ).then((result) {
      if (result != null) {
        final file = result.files.first;
        if (file.bytes == null) return _showMessage(context, 'No data found');
        final students = <Student>[];

        switch (file.extension?.toLowerCase()) {
          case 'xls':
          case 'xlsx':
            var excel = Excel.decodeBytes(file.bytes!);
            for (final sheet in excel.sheets.values) {
              students.addAll(getStudents(sheet.rows));
            }
            break;
          }

        _importStudentsDialog(context, students);
      }
    });
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  List<JsonMap> tableToJson(List<List> data) {
    final header = data[0];
    if (!header.contains('name') || !header.contains('studentId')) {
      throw Exception('Invalid Data');
    }
    final result = <JsonMap>[];
    for (int i = 1; i < data.length; i++) {
      result.add(
        {for (int n = 0; n < header.length; n++) header[n]: data[i][n]},
      );
      // Utils.prettyPrint(result.last);
    }

    return result;
  }

  List<Student> getStudents(List data) {
    if (data is List<List>) data = tableToJson(data);
    if (data is! List<JsonMap>) {
      throw Exception(
        'Invalid data, '
        'expects List<JsonMap> or List<List> got ${data.runtimeType}',
      );
    }
    return [for (final obj in data) Student.fromJson(obj)];
  }

  void _importStudentsDialog(BuildContext context, List<Student> students) {
    if (students.isEmpty) {
      return _showMessage(context, 'Invalid data, no students to import');
    }
    showDialog(
      context: context,
      builder: (_) {
        return CustomDialog(
          child: Scaffold(
            appBar: AppBar(title: const Text('Import Students')),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Select which action you want to perform when student duplicate',
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomSwitch(
                        choice1: 'Ignore',
                        choice2: 'Replace',
                        choice1Color: Theme.of(context).colorScheme.primary,
                        choice2Color: Theme.of(context).colorScheme.primary,
                        onChange: (choice) {
                          // TODO: implement
                        },
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView.separated(
                    itemCount: students.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 0,
                      thickness: 0.5,
                    ),
                    itemBuilder: (context, index) {
                      final student = students[index];
                      return ListTile(
                        title: Text(student.name),
                        subtitle: Text(student.studentId),
                      );
                    },
                  ),
                ),
                const Divider(height: 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO
                        },
                        child: const Text('Import'),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _exportStudentsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return CustomDialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Chose Method ...'),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: Wrap(
                      // direction: maxWidth > 999 ? Axis.horizontal : Axis.vertical,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context, 'JSON'),
                            child: const SizedBox.square(
                              dimension: 100,
                              child: Center(child: Text('JSON')),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context, 'CSV'),
                            child: const SizedBox.square(
                              dimension: 100,
                              child: Center(child: Text('CSV')),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: null,
                            // onPressed: () => Navigator.pop(context, 'Excel'),
                            child: SizedBox.square(
                              dimension: 100,
                              child: Center(child: Text('Excel')),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: null,
                            // onPressed: () => Navigator.pop(context, 'XML'),
                            child: SizedBox.square(
                              dimension: 100,
                              child: Center(child: Text('XML')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
