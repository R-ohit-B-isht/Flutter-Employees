import 'package:flutter/material.dart';

import 'api.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployeesScreen extends StatefulWidget {
  EmployeesScreen({Key? key, required this.title}) : super(key: key);

  final String title;
  final EmploysApi api = EmploysApi();

  @override
  _EmployeesScreenState createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  List myemployees = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    widget.api.getEmploys().then((data) {
      setState(() {
        myemployees = data;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: .5,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Name'), Text('Experience(yrs)')],
                ),
                backgroundColor: Colors.blue,
                shadowColor: Colors.white,
              ),
              body: Container(
                child: ListView(
                    children: myemployees
                        .map<Widget>((employ) => Container(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              color: Colors.grey[200],
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ListTile(
                                  title: Text(
                                    employ['name'],
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: int.parse(employ['experience']) < 5
                                          ? Colors.black
                                          : Colors.green,
                                    ),
                                  ),
                                  trailing: CircleAvatar(
                                    child: Text(employ['experience'],
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor:
                                        int.parse(employ['experience']) < 5
                                            ? Colors.grey
                                            : Colors.green,
                                  ),
                                ),
                              ),
                            )))
                        .toList()),
              ),
            ),
    );
  }
}
