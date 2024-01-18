import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imglib;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';



class game extends StatefulWidget {
  @override
  State<game> createState() => _gameState();
}

class _gameState extends State<game> {
  List list1 = [];
  List list2 = [];
  List list3 = [];
  List temp = List.filled(9, true);
  List myList = [];

  @override
  void initState() {
    getImageFileFromAssets('img/one.jpg').then((value) {
      imglib.Image? image = imglib.decodeJpg(value.readAsBytesSync());
      myList = splitImage(image!, 3, 3);
      for (int i = 0; i < myList.length; i++) {
        list2.add((imglib.encodeJpg(myList[i])));
      }
      list3.addAll(list2);
      list2.shuffle();
      setState(() {});
    });
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('$path');

    var dir_path = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS) +
        "/pic";

    Directory dir = Directory(dir_path);

    if (!await dir.exists()) {
      dir.create();
    }

    final file = File('${(await getTemporaryDirectory()).path}/$path');

    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  List<imglib.Image> splitImage(imglib.Image inputImage,
      int horizontalPieceCount, int verticalPieceCount) {
    imglib.Image image = inputImage;

    final pieceWidth = (image.width / horizontalPieceCount).round();
    final pieceHeight = (image.height / verticalPieceCount).round();
    final pieceList = List<imglib.Image>.empty(growable: true);

    var x = 0, y = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        pieceList.add(imglib.copyCrop(image,
            x: x, y: y, width: pieceWidth, height: pieceHeight));
        x = x + pieceWidth;
      }
      x = 0;
      y = y + pieceHeight;
    }
    return pieceList;
  }

  @override
  Widget build(BuildContext context) {
    double total_hight = MediaQuery.of(context).size.width;
    double final_hight = (total_hight - 20) / 3;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Image"),
        ),
        body: GridView.builder(
          itemCount: myList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 3, crossAxisSpacing: 3),
          itemBuilder: (context, index) {
            return (temp[index])
                ? Draggable(
                    onDraggableCanceled: (velocity, offset) {
                      temp = List.filled(9, true);
                      setState(() {});
                    },
                    data: index,
                    onDragStarted: () {
                      temp = List.filled(9, false);
                      temp[index] = true;
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: final_hight,
                      width: final_hight,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: MemoryImage(list2[index]),
                        ),
                      ),
                    ),
                    feedback: Container(
                      alignment: Alignment.center,
                      height: final_hight,
                      width: final_hight,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: MemoryImage(list2[index]),
                        ),
                      ),
                    ),
                  )
                : DragTarget(
                    onAccept: (data) {
                      temp = List.filled(9, true);
                      var c = list2[data as int];
                      list2[data as int] = list2[index];
                      list2[index] = c;
                      if (listEquals(list2,list3)) {
                        temp = List.filled(9, false);
                        print("You Are Win");
                      }
                      setState(() {});
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: MemoryImage(list2[index]),
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
