import 'package:applied_sciences/models/semester.dart';
import 'package:applied_sciences/services/semesters_service.dart';
import 'package:applied_sciences/ui/custom_dialog.dart';
import 'package:applied_sciences/ui/semesters/semester_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final semesters = StreamProvider((ref) => SemestersService.semesters());

class SemestersPage extends StatelessWidget {
  const SemestersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Semesters')),
      body: Column(
        children: [
          _buttons(),
          const Divider(height: 0),
          Expanded(child: _semestersView()),
        ],
      ),
    );
  }

  Widget _buttons() {
    return Builder(builder: (context) {
      return Row(
        children: [
          _button(
            onPressed: () => _addEditSemesterDialog(context),
            child: Column(
              children: const [
                Icon(Icons.add),
                Text('Add Semester'),
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

  Widget _semestersView() {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(semesters).when(
              loading: () => const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(),
              ),
              data: (semesters) {
                return _semestersList(semesters);
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

  Widget _semestersList(List<Semester?> semesters) {
    return ListView.separated(
      itemCount: semesters.length,
      itemBuilder: (_, index) {
        if (semesters[index] == null) {
          return const Text('Semester is null');
        }
        return _semesterTile(semesters[index]!);
      },
      separatorBuilder: (_, index) => const Divider(
        height: 0,
        thickness: 0.5,
      ),
    );
  }

  Widget _semesterTile(Semester semester) {
    return Builder(
      builder: (context) {
        return InkWell(
          // onTap: () => _semesterViewDialog(context, semester),
          onDoubleTap: () =>
              _addEditSemesterDialog(context, semester: semester),
          child: ListTile(
            title: Text(semester.name),
            // subtitle: Text(semester.semesterId),
            trailing: IconButton(
              onPressed: () {
                // showDialog(
                //   context: context,
                //   builder: (_) => SemesterHistoryView(id: semester.id!),
                // );
              },
              icon: Text('${semester.version}'),
            ),
          ),
        );
      },
    );
  }

  void _addEditSemesterDialog(BuildContext context, {Semester? semester}) {
    showDialog(
      context: context,
      builder: (_) {
        return CustomDialog(child: SemesterForm(semester: semester));
      },
    );
  }

// void _semesterViewDialog(BuildContext context, Semester semester) {
//   showDialog(
//     context: context,
//     builder: (_) {
//       return CustomDialog(child: SemesterView(semester));
//     },
//   );
// }
}
