import 'package:flutter/material.dart';

import 'package:flutter_application_1/presenters/presenters.dart';

class SubsequentAnalysisView extends StatelessWidget {
  final BuildContext c;

  const SubsequentAnalysisView({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return MainPresenter.to.showSa(c);
  }
}
