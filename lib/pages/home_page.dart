import 'dart:convert';

import 'package:FitFinity/pages/add_workout_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../pages/login_page.dart';
import '../network/retreive_workout.dart';

class HomePage extends StatefulWidget {
  //final String data;
  final int age;
  final int height;
  final int weight;
  final String imagePath;
  final String username;
  final String gender;

  const HomePage({super.key, required this.age, required this.height, required this.weight, required this.imagePath, required this.username, required this.gender});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Widget> widgets = [
    
  ];

  Future<void> openAddWorkoutDialog(BuildContext context) async {
    String? result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => AddWorkoutPage( age: widget.age, height: widget.height, weight: widget.weight, gender:widget.gender),
        
        //builder: (BuildContext context) => AddWorkoutPage(),
        fullscreenDialog: true));


if (!context.mounted) return;
print(result);
    if(result == 'success'){
      retreiveWorkoutPlan();
    }

  }

  final hostname = 'https://api3.imnewwdomain.uk';
  var empty = true;
  Future<void> retreiveWorkoutPlan() async {

    //print(widget.imagePath);
    // Call the API to retrieve the workout plan
    // If the workout plan is empty, set empty to true
    // If the workout plan is not empty, set empty to false
    // and populate the widgets list with the workout plan
    List<dynamic> data = await retreiveWorkoutPlanLogic(hostname);

    if (data.isEmpty) {
      setState(() {
        empty = true;
      });
      // }else if (data.toString() == '[500]') {
      //   print('Error');
    } else {
      print('statement reached');
      setState(() {
        empty = false;
        widgets = [];
        //var workoutPlan = ;

        //print(data[0]);
        for (var workout in data) {
          DateTime dateTime = DateTime.parse(workout['created_at']);
          // Extract date and time components
          String date =
              "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
          String time =
              "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";

          // Print date and time
          // print("Date: $date");
          // print("Time: $time");
          widgets.add(const SizedBox(height: 20));
          widgets.add(
            
            Container(
              width: 450,
              //height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child:  

              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$time",
                          style: const TextStyle(
                            fontSize: 18,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 18,
                           // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 430,
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${workout['day_1_title']}",
                          style: TextStyle(
                            fontSize: 24,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${workout['day_1_content']}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 430,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${workout['day_2_title']}",
                          style: TextStyle(
                            fontSize: 24,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${workout['day_2_content']}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 430,
                    decoration: BoxDecoration(
                      color: Colors.yellowAccent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${workout['day_3_title']}",
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          "${workout['day_3_content']}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 430,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${workout['day_4_title']}",
                          style: const TextStyle(
                            fontSize: 24,
                            
                          ),
                        ),
                        Text(
                          "${workout['day_4_content']}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 430,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${workout['day_5_title']}",
                          style: const TextStyle(
                            fontSize: 24,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${workout['day_5_content']}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 430,
                    decoration: BoxDecoration(
                      color: Colors.indigoAccent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${workout['day_6_title']}",
                          style: const TextStyle(
                            fontSize: 24,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${workout['day_6_content']}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 430,
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${workout['day_7_title']}",
                          style: const TextStyle(
                            fontSize: 24,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${workout['day_7_content']}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    retreiveWorkoutPlan();
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home | Fitfinity"),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage('$hostname/${widget.imagePath}'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
              // Add your logout logic here
            },
            child: const Text(
              "Log out",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: 
            SingleChildScrollView(
              child: SizedBox(
                width: 800,
                child: Column(
                  children: [

                 //   ExpansionTile(title: Text('Hi'), children: );



                    Builder(builder: (context) {
                      if (empty) {
                        return Text(
                          'Welcome, you have no Workout plan,\nStart by creating one by clicking the Add button!',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        );
                      } else {
                        return Column(
                          children: widgets,
                        );
                      }
                    }),
                    // Container(
                    //   width: 200,
                    //   height: 200,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(10),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.grey.withOpacity(0.5),
                    //         spreadRadius: 2,
                    //         blurRadius: 5,
                    //         offset: Offset(0, 3),
                    //       ),
                    //     ],
                    //   ),
                    //   child: Center(
                    //     child: Text(
                    //       'Rounded Container',
                    //       style: TextStyle(
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Text(widget.data),
                    // Center(
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.pop(context);
                    //     },
                    //     child: Text('Logout'),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
        ),
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openAddWorkoutDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
