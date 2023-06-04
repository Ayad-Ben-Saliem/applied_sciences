import 'package:applied_sciences/ui/actions/actions_page.dart';
import 'package:applied_sciences/ui/app.dart';
import 'package:applied_sciences/ui/reports/reports_page.dart';
import 'package:applied_sciences/ui/semesters/semesters_page.dart';
import 'package:applied_sciences/ui/settings/settings_page.dart';
import 'package:applied_sciences/ui/subjects/subjects_page.dart';
import 'package:applied_sciences/ui/users/users_page.dart';
import 'package:flutter/material.dart';
import 'package:applied_sciences/ui/students/students_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      drawer: _drawer(),
      body: Container(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      leading: Builder(builder: (context) {
        return IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: const Icon(Icons.menu),
        );
      }),
      title: const Text('Home Page'),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: Builder(builder: (context) {
        return Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      return ListTile(
                        title: Text(ref.watch(authenticatedUser)!.name),
                        // onTap: () {},
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Users'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UsersPage()),
                      );
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    title: const Text('Students'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const StudentsPage()),
                      );
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    title: const Text('Semesters'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SemestersPage(),
                        ),
                      );
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    title: const Text('Subjects'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SubjectsPage(),
                        ),
                      );
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    title: const Text('Actions'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ActionsPage(),
                        ),
                      );
                      Scaffold.of(context).closeDrawer();
                    },
                  ),

                  ListTile(
                    title: const Text('Reports'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ReportsPage(),
                        ),
                      );
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsPage(),
                        ),
                      );
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
