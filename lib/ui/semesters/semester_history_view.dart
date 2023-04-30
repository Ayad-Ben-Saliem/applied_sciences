import 'package:intl/intl.dart';
import 'package:applied_sciences/models/semester.dart';
import 'package:applied_sciences/services/semesters_service.dart';
import 'package:applied_sciences/ui/custom_dialog.dart';
import 'package:flutter/material.dart';

class SemesterHistoryView extends StatelessWidget {
  final int id;

  const SemesterHistoryView({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SemestersService.getAllSemesters(id),
      initialData: null,
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('${snapshot.error}');
        if (snapshot.hasData) {
          if (snapshot.data == null) {
            return const Text('No Semesters!!!');
          } else {
            return CustomDialog(
              child: _semestersList(snapshot.data!),
            );
          }
        } else {
          return const CircularProgressIndicator();
        }
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
    final format = DateFormat.yMd().format;
    return Builder(
      builder: (context) {
        return ListTile(
          // onTap: () {
          //   showDialog(
          //     context: context,
          //     builder: (_) => CustomDialog(child: SemesterView(semester)),
          //   );
          // },
          title: Text(semester.name),
          subtitle: Text('${format(semester.start)} - ${format(semester.end)}'),
          trailing: Chip(label: Text('${semester.version}')),
        );
      },
    );
  }
}
