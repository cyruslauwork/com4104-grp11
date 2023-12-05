import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  const NewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text('Search'),
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search here...',
          ),
        ),
      ),
      body: Center(
        child: Text(
          'This is a search page!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}