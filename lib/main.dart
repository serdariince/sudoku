import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sudoku/giris_sayfasi.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter('sudoku');
  await Hive.openBox('ayarlar');
  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable:
            Hive.box('ayarlar').listenable(keys: ['karanlik_tema', 'dil']),
        builder: (context, kutu, widget) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: kutu.get('karanlik_tema', defaultValue: false)
                ? ThemeData.dark()
                : ThemeData.light(),
            home: GirisSayfasi(),
          );
        },
        );
  }
}
