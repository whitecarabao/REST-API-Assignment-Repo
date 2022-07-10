import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

String status = "No status";
Future<dynamic> getAllData() async {
  final response = await http.get(Uri.parse('http://localhost:3000/user/all'));

  if (response.statusCode == 200) {
    //print(jsonDecode(response.body)['data']);
    Map<String, dynamic> map = jsonDecode(response.body);
    final List<dynamic> jsonParse = map['data'];
    return jsonParse;
  } else {
    status = 'Error ${response.statusCode} encountered';
    throw Exception('Error ${response.statusCode} encountered');
  }
}

Future<dynamic> deleteUser(String id) async {
  final response = await http.delete(Uri.parse('http://localhost:3000/user/${id}'));

  if (response.statusCode == 200) {
    //print(jsonDecode(response.body)['data']);
    Map<String, dynamic> map = jsonDecode(response.body);
    final List<dynamic> jsonParse = map['data'];
    return jsonParse;
  } else {
    status = 'Error ${response.statusCode} encountered';
    throw Exception('Error ${response.statusCode} encountered');
  }
}

class GetAll extends StatefulWidget {
  const GetAll({Key? key}) : super(key: key);

  @override
  State<GetAll> createState() => _GetAllState();
}

class _GetAllState extends State<GetAll> {
  late var data;

  @override
  void initState() {
    super.initState();
    setState(() {
      data = getAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GET Web Request System"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<dynamic>(
                  future: data,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);

                      //return Text(snapshot.data.toString());
                      return ListView.builder(scrollDirection: Axis.vertical, shrinkWrap: true, itemCount: snapshot.data.length, itemBuilder: (BuildContext context, int index){
                        return Center(child: Column(children: [
                            ListTile(
                              contentPadding: EdgeInsets.all(30),
                          leading: const Icon(Icons.person),
                          trailing: Column(

                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  print("Delete");
                                  //dialog
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Delete"),
                                          content: Text("Are you sure you want to delete this user?"),
                                          actions: [
                                            FlatButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            FlatButton(
                                              child: Text("Delete"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  deleteUser(snapshot.data[index]['id']);
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext context) => super.widget));
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                 // deleteUser(snapshot.data);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  print("Edit");
                                  //open popup to edit name


                                },
                              ),
                            ],
                          ),

                          //Text(snapshot.data[index]['email'].toString()),
                          title: Text("User ${index} ${snapshot.data[index]['name'].toString()}"),
                          onTap:(){ print("User ${index} ${snapshot.data[index]['id'].toString()}");}
                          //when long pressed, delete user


                      )
                        ]));
                  });
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const CircularProgressIndicator();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
