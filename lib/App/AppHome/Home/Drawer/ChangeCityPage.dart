import 'package:flutter/material.dart';
import 'package:MetroX/App/AppHome/HomePage.dart';
import 'package:MetroX/App/const/color.dart';
import 'package:MetroX/App/const/data.dart';
import 'package:MetroX/App/const/wigets.dart';

class ChangeCityPage extends StatefulWidget {
  final bool flag;
  const ChangeCityPage({super.key, required this.flag});

  @override
  State<ChangeCityPage> createState() => _ChangeCityPageState();
}

class _ChangeCityPageState extends State<ChangeCityPage> {
  @override
  void initState() {
    if(selectedCity != null){
      isSelected=true;
    }
    temp = selectedCity.toString();
    flag = Cities.indexOf(selectedCity);
    setState(() {});
    super.initState();
  }

  bool isSelected=false;
  String temp = "";
  int? flag;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        !widget.flag ? snackBar(context, Colors.red, "Please select city."):null;
        return widget.flag;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Change/Select City"),
          backgroundColor: c1,
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 12, bottom: 12),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Adjust the number of columns here
              crossAxisSpacing:
                  10.0, // Adjust the horizontal spacing between grid items
              mainAxisSpacing:
                  10.0, // Adjust the vertical spacing between grid items
            ),
            itemCount: Cities.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  isSelected=true;
                  flag = index;
                  temp = Cities[index];
                  setState(() {});
                },
                child: GridTile(
                  child: Container(
                    decoration: BoxDecoration(
                        color: index == flag ? c2 : Colors.white,
                        border: Border.all(
                            color: index == flag ? c1 : Colors.grey,
                            width: index == flag ? 2 : 1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Cities[index],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: c1,
                            ),
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: FloatingActionButton.extended(
            elevation: 0,
            focusElevation: 0,
            hoverElevation: 0,
            highlightElevation: 0,
            disabledElevation: 0,
            onPressed: () async {
              if (selectedCity != temp || selectedCity == null) {
                if(isSelected && (temp=="Ahmedabad" || temp=="Nagpur")){
                  loading(context);
                  await buildDataBase(temp);
                  // Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),(route)=>false);
                }else{
                  snackBar(context, Colors.red, "MetroX is not available in selected city.");
                }
              } else {
                if(!isSelected){
                  snackBar(context, Colors.red, "Please select city.");
                }
                if (widget.flag) {
                  Navigator.pop(context);
                }
              }
            },
            label: Container(
              height: 55,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  color: c1, borderRadius: BorderRadius.circular(20)),
              child: const Center(
                  child: Text(
                "Next",
                style: TextStyle(color: Colors.white, fontSize: 22),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
