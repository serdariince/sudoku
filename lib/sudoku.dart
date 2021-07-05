import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BoardScreen extends StatefulWidget {
  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  String selectedNum = "1";

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SizedBox(
      height: 100,
      child: Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65),
          child: NeumorphicAppBar(
            leading: NeumorphicButton(
              child: Icon(
                Icons.arrow_back,
                color: _iconColor(context),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              "Merdoku",
              style: TextStyle(
                color: _textColor(context),
              ),
            ),
            actions: [
              NeumorphicButton(
                child: Icon(
                  Icons.refresh,
                  color: _iconColor(context),
                ),
                onPressed: () {
                  setState(() {});
                },
              ),
              NeumorphicButton(
                child: Icon(
                  Icons.wb_sunny,
                  color: _iconColor(context),
                ),
                onPressed: () {
                  NeumorphicTheme.of(context)!.themeMode =
                      NeumorphicTheme.isUsingDark(context)
                          ? ThemeMode.light
                          : ThemeMode.dark;
                },
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Neumorphic(
                  child: SizedBox(
                    height: screenSize.width * 0.9,
                    width: screenSize.width * 0.9,
                    child: merdokuBoard(),
                  ),
                  style: NeumorphicStyle(
                    border: NeumorphicBorder(
                      width: 4,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.18,
                  width: screenSize.width * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          numberTab(context, "1"),
                          numberTab(context, "2"),
                          numberTab(context, "3"),
                          numberTab(context, "4"),
                          numberTab(context, "5"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          numberTab(context, "6"),
                          numberTab(context, "7"),
                          numberTab(context, "8"),
                          numberTab(context, "9"),
                          numberTab(context, "X"),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget numberTab(BuildContext context, String dNum) {
    return NeumorphicButton(
      style: NeumorphicStyle(
        color: selectedNum == dNum ? Colors.white70 : null,
      ),
      onPressed: () {
        setState(() {
          selectedNum = dNum;
        });
      },
      child: SizedBox(
        child: Center(
          child: Text(
            dNum,
            style: TextStyle(
              color: _textColor(context),
              fontSize: 23,
            ),
          ),
        ),
      ),
    );
  }

  Widget merdokuBoard() {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9),
              itemBuilder: _numTiles,
              itemCount: 27,
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
          Expanded(
            flex: 1,
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9),
              itemBuilder: _numTiles,
              itemCount: 27,
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
          Expanded(
            flex: 1,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9,
              ),
              itemBuilder: _numTiles,
              itemCount: 27,
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _numTiles(BuildContext context, int index) {
    Random rng = Random();
    String rngNum =
        rng.nextInt(2) == 0 ? "".toString() : rng.nextInt(9).toString();

    return GestureDetector(
      onTap: () {},
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 8,
          color: selectedNum == rngNum ? Colors.white70 : null,
        ),
        margin: EdgeInsets.all(5),
        child: Center(
          child: Text(
            rngNum,
            style: TextStyle(
              color: _textColor(context),
            ),
          ),
        ),
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'Merdoku',
      themeMode: ThemeMode.light,
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
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedDiff = "Easy";

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
              "Merdoku",
              style: TextStyle(
                color: _textColor(context),
              ),
            ),
            actions: [
              NeumorphicButton(
                child: Icon(
                  Icons.info_outline,
                  color: _iconColor(context),
                ),
                onPressed: () {},
              ),
              NeumorphicButton(
                child: Icon(
                  Icons.wb_sunny,
                  color: _iconColor(context),
                ),
                onPressed: () {
                  NeumorphicTheme.of(context)!.themeMode =
                      NeumorphicTheme.isUsingDark(context)
                          ? ThemeMode.light
                          : ThemeMode.dark;
                },
              )
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              difficultyBtn(context, "Easy"),
              SizedBox(
                height: 23,
              ),
              difficultyBtn(context, "Medium"),
              SizedBox(
                height: 23,
              ),
              difficultyBtn(context, "Hard"),
              SizedBox(
                height: 35,
              ),
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