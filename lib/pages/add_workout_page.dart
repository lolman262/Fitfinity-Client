import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../network/postWorkout.dart';

class AddWorkoutPage extends StatefulWidget {
  final int age;
  final int height;
  final String gender;
  final int weight;

  const AddWorkoutPage(
      {super.key,
      required this.age,
      required this.height,
      required this.weight,
      required this.gender});

 // const AddWorkoutPage({super.key});
  @override
  AddWorkoutPageState createState() => AddWorkoutPageState();
}

class AddWorkoutPageState extends State<AddWorkoutPage> {
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final goalController = TextEditingController();
  final experienceController = TextEditingController();
  final gymEquipmentController = TextEditingController();
  //   final int age = 0;
  // final int height =0;
  // final String gender = '';
  // final int weight = 0;
  bool loading = false;
  final hostname = 'https://api3.imnewwdomain.uk';
  var errMsg = '';


  @override
  void initState() {
    super.initState();
    preFillDetails();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  void preFillDetails() {
    // ageController.text = widget.age.toString();
    // heightController.text = widget.height.toString();
    // weightController.text = widget.weight.toString();
  }

  Future<void> submitWorkout() async {

    setState(() {
      errMsg = '';
      loading = true;
    });
    

    var age = 0;
    var height = 0;
    var weight = 0;
    var goal = goalController.text;
    var experience = experienceController.text;
    var gymEquipment = gymEquipmentController.text;
    var gender = widget.gender;

    try{
      age = int.parse(ageController.text);
      height = int.parse(heightController.text);
      weight = int.parse(weightController.text);
    }catch(e){
      errMsg = 'Please enter valid numbers';
      loading = false;
      return;
    }

    if(goal.isEmpty || age == 0 || height == 0 || weight == 0){
      errMsg = 'Please fill in all fields';
      loading = false;
      return;
    }

    

    if(gymEquipment.isEmpty){
      gymEquipment = "None";
    }
    if(experience.isEmpty){
      experience = "None";
    }


    int statusCode = await postWorkout(
        hostname, age, height, weight, gender, goal, experience, gymEquipment);

    if (statusCode == 200) {
      setState(() {
        loading = false;
        showToast('Workout added successfully');
      });
      if (mounted) {
        print("mounted!");
        Navigator.of(context).pop('success');
      }else{
        Navigator.pop(context);
      }
    } else {
        setState(() {
        loading = false;
        showToast('Failed to add workout');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Workout'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          errMsg,
                          style: TextStyle(color: Colors.red[600]),
                        ),
                      ],
                    ),
                  ),
            TextFormField(
              controller: weightController,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: ageController,
              decoration: const InputDecoration(
                labelText: 'Age (years)',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: heightController,
              decoration: const InputDecoration(
                labelText: 'Height (cm)',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: goalController,
              decoration: const InputDecoration(
                labelText: 'Goal for workout',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: experienceController,
              decoration: const InputDecoration(
                labelText: 'Previous workout experience (leave blank if none)',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: gymEquipmentController,
              decoration: const InputDecoration(
                labelText: 'Available gym equipment (leave blank if none)',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                 //Navigator.pop(context, 'Nope.');
                submitWorkout();
              },
              child: Builder(
                builder: (context) {
                  if (loading) {
                    return const CircularProgressIndicator();
                  } else {
                    return const Text('Submit');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
