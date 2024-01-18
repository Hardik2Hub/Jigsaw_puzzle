import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'game.dart';

void main() {
  runApp(MaterialApp(
    home: game(),
    debugShowCheckedModeBanner: false,
  ));
}

class gameplay extends StatefulWidget {
  @override
  State<gameplay> createState() => _gameplayState();
}

class _gameplayState extends State<gameplay> {
  List list = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'];
  List list1 = [];
  List temp = List.filled(9, true);

  @override
  void initState() {
    super.initState();
    list1.addAll(list);
    list.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    double total_hight = MediaQuery.of(context).size.width;
    double final_hight = (total_hight - 20) / 3;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Slipt Image"),
        ),
        body: GridView.builder(
          itemCount: 9,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
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
                        color: Colors.blueGrey,
                        child: Text(
                          "${list[index]}",
                          style: TextStyle(fontSize: 25),
                        )),
                    feedback: Container(
                      alignment: Alignment.center,
                      height: final_hight,
                      width: final_hight,
                      color: Colors.red,
                      child: Text(
                        "${list[index]}",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  )
                : DragTarget(
                    onAccept: (data) {
                      temp = List.filled(9, true);
                      var c = list[data as int];
                      list[data as int] = list[index];
                      list[index] = c;
                      if (listEquals(list, list1)) {
                        temp = List.filled(9, false);
                        print("Your Are Win");
                      }
                      setState(() {});
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        color: Colors.blueAccent,
                        alignment: Alignment.center,
                        child: Text("${list[index]}",
                            style:
                                TextStyle(fontSize: 30, color: Colors.white)),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
