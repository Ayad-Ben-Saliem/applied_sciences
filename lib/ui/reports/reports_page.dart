import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: _reportsView(context),
    );
  }

  Widget _reportsView(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: InkWell(
              child: const Center(child: Text('Report 1')),
              onTap: () {
                // TODO: Not Implemented Yet!!!
                print('Not Implemented Yet!!!');
              },
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: InkWell(
              child: const Center(child: Text('Report 2')),
              onTap: () {
                // TODO: Not Implemented Yet!!!
                print('Not Implemented Yet!!!');
              },
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: InkWell(
              child: const Center(child: Text('Report 3')),
              onTap: () {
                // TODO: Not Implemented Yet!!!
                print('Not Implemented Yet!!!');
              },
            ),
          ),
        ),
      ],
    );
  }
}
