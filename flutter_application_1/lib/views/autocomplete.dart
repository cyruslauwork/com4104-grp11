import 'package:flutter/material.dart';

void main() => runApp(const AutocompleteExampleApp());

class AutocompleteExampleApp extends StatelessWidget {
  const AutocompleteExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Autocomplete Basic User'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  'Type below to autocomplete the following possible results: ${AutocompleteBasicUserExample._userOptions}.'),
              const AutocompleteBasicUserExample(),
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class User {
  const User({
    required this.email,
    required this.name,
  });

  final String email;
  final String name;

  @override
  String toString() {
    return '$name, $email';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is User && other.name == name && other.email == email;
  }

  @override
  int get hashCode => Object.hash(email, name);
}

class AutocompleteBasicUserExample extends StatefulWidget {
  const AutocompleteBasicUserExample({Key? key}) : super(key: key);

  static const List<User> _userOptions = <User>[
    User(name: 'Alice', email: 'alice@example.com'),
    User(name: 'Bob', email: 'bob@example.com'),
    User(name: 'Charlie', email: 'charlie123@gmail.com'),
  ];

  static String _displayStringForOption(User option) => option.name;

  @override
  _AutocompleteBasicUserExampleState createState() =>
      _AutocompleteBasicUserExampleState();
}

class _AutocompleteBasicUserExampleState
    extends State<AutocompleteBasicUserExample> {
  late TextEditingController _textEditingController;
  User? _selectedUser;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<User>(
      displayStringForOption:
          AutocompleteBasicUserExample._displayStringForOption,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<User>.empty();
        }
        return AutocompleteBasicUserExample._userOptions.where((User option) {
          return option
              .toString()
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (User selection) {
        setState(() {
          _selectedUser = selection;
        });
        _textEditingController.clear();
        debugPrint(
            'You just selected ${AutocompleteBasicUserExample._displayStringForOption(selection)}');
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        _textEditingController = textEditingController;
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: 'Type a name',
            suffixIcon: _selectedUser != null
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedUser = null;
                      });
                      textEditingController.clear();
                    },
                    icon: Icon(Icons.clear),
                  )
                : null,
          ),
        );
      },
    );
  }
}
