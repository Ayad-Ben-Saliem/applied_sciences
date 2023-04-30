import 'package:applied_sciences/models/student.dart';
import 'package:flutter/material.dart';

class StudentView extends StatelessWidget {
  final Student student;

  const StudentView(this.student, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(student.name, style: const TextStyle(fontSize: 24)),
        Text(student.studentId),
      ],
    ));
  }
}
