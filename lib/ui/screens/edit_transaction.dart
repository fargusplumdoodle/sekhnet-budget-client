import 'package:budget/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EditTransaction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Base.appBar(),
      drawer: Base.drawer(context),
    );
  }
}
