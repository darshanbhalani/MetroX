import 'package:flutter/material.dart';
import 'package:MetroX/App/const/color.dart';
import 'package:MetroX/App/const/data.dart';

class RouteViewPage extends StatefulWidget {
  final String start;
  final String end;
  final List list;
  const RouteViewPage({super.key,required this.start,required this.end,required this.list});

  @override
  State<RouteViewPage> createState() => _RouteViewPageState();
}

class _RouteViewPageState extends State<RouteViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: c1,
          title: Text("${widget.start} to ${widget.end}"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 12),
          child: ListView.builder(
              itemCount: widget.list.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 6,
                                    color: index==0 ? Colors.transparent:stationLineColor[widget.list[index]],
                                  ),Container(
                                    height: 30,
                                    width: 6,
                                    color: index==widget.list.length-1 ? Colors.transparent:stationLineColor[widget.list[index]],
                                  ),
                                ],
                              ),
                              Center(child: Icon(Icons.circle,color:stationLineColor[widget.list[index]]))
                            ],
                          ),
                          const SizedBox(width: 25,),
                          Text(widget.list[index])
                        ],
                      ),
                    )
                );
              }),
        )
    );
  }
}
