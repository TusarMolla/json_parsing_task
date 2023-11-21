import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_parsing_task/android_verison_model.dart';
import 'package:json_parsing_task/data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Json Parsing Task',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Json Parsing Task'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<AndroidVersion> dataList=[];
  TextEditingController searchController = TextEditingController(text: "");

  convertList(data){
    dataList.clear();
    data.forEach((element){
      if(element.runtimeType == List<Map<String, Object>>){
        element.forEach((data) {
              addData(data);
        });
      }else{
        var previous =0;
        element.forEach((key, value) {
          while(int.parse(key.toString()) > previous){
            previous++;
            addData(null);
          }
          addData(value);
          previous++;
        });
      }
    });
    setState(() {

    });
  }
  addData(data){
    dataList.add(AndroidVersion(id:data?['id'],title: data?['title'] ));
  }

AndroidVersion?  search(id){
   return dataList.firstWhere((element) => element.id==id,orElse: ()=>AndroidVersion());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
                onPressed: (){convertList(Data.data1);}, child:const Text("Input-1",style: TextStyle(fontSize: 14,color: Colors.white),)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
                onPressed: (){convertList(Data.data2);}, child:const Text("Input-2",style: TextStyle(fontSize: 14,color: Colors.white),)),
            if(dataList.isNotEmpty)
            buildSearchOption(context),
            buildListView(),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  ListView buildListView() {
    return ListView.separated(
              physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context,index)=>Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: Text(dataList[index].title??"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),),
                separatorBuilder: (context,index)=>Container(height: 10,),
                itemCount: dataList.length);
  }

  Padding buildSearchOption(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: searchController,
                    ),
                  ),ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: (){
                        var data =  search(int.parse(searchController.text.trim()));
                        buildShowDialog(context, data);
                      }, child:const Text("Search",style: TextStyle(fontSize: 14,color: Colors.white),)),
                ],
              ),
            );
  }

  Future<dynamic> buildShowDialog(BuildContext context, AndroidVersion? data) {
    return showDialog(context: context, builder: (context)=>AlertDialog(
                          content: Text(data?.title??"No data found"),
                          actions: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: (){
                                  Navigator.pop(context);
                                }, child:const Text("Ok",style: TextStyle(fontSize: 14,color: Colors.white),)),
                          ],
                        ));
  }
}
