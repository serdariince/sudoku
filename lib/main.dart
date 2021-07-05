import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:sudoku/giris_sayfasi.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sudoku/sudoku.dart';

import 'dil.dart';

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box('ayarlar').listenable(keys: ['tema', 'renk']),
      builder: (context, box, widget) {
        return NeumorphicApp(
          debugShowCheckedModeBanner: false,
          title: 'Sudoku Bulmaca',
          themeMode: box.get('tema', defaultValue: false)
              ? ThemeMode.light
              : ThemeMode.dark,
          theme: NeumorphicThemeData(
            baseColor: Color(0xffd8d6d8),
            lightSource: LightSource.topLeft,
            depth: 10,
            appBarTheme: NeumorphicAppBarThemeData(
              buttonStyle: NeumorphicStyle(
                color: Colors.black54,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(12),
                ),
              ),
              textStyle: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          darkTheme: NeumorphicThemeData(
            baseColor: Color(0xFF3E3E3E),
            lightSource: LightSource.topLeft,
            depth: 6,
          ),
          home: HomePage(),
        );
      },
    );
  }
}
final Map sudokuSeviyeleri = {
  dil["seviye1"]: 62,
  dil["seviye2"]: 53,
  dil["seviye3"]: 44,
  dil["seviye4"]: 35,
  dil["seviye5"]: 26,
  dil["seviye6"]: 17
};
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedDiff = "Çaylak";
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65),
          child: NeumorphicAppBar(
            title: Text(
              "Sudoku",
              style: TextStyle(
                color: _textColor(context),
              ),
            ),
            actions: [
              NeumorphicButton(
                child: Icon(
                  Icons.wb_sunny,
                  color: _iconColor(context),
                ),
                onPressed: () {
                  Box kutu = Hive.box('ayarlar');
              kutu.put(
                'tema',
                !kutu.get('tema', defaultValue: false),
              );
                  // NeumorphicTheme.of(context)!.themeMode =
                  //     NeumorphicTheme.isUsingDark(context)
                  //         ? ThemeMode.light
                  //         : ThemeMode.dark;
                },
              )
            ],
          ),
        ),
        body: Center(
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

              for(String key in sudokuSeviyeleri.keys)
              Column(children: [
              difficultyBtn(context, key),
                SizedBox(
                  height: 23,
                ),
              ],),


                NeumorphicButton(
                  style: NeumorphicStyle(
                    boxShape: NeumorphicBoxShape.circle(),
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    size: 60,
                    color: _textColor(context),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BoardScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget difficultyBtn(BuildContext context, String btnTitle) {
    return NeumorphicButton(
      style: NeumorphicStyle(
        color: selectedDiff == btnTitle ? Colors.grey : null,
      ),
      onPressed: () {
        setState(() {
          selectedDiff = btnTitle;
        });
      },
      child: SizedBox(
        child: Center(
          child: Text(
            btnTitle,
            style: TextStyle(
              color: _textColor(context),
              fontSize: 23,
            ),
          ),
        ),
        width: 100,
      ),
    );
  }

  Color _textColor(BuildContext context) {
    if (NeumorphicTheme.isUsingDark(context)) {
      return Colors.white;
    } else {
      return Colors.black54;
    }
  }

  Color _iconColor(BuildContext context) {
    if (NeumorphicTheme.isUsingDark(context)) {
      return Colors.white;
    } else {
      return Colors.white70;
    }
  }
}
