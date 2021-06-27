import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sudoku/dil.dart';
import 'package:sudoku/sudokuskor.dart';

class SudokuSayfasi extends StatefulWidget {
  const SudokuSayfasi({Key? key}) : super(key: key);

  @override
  _SudokuSayfasiState createState() => _SudokuSayfasiState();
}

final Map sudokuSeviyeleri = {
  dil["seviye1"]: 62,
  dil["seviye2"]: 53,
  dil["seviye3"]: 44,
  dil["seviye4"]: 35,
  dil["seviye5"]: 26,
  dil["seviye6"]: 17
};

class _SudokuSayfasiState extends State<SudokuSayfasi> {
  final List ornekSudoku =
      List.generate(9, (i) => List.generate(9, (j) => j + 1));
  final Box _sudokuKutu = Hive.box('sudoku');
  List _sudoku = [];
  late String _sudokuString;
  void _sudokuOlustur() {
    int gizlenecekSayisi = sudokuSeviyeleri[
        _sudokuKutu.get('seviye', defaultValue: dil["seviye2"])];
    _sudokuString = sudokuSukor[Random().nextInt(sudokuSukor.length)];
    _sudoku = List.generate(
        9,
        (index) => List.generate(
            9,
            (j) => int.tryParse(_sudokuString
                .substring(index * 9, (index + 1) * 9)
                .split('')[j])));
    int i = 0;
    while (i < 81 - gizlenecekSayisi) {
      int x=Random().nextInt(9);
      int y=Random().nextInt(9);
     if( _sudoku[x][y] != 0){
       _sudoku[x][y] = 0;
      i++;
      }
    }
    

    print(_sudokuString);
    print(gizlenecekSayisi);
  }

  @override
  void initState() {
    _sudokuOlustur();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dil['sudoku_title']),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              _sudokuKutu.get('seviye', defaultValue: dil["seviye2"]),
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: EdgeInsets.all(2.0),
              margin: EdgeInsets.all(2.0),
              color: Colors.blueGrey.shade400,
              child: Column(
                children: [
                  for (int x = 0; x < 9; x++)
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                for (int y = 0; y < 9; y++)
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.all(1.0),
                                            color: Colors.amber,
                                            alignment: Alignment.center,
                                            child: Text(
                                              _sudoku[x][y] > 0
                                                  ? _sudoku[x][y].toString()
                                                  : "",
                                            ),
                                          ),
                                        ),
                                        if (y == 2 || y == 5) SizedBox(width: 5)
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (x == 2 || x == 5) SizedBox(height: 5)
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Container(
                                  margin: EdgeInsets.all(3),
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Container(
                                  margin: EdgeInsets.all(3),
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      for (int i = 1; i < 10; i += 3)
                        Expanded(
                          child: Row(
                            children: [
                              for (int j = 0; j < 3; j++)
                                Expanded(
                                  child: Card(
                                    shape: CircleBorder(),
                                    color: Colors.red,
                                    child: InkWell(
                                      onTap: () {
                                        print("${i + j}");
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(3),
                                        alignment: Alignment.center,
                                        child: Text("${i + j}"),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
