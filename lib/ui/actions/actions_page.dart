import 'package:applied_sciences/models/subject.dart';
import 'package:applied_sciences/services/subjects_service.dart';
import 'package:applied_sciences/ui/custom_dialog.dart';
import 'package:applied_sciences/ui/subjects/subject_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subjects = StreamProvider((ref) => SubjectsService.subjects());

class ActionsPage extends StatelessWidget {
  const ActionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actions')),
      body: _actionsView(context),
    );
  }

  Widget _actionsView(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: InkWell(
              child: const Center(child: Text('Registration Renewal')),
              onTap: () {
                showDialog(
                  context: context,
                  builder: registrationRenewal,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget registrationRenewal(BuildContext context) {
    return const Dialog(child: Placeholder());
  }
}
