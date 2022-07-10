import 'package:flutter/material.dart';
import 'package:gomez_http_demonstration/src/menu.dart';


class AppInit extends StatelessWidget{
  const AppInit({
    Key? key,
}): super(key:key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainMenu(),
    );
  }
}