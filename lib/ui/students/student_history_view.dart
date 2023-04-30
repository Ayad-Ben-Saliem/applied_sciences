import 'package:applied_sciences/models/student.dart';
import 'package:applied_sciences/services/students_service.dart';
import 'package:applied_sciences/ui/custom_dialog.dart';
import 'package:applied_sciences/ui/students/student_view.dart';
import 'package:flutter/material.dart';

class StudentHistoryView extends StatelessWidget {
  final int id;

  const StudentHistoryView({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: StudentsService.getAllStudents(id),
      initialData: null,
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('${snapshot.error}');
        if (snapshot.hasData) {
          if (snapshot.data == null) {
            return const Text('No Students!!!');
          } else {
            return CustomDialog(
              child: _studentsList(snapshot.data!),
            );
          }
        } else {
          return const CircularProgressIndicator();
        }
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
    return Builder(
      builder: (context) {
        return ListTile(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => CustomDialog(child: StudentView(student)),
            );
          },
          title: Text(student.name),
          subtitle: Text(student.studentId),
          trailing: Chip(label: Text('${student.version}')),
        );
      },
    );
  }
}
