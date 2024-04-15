import 'package:flutter/material.dart';

import 'package:flutter_application_1/presenters/presenters.dart';

class TrendMatchView extends StatelessWidget {
  // const TrendMatchView({super.key});

  // Singleton implementation
  static TrendMatchView? _instance;
  factory TrendMatchView({Key? key}) {
    _instance ??= TrendMatchView._(key: key);
    return _instance!;
  }
  const TrendMatchView._({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainPresenter.to.showTm();
  }
}
