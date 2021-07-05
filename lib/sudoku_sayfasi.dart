import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sudoku/dil.dart';
import 'package:sudoku/sudokuskor.dart';
import 'package:hive_flutter/hive_flutter.dart';
final Map sudokuSeviyeleri = {
  dil["seviye1"]: 62,
  dil["seviye2"]: 53,
  dil["seviye3"]: 44,
  dil["seviye4"]: 35,
  dil["seviye5"]: 26,
  dil["seviye6"]: 17
};
class SudokuSayfasi extends StatefulWidget {
  const SudokuSayfasi({Key? key}) : super(key: key);

  @override
  _SudokuSayfasiState createState() => _SudokuSayfasiState();
}



class _SudokuSayfasiState extends State<SudokuSayfasi> {
  final List ornekSudoku =
      List.generate(9, (i) => List.generate(9, (j) => j + 1));
  final Box _sudokuKutu = Hive.box('sudoku');
  List _sudoku = [];

bool _note=false;

  late String _sudokuString;
  void _sudokuOlustur() {
    int gizlenecekSayisi = sudokuSeviyeleri[
        _sudokuKutu.get('seviye', defaultValue: dil["seviye2"])];
    _sudokuString = sudokuSukor[Random().nextInt(sudokuSukor.length)];
    _sudokuKutu.put('sudokuString', _sudokuString);
    _sudoku = List.generate(
        9,
        (index) => List.generate(
            9,
            (j) => ("e" +
                _sudokuString
                    .substring(index * 9, (index + 1) * 9)
                    .split('')[j])));
    int i = 0;
    while (i < 81 - gizlenecekSayisi) {
      int x = Random().nextInt(9);
      int y = Random().nextInt(9);
      if (_sudoku[x][y] != "0") {
        _sudoku[x][y] = "0";
        i++;
      }
    }
    _sudokuKutu.put('sudokuRows', _sudoku);
    _sudokuKutu.put('xy', "99");
    _sudokuKutu.put('ipucu', 3);

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
        centerTitle: true,
      ),
      body: Column(
        children: [
          AspectRatio(
              aspectRatio: 1,
              child: ValueListenableBuilder<Box>(
                  valueListenable:
                      Hive.box("sudoku").listenable(keys: ['xy', 'sudokuRows']),
                  builder: (context, box, widget) {
                    String xy = box.get('xy');

                    int xC = int.parse(xy.substring(0, 1)),
                        yC = int.parse(xy.substring(1));
                    List sudokuRows = box.get('sudokuRows');
                    return Container(
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
                                                    color: xC == x && yC == y
                                                        ? Colors.blue
                                                        : xC == x || yC == y
                                                            ? Colors.blueGrey
                                                                .withOpacity(
                                                                    0.4)
                                                            : Colors.amber,
                                                    alignment: Alignment.center,
                                                    child: "${sudokuRows[x][y]}"
                                                            .startsWith('e')
                                                        ? Text(
                                                            "${sudokuRows[x][y]}"
                                                                .substring(1),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20),
                                                          )
                                                        : InkWell(
                                                            onTap: () {
                                                              _sudokuKutu.put(
                                                                  'xy', "$x$y");
                                                            },
                                                            child: Center(
                                                              child: Text(
                                                                sudokuRows[x][
                                                                            y] !=
                                                                        "0"
                                                                    ? sudokuRows[
                                                                        x][y]
                                                                    : "",
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                                if (y == 2 || y == 5)
                                                  SizedBox(width: 2)
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (x == 2 || x == 5) SizedBox(height: 2)
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  })),
          SizedBox(
            height: 2.0,
          ),
          Expanded(
            child: Container(
              color: Colors.black,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    String xy = _sudokuKutu.get('xy');
                                    if (xy != "99") {
                                      int xC = int.parse(xy.substring(0, 1)),
                                          yC = int.parse(xy.substring(1));
                                      _sudoku[xC][yC] = "0";
                                      _sudokuKutu.put('sudokuRows', _sudoku);
                                    }
                                  },
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.amber,
                                        ),
                                        Text(
                                          "Sil",
                                          style: TextStyle(color: Colors.amber),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    String xy = _sudokuKutu.get('xy');
                                    if (xy != "99" &&
                                        _sudokuKutu.get('ipucu') > 0) {
                                      int xC = int.parse(xy.substring(0, 1)),
                                          yC = int.parse(xy.substring(1));

                                      String cozumString =
                                          _sudokuKutu.get('sudokuString');

                                      List cozumSudoku = List.generate(
                                          9,
                                          (index) => List.generate(
                                              9,
                                              (j) => (cozumString
                                                  .substring(index * 9,
                                                      (index + 1) * 9)
                                                  .split('')[j])));
                                      if (_sudoku[xC][yC] !=
                                          cozumSudoku[xC][yC]) {
                                        _sudoku[xC][yC] = cozumSudoku[xC][yC];
                                        _sudokuKutu.put('sudokuRows', _sudoku);
                                        _sudokuKutu.put('ipucu',
                                            _sudokuKutu.get('ipucu') - 1);
                                      }
                                    }
                                  },
                                  child: ValueListenableBuilder<Box>(
                                      valueListenable: _sudokuKutu
                                          .listenable(keys: ['ipucu']),
                                      builder: (context, box, widget) {
                                        return Card(
                                          color: Colors.blue,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.lightbulb_outline),
                                                  Text(": ${box.get('ipucu')}")
                                                ],
                                              ),
                                              Text("İpucu")
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () =>setState(()=>_note=!_note),
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.note_add_outlined,
                                          color:_note? Colors.amber.withOpacity(0.6): Colors.amber,
                                        ),
                                        Text(
                                          "Not",
                                          style: TextStyle(color: Colors.amber),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    String xy = _sudokuKutu.get('xy'); 
                                    int xC = int.parse(xy.substring(0, 1)),
                                          yC = int.parse(xy.substring(1));
                                    if (xy != "99"&&!_note) {
                                     
                                      _sudoku[xC][yC] = "0";
                                      _sudokuKutu.put('sudokuRows', _sudoku);
                                    }else if (_note) {
                                      
                                    }
                                  },
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.amber,
                                        ),
                                        Text(
                                          "Sil",
                                          style: TextStyle(color: Colors.amber),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
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
                                      color: Colors.deepOrange.shade700,
                                      child: InkWell(
                                        onTap: () {
                                          String xy = _sudokuKutu.get('xy');
                                          if (xy != "99") {
                                            int xC = int.parse(
                                                    xy.substring(0, 1)),
                                                yC = int.parse(xy.substring(1));
                                            _sudoku[xC][yC] = "${i + j}";
                                            _sudokuKutu.put(
                                                'sudokuRows', _sudoku);
                                          }
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
            ),
          )
        ],
      ),
    );
  }
}
