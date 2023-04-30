import 'package:applied_sciences/models/semester.dart';
import 'package:applied_sciences/services/semesters_service.dart';
import 'package:applied_sciences/static.dart';
import 'package:applied_sciences/ui/custom-text-field.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final name = StateProvider<String?>((ref) => null);
final start = StateProvider<DateTime?>((ref) => null);
final end = StateProvider<DateTime?>((ref) => null);

final nameMessage = StateProvider<String?>((ref) {
  return ref.watch(name)?.isNotEmpty == true ? null : 'Name Required!!!';
});

final startMessage = StateProvider<String?>((ref) {
  return ref.watch(start) == null ? 'Start Date Required!!!' : null;
});

final endMessage = StateProvider<String?>((ref) {
  final endDate = ref.watch(end);
  if (endDate == null) return 'End Date Required!!!';
  if (ref.watch(start)?.isBefore(endDate) == true) return null;
  return 'End date must be after start date';
});

class SemesterForm extends ConsumerWidget {
  final Semester? semester;

  const SemesterForm({Key? key, this.semester}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(name.notifier).state = semester?.name;
      ref.read(start.notifier).state = semester?.start;
      ref.read(end.notifier).state = semester?.end;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(semester == null ? 'Add Semester' : 'Edit Semester'),
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
                              text: semester?.name,
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
                            return DateTimeField(
                              selectedDate: ref.watch(start),
                              mode: DateTimeFieldPickerMode.date,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Start Date',
                              ),
                              onDateSelected: (datetime) =>
                                  ref.read(start.notifier).state = datetime,
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        Consumer(
                          builder: (context, ref, child) {
                            return Text(
                              ref.watch(startMessage) ?? '',
                              style: errorTextStyle(context),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Consumer(
                          builder: (context, ref, child) {
                            return DateTimeField(
                              selectedDate: ref.watch(end),
                              mode: DateTimeFieldPickerMode.date,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'End Date',
                              ),
                              onDateSelected: (datetime) =>
                                  ref.read(end.notifier).state = datetime,
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        Consumer(
                          builder: (context, ref, child) {
                            return Text(
                              ref.watch(endMessage) ?? '',
                              style: errorTextStyle(context),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        // TODO: Students View
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
    return ref.watch(nameMessage) == null &&
        ref.watch(startMessage) == null &&
        ref.watch(endMessage) == null;
  }

  Future<Semester?> save(WidgetRef ref) async {
    if (_isValid(ref)) {
      final semester = Semester(
        id: this.semester?.id,
        name: ref.read(name)!,
        start: ref.read(start)!,
        end: ref.read(end)!,
      );
      return SemestersService.upsertSemester(semester);
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
