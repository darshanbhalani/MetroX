import 'package:flutter/material.dart';
import 'package:MetroX/App/const/color.dart';
import 'package:MetroX/App/const/data.dart';

class FAQandSupportPage extends StatefulWidget {
  const FAQandSupportPage({Key? key}) : super(key: key);

  @override
  State<FAQandSupportPage> createState() => _FAQandSupportPageState();
}

class _FAQandSupportPageState extends State<FAQandSupportPage> {
  int? flag;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQ & Support"),
        backgroundColor: c1,
      ),
      body: ListView.builder(
        itemCount: FAQ.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: (){
                  if(flag!=index){
                    flag=index;
                  }
                  else{
                    flag=null;
                  }
                  setState(() {});
                },
                child: ListTile(
                  title: Text(FAQ[index][0]),
                  trailing: flag==index ? const Icon(Icons.arrow_drop_up):const Icon(Icons.arrow_drop_down),
                  subtitle: flag==index ? Text("${"\n"+FAQ[index][1]}\n"):null,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(thickness: 1,),
              )
            ],
          );
        },
      ),
    );
  }
}
