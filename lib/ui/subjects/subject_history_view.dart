import 'package:intl/intl.dart';
import 'package:applied_sciences/models/subject.dart';
import 'package:applied_sciences/services/subjects_service.dart';
import 'package:applied_sciences/ui/custom_dialog.dart';
import 'package:flutter/material.dart';

class SubjectHistoryView extends StatelessWidget {
  final int id;

  const SubjectHistoryView({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SubjectsService.getAllSubjects(id),
      initialData: null,
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('${snapshot.error}');
        if (snapshot.hasData) {
          if (snapshot.data == null) {
            return const Text('No Subjects!!!');
          } else {
            return CustomDialog(
              child: _subjectsList(snapshot.data!),
            );
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _subjectsList(List<Subject?> subjects) {
    return ListView.separated(
      itemCount: subjects.length,
      itemBuilder: (_, index) {
        if (subjects[index] == null) {
          return const Text('Subject is null');
        }
        return _subjectTile(subjects[index]!);
      },
      separatorBuilder: (_, index) => const Divider(
        height: 0,
        thickness: 0.5,
      ),
    );
  }

  Widget _subjectTile(Subject subject) {
    final format = DateFormat.yMd().format;
    return Builder(
      builder: (context) {
        return ListTile(
          // onTap: () {
          //   showDialog(
          //     context: context,
          //     builder: (_) => CustomDialog(child: SubjectView(subject)),
          //   );
          // },
          title: Text(subject.name),
          subtitle: Text('${subject.units} Units'),
          trailing: Chip(label: Text('${subject.version}')),
        );
      },
    );
  }
}
