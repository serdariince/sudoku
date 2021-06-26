import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:sudoku/dil.dart';

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({Key? key}) : super(key: key);

  @override
  _GirisSayfasiState createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  Future<Box> _kutuAc() async {
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
            icon: Icon(Icons.history_edu),
            onPressed: () {
              Box kutu = Hive.box('ayarlar');
              kutu.put(
                'karanlik_tema',
                !kutu.get('karanlik_tema', defaultValue: false),
              );
            },
          ),
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
