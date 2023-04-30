import 'dart:io';

import 'package:applied_sciences/models/student.dart';
import 'package:applied_sciences/services/students_service.dart';
import 'package:applied_sciences/static.dart';
import 'package:applied_sciences/ui/custom-text-field.dart';
import 'package:date_field/date_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final name = StateProvider<String?>((ref) => null);
final studentId = StateProvider<String?>((ref) => null);

final photo = StateProvider<String?>((ref) => null);
final birthdate = StateProvider<DateTime?>((ref) => null);
final personalId = StateProvider<String?>((ref) => null);
final passportNo = StateProvider<String?>((ref) => null);
final nationalId = StateProvider<String?>((ref) => null);

final graduateDate = StateProvider<DateTime?>((ref) => null);
final grade = StateProvider<double?>((ref) => null);
final percentage = StateProvider<double?>((ref) => null);

final media = StateProvider((ref) => <String>[]);

final nameMessage = StateProvider<String?>((ref) {
  return ref.watch(name)?.isNotEmpty == true ? null : 'Name Required!!!';
});

final studentIdMessage = StateProvider<String?>((ref) {
  return ref.watch(studentId)?.isNotEmpty == true ? null : 'Name Required!!!';
});

class StudentForm extends ConsumerWidget {
  final Student? student;

  const StudentForm({Key? key, this.student}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(name.notifier).state = student?.name;
      ref.read(studentId.notifier).state = student?.studentId;
      ref.read(photo.notifier).state = student?.photo;
      ref.read(birthdate.notifier).state = student?.birthdate;
      ref.read(personalId.notifier).state = student?.personalId;
      ref.read(passportNo.notifier).state = student?.passportNo;
      ref.read(nationalId.notifier).state = student?.nationalId;
      ref.read(graduateDate.notifier).state = student?.graduateDate;
      ref.read(grade.notifier).state = student?.grade;
      ref.read(percentage.notifier).state = student?.percentage;
      ref.read(media.notifier).state = student?.media ?? [];
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(student == null ? 'Add Student' : 'Edit Student'),
      ),
      body: Column(
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
                            Widget getPhoto(String? uri) {
                              if (uri == null) {
                                return const Icon(Icons.person_outline);
                              }
                              return Image.file(File(uri));
                            }

                            return IconButton(
                              onPressed: () {
                                FilePicker.platform
                                    .pickFiles(type: FileType.image)
                                    .then((result) {
                                  if (result != null) {
                                    ref.read(photo.notifier).state =
                                        result.files.first.path;
                                  }
                                });
                              },
                              iconSize: 100,
                              color: Colors.grey,
                              icon: getPhoto(ref.watch(photo)),
                            );
                          },
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            return CustomTextField(
                              text: student?.name,
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
                              text: student?.studentId,
                              decoration:
                                  const InputDecoration(labelText: 'Id'),
                              onChanged: (txt) =>
                                  ref.read(studentId.notifier).state = txt,
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        Consumer(
                          builder: (context, ref, child) {
                            return Text(
                              ref.watch(studentIdMessage) ?? '',
                              style: errorTextStyle(context),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Consumer(
                          builder: (context, ref, child) {
                            return DateTimeField(
                              selectedDate: ref.watch(birthdate),
                              mode: DateTimeFieldPickerMode.date,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Birthdate',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () =>
                                      ref.read(birthdate.notifier).state = null,
                                ),
                              ),
                              onDateSelected: (datetime) =>
                                  ref.read(birthdate.notifier).state = datetime,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Consumer(
                          builder: (context, ref, child) {
                            return CustomTextField(
                              text: student?.personalId,
                              decoration: const InputDecoration(
                                labelText: 'Personal Id',
                              ),
                              onChanged: (txt) =>
                                  ref.read(personalId.notifier).state = txt,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Consumer(
                          builder: (context, ref, child) {
                            return CustomTextField(
                              text: student?.passportNo,
                              decoration: const InputDecoration(
                                labelText: 'Passport No.',
                              ),
                              onChanged: (txt) =>
                                  ref.read(passportNo.notifier).state = txt,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Consumer(
                          builder: (context, ref, child) {
                            return CustomTextField(
                              text: student?.nationalId,
                              decoration: const InputDecoration(
                                labelText: 'National Id',
                              ),
                              onChanged: (txt) =>
                                  ref.read(nationalId.notifier).state = txt,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Consumer(
                          builder: (context, ref, child) {
                            return DateTimeField(
                              selectedDate: ref.watch(graduateDate),
                              mode: DateTimeFieldPickerMode.date,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Graduate Date',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () => ref
                                      .read(graduateDate.notifier)
                                      .state = null,
                                ),
                              ),
                              onDateSelected: (datetime) => ref
                                  .read(graduateDate.notifier)
                                  .state = datetime,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Consumer(
                          builder: (context, ref, child) {
                            return CustomTextField(
                              text: student?.grade == null
                                  ? null
                                  : '${student?.grade}',
                              decoration: const InputDecoration(
                                labelText: 'Grade',
                              ),
                              onChanged: (txt) => ref
                                  .read(grade.notifier)
                                  .state = double.parse(txt),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Consumer(
                          builder: (context, ref, child) {
                            return CustomTextField(
                              text: student?.percentage == null
                                  ? null
                                  : '${student?.percentage}',
                              decoration: const InputDecoration(
                                labelText: 'Percentage',
                              ),
                              onChanged: (txt) => ref
                                  .read(percentage.notifier)
                                  .state = double.parse(txt),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Consumer(
                          builder: (context, ref, child) {
                            return Wrap(
                              children: [
                                for (final m in ref.watch(media))
                                  _mediaCard(_mediaWidget(m)),
                                // _mediaCard(Image.file(File(m))),
                                _mediaCard(
                                  InkWell(
                                    child: const Icon(Icons.add, size: 64),
                                    onTap: () async {
                                      final result = await FilePicker.platform
                                          .pickFiles(type: FileType.media);
                                      if (result != null) {
                                        ref.read(media.notifier).state = [
                                          ...ref.read(media),
                                          result.files.first.path!
                                        ];
                                      }
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(maxHeight: 100),
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
        ref.watch(studentIdMessage) == null;
  }

  Future<Student?> save(WidgetRef ref) async {
    if (_isValid(ref)) {
      final student = Student(
        id: this.student?.id,
        name: ref.read(name)!,
        studentId: ref.read(studentId)!,
        photo: ref.read(photo),
        birthdate: ref.read(birthdate),
        personalId: ref.read(personalId),
        passportNo: ref.read(passportNo),
        nationalId: ref.read(nationalId),
        graduateDate: ref.read(graduateDate),
        grade: ref.read(grade),
        percentage: ref.read(percentage),
        media: ref.read(media),
      );
      return StudentsService.upsertStudent(student);
    }
    return null;
  }

  Widget _mediaWidget(String uri) {
    final imageExtensions = [
      'jpg',
      'jpeg',
      'png',
      'webp',
      'gif',
      'tif',
    ];
    final videoExtensions = [
      'avi',
      'wmv',
      'mp4',
      'webm',
      'flv',
      'mov',
      'mkv',
      'mpeg4',
      'mts',
    ];
    final x = uri.toLowerCase();
    for (var extension in imageExtensions) {
      if (x.endsWith(extension)) return Image.file(File(uri));
    }
    for (var extension in videoExtensions) {
      if (x.endsWith(extension)) return Image.file(File(uri));
    }
    return Container();
  }

  Widget _mediaCard(Widget content) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: SizedBox.square(dimension: 100, child: Center(child: content)),
    );
  }
}
