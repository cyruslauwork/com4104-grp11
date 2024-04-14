import 'package:flutter/material.dart';

import 'package:flutter_application_1/presenters/presenters.dart';

class TrendMatchView extends StatelessWidget {
  const TrendMatchView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainPresenter.to.showTm();
  }
}
