import 'package:flutter/material.dart';
import 'package:MetroX/App/const/color.dart';
import 'package:MetroX/App/const/data.dart';
import 'package:MetroX/App/const/wigets.dart';

class StationListpage extends StatefulWidget {
  const StationListpage({super.key});

  @override
  State<StationListpage> createState() => _StationListpageState();
}

class _StationListpageState extends State<StationListpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c1,
        title: const Text("Stations List"),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: metroData.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50,
                  child: ListTile(
                    leading: Text("${index+1}.",style: const TextStyle(fontSize: 18),),
                    title: Text(metroData[index][1],style: const TextStyle(fontSize: 18),),
                    trailing: IconButton(
                        onPressed: () async {
                          openGoogleMap(context,"${metroData[index][1]} $selectedCity");
                        },
                        icon: const Icon(Icons.directions)),
                  ),
                ),
                const Divider()
              ],
            );
          }),
    );
  }
}
