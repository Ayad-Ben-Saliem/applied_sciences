import 'package:applied_sciences/models/subject.dart';
import 'package:applied_sciences/services/subjects_service.dart';
import 'package:applied_sciences/ui/custom_dialog.dart';
import 'package:applied_sciences/ui/subjects/subject_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subjects = StreamProvider((ref) => SubjectsService.subjects());

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subjects')),
      body: Column(
        children: [
          _buttons(),
          const Divider(height: 0),
          Expanded(child: _subjectsView()),
        ],
      ),
    );
  }

  Widget _buttons() {
    return Builder(builder: (context) {
      return Row(
        children: [
          _button(
            onPressed: () => _addEditSubjectDialog(context),
            child: Column(
              children: const [
                Icon(Icons.add),
                Text('Add Subject'),
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

  Widget _subjectsView() {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(subjects).when(
          loading: () => const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(),
          ),
          data: (subjects) {
            return _subjectsList(subjects);
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
    return Builder(
      builder: (context) {
        return InkWell(
          // onTap: () => _subjectViewDialog(context, subject),
          onDoubleTap: () =>
              _addEditSubjectDialog(context, subject: subject),
          child: ListTile(
            title: Text(subject.name),
            // subtitle: Text(subject.subjectId),
            trailing: IconButton(
              onPressed: () {
                // showDialog(
                //   context: context,
                //   builder: (_) => SubjectHistoryView(id: subject.id!),
                // );
              },
              icon: Text('${subject.version}'),
            ),
          ),
        );
      },
    );
  }

  void _addEditSubjectDialog(BuildContext context, {Subject? subject}) {
    showDialog(
      context: context,
      builder: (_) {
        return CustomDialog(child: SubjectForm(subject: subject));
      },
    );
  }

// void _subjectViewDialog(BuildContext context, Subject subject) {
//   showDialog(
//     context: context,
//     builder: (_) {
//       return CustomDialog(child: SubjectView(subject));
//     },
//   );
// }
}
