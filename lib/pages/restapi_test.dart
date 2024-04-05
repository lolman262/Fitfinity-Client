import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestApiTest extends StatefulWidget {
  @override
  _RestApiTestState createState() => _RestApiTestState();
}

class _RestApiTestState extends State<RestApiTest> {
  String responseBody = '';
  List<dynamic> jsonData = [];



  Future<void> makeHttpRequest() async {
    var url = Uri.parse('http://localhost:3000/api/todos');

    print("making request");
    var response = await http.get(url);

    if (response.statusCode == 200) {
     print("status 200");
      // Request successful, handle response data here
      setState(() {
        var data = response.body;
        var jsonData = jsonDecode(data);
        var firstElement = jsonData[0];

        var dataString = "the id is ${firstElement["id"].toString()}, the task is ${firstElement["task"]} and the priotity status is ${firstElement["priority"]}";

        responseBody = dataString;
      });
    } else {
      // Request failed, handle error here
      throw Exception('Failed to load album');
      //  setState(() {responseBody = "Request failed";});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: makeHttpRequest,
            child: Text('Make HTTP Request'),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Text(responseBody),
          ),
        ],
      ),
    );
  }
}
