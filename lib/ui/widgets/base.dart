import 'package:flutter/material.dart';

class Base {
  static Widget appBar() => AppBar(
        title: Text('Sekhnet Budget'),
      );

  static Widget drawer() => Drawer(
        child: Center(child: Text('in da drawer')),
      );
}
