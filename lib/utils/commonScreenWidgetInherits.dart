import 'package:flutter/material.dart';

class CommonScreenProvider extends InheritedWidget {
  num counter = 0;
  Widget child;
  CommonScreenProvider({@required this.child});

  @override
  bool updateShouldNotify(covariant CommonScreenProvider oldWidget) {
    return oldWidget.counter != counter;
  }

  static CommonScreenProvider of(BuildContext ctx) =>
      ctx.dependOnInheritedWidgetOfExactType();
}
