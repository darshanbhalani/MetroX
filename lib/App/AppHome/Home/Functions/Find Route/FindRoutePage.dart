import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:MetroX/App/AppHome/Home/Functions/Find%20Route/Algorithm.dart';
import 'package:MetroX/App/AppHome/Home/Functions/Find%20Route/RouteViewPage.dart';
import 'package:MetroX/App/const/color.dart';
import 'package:MetroX/App/const/data.dart';
import 'package:MetroX/App/const/wigets.dart';

class FindRoutePage extends StatefulWidget {
  const FindRoutePage({super.key});

  @override
  State<FindRoutePage> createState() => _FindRoutePageState();
}

class _FindRoutePageState extends State<FindRoutePage> {
  final _controller1 = SingleValueDropDownController();
  final _controller2 = SingleValueDropDownController();
  final _formkey = GlobalKey<FormState>();
  List<List<dynamic>> queue = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Route"),
        backgroundColor: c1,
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dropField(
                  context, "Source", metroStationsList, _controller1, true),
              dropField(context, "Destination", metroStationsList, _controller2, true),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () async {
          if(_formkey.currentState!.validate()){
            List stationList1=[];
            loading(context);
            final snapshot= await ref.ref("Cities/$selectedCity").orderByKey().get();
            List list=[];
            Map<dynamic,dynamic> values = snapshot.value as Map;
            values.forEach((key, value) {
              list.add(value);
            });
            for(int i=0;i<list.length;i++){
              Map temp =list[i];
              List temp1=[];
              temp1.add(int.parse(temp["No"]));
              temp1.add(temp["Name"]);
              temp1.add(temp["Line"]);
              temp1.add(temp["Connected Stations"]);
              stationList1.add(temp1);
            }
            for(int i=0;i<stationList1.length;i++){
              stationList1.sort((a, b) => a[1].compareTo(b[1]));
            }

            stationLineColor={};

            for(int i=0;i<stationList1.length;i++) {
              stationLineColor[stationList1[i][1]]=lineColor[stationList1[i][2]]!;
            }

            for (var item in stationList1) {
              String key = item[1];
              Set<String> value = Set<String>.from(item[3]);
              metroGraph[key] = value;
            }
            Graph graph = Graph();
            List<String>? path = graph.bfs(_controller1.dropDownValue!.value.toString(), _controller2.dropDownValue!.value.toString());
            Navigator.pop(context);
            if (path != null) {
              List route = path;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RouteViewPage(start:_controller1.dropDownValue!.value.toString(),end:_controller2.dropDownValue!.value.toString(),list: route),
                  ));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Somthing went wrong !"),
              ));
            }
          }
        },
        child: Container(
          height: 55,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration:
          BoxDecoration(color: c1, borderRadius: BorderRadius.circular(20)),
          child: const Center(child: Text("Next",style: TextStyle(color: Colors.white,fontSize: 22),)),
        ),
      ),
    );
  }

  dropField(context, String lable, List<DropDownValueModel> items,
      SingleValueDropDownController controller, bool condition) {
    return Column(
      children: [
        DropDownTextField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an option';
            }
            return null;
          },
          isEnabled: condition,
          clearOption: false,
          onChanged: (value) async {},
          controller: controller,
          dropDownItemCount: 5,
          dropDownList: items,
          dropdownRadius: 0,
          textFieldDecoration: InputDecoration(
            labelStyle: const TextStyle(
                color: Colors.black87
            ),
            labelText: lable,
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: c1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: c1,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

}
