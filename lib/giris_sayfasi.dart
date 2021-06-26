import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:sudoku/dil.dart';
import 'package:sudoku/sudoku_sayfasi.dart';

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({Key? key}) : super(key: key);

  @override
  _GirisSayfasiState createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  late Box _sudokuKutu;
  Future<Box> _kutuAc() async {
   _sudokuKutu= await Hive.openBox('sudoku');
    return await Hive.openBox('tamamlanan_sudokular');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(dil['giris_title']),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.star_border_purple500_outlined),
            onPressed: () {
              Box kutu = Hive.box('ayarlar');
              kutu.put(
                'karanlik_tema',
                !kutu.get('karanlik_tema', defaultValue: false),
              );
            },
          ),
          PopupMenuButton(
            icon: Icon(Icons.add),
            onSelected: (deger){
              if (_sudokuKutu.isOpen) _sudokuKutu.put('seviye', deger);
              Navigator.push(context, MaterialPageRoute(builder: (_)=>SudokuSayfasi()));
            },
            itemBuilder: (context)=><PopupMenuEntry>[
              PopupMenuItem(
                  value: dil["seviye_sec"],
                  child: Text( dil["seviye_sec"]),
                  textStyle: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyText1!.color),
                  enabled: false,
                  ),
              for(String key in sudokuSeviyeleri.keys)
                PopupMenuItem(
                  value:key,
                  child: Text( key),
                  )
          ])
        ],
      ),
      body: FutureBuilder<Box>(
        future: _kutuAc(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (snapshot.data!.values.length ==0 ) Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(dil['tamamlananyok'],style: GoogleFonts.overpass(textStyle: TextStyle(fontSize: 25)),),
                  ),
                  
                  for (var eleman in snapshot.data
                  !.values)
                    Center(child: Text("$eleman"),)
                  
                ],
              ),
            );
          } else {
            return Center( child: Text(dil['tamamlananyok']),);
          }
        },
      ),
    );
  }
}
