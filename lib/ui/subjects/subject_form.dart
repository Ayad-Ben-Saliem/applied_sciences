import 'package:applied_sciences/models/subject.dart';
import 'package:applied_sciences/services/subjects_service.dart';
import 'package:applied_sciences/static.dart';
import 'package:applied_sciences/ui/custom-text-field.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final name = StateProvider<String?>((ref) => null);
final units = StateProvider<int?>((ref) => null);

final nameMessage = StateProvider<String?>((ref) {
  return ref.watch(name)?.isNotEmpty == true ? null : 'Name Required!!!';
});

final unitsMessage = StateProvider<String?>((ref) {
  return ref.watch(units) == null ? 'Units Required!!!' : null;
});

class SubjectForm extends ConsumerWidget {
  final Subject? subject;

  const SubjectForm({Key? key, this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(name.notifier).state = subject?.name;
      ref.read(units.notifier).state = subject?.units;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(subject == null ? 'Add Subject' : 'Edit Subject'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 512),
                    child: Column(
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            return CustomTextField(
                              text: subject?.name ?? '',
                              decoration:
                                  const InputDecoration(labelText: 'Name'),
                              onChanged: (txt) =>
                                  ref.read(name.notifier).state = txt,
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        Consumer(
                          builder: (context, ref, child) {
                            return Text(
                              ref.watch(nameMessage) ?? '',
                              style: errorTextStyle(context),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Consumer(
                          builder: (context, ref, child) {
                            return CustomTextField(
                              text: '${subject?.units ?? ''}',
                              // TODO: make field numeric
                              decoration:
                                  const InputDecoration(labelText: 'Units'),
                              onChanged: (txt) => ref
                                  .read(units.notifier)
                                  .state = int.tryParse(txt),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r"^\d*"),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        Consumer(
                          builder: (context, ref, child) {
                            return Text(
                              ref.watch(unitsMessage) ?? '',
                              style: errorTextStyle(context),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                child: Consumer(
                  builder: (context, ref, child) {
                    return ElevatedButton(
                      onPressed: _isValid(ref)
                          ? () async {
                              try {
                                Navigator.pop(context, await save(ref));
                              } catch (error, stackTrace) {
                                print(error);
                                print(stackTrace);
                                _errorSnackBar(context, error, stackTrace);
                              }
                            }
                          : null,
                      child: const Text('Save'),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isValid(WidgetRef ref) {
    return ref.watch(nameMessage) == null && ref.watch(unitsMessage) == null;
  }

  Future<Subject?> save(WidgetRef ref) async {
    if (_isValid(ref)) {
      final subject = Subject(
        id: this.subject?.id,
        name: ref.read(name)!,
        units: ref.read(units)!,
      );
      return SubjectsService.upsertSubject(subject);
    }
    return null;
  }

  void _errorSnackBar(
      BuildContext context, Object error, StackTrace stackTrace) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 100),
            child: Column(
              children: [
                Text('$error'),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [Text('$stackTrace')],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
