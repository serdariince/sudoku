import 'package:flutter/material.dart';
import 'package:sudoku/dil.dart';

class SudokuSayfasi extends StatefulWidget {
  const SudokuSayfasi({ Key? key }) : super(key: key);

  @override
  _SudokuSayfasiState createState() => _SudokuSayfasiState();
}

class _SudokuSayfasiState extends State<SudokuSayfasi> {
  @override
  Widget build(BuildContext context) {
       return Scaffold(
      appBar: AppBar(
        title:Text(dil['sudoku_title']),
      ),
    );
  }
}