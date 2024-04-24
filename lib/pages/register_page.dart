import 'package:FitFinity/network/register_user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
//import 'package:image_field/image_field.dart';
//import '../components/my_textfield.dart';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  _RegisterPageState createState() => _RegisterPageState();
}
///////////////////////////////////
//////
///inmplement submit button
///
///

///

enum Gender { male, female, other }

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cPasswordController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  Gender _selectedGender = Gender.male;
  var errMsg = '';
  var errPassMsg = '';
  var errBtnMsg = '';
  var loading = false;
  late PickedFile _imageFile = PickedFile('');
  final ImagePicker _picker = ImagePicker();
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  late Uint8List objImage;
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        final bytes = await pickedFile.readAsBytes();
        //imageBytes = bytes;
        final image = await decodeImageFromList(bytes);
        objImage = bytes;
        // image.toString();
        //image.

        setState(() {
          _imageFile = PickedFile(pickedFile.path);
        });
      } on Exception catch (e) {
        print('Failed to decode image: $e');
        // Handle the error or show an error message to the user.
      }
    }
  }

  Future<void> registerSubmit() async {
    errPassMsg = '';
    errMsg = '';
    errBtnMsg = '';

    setState(() {
      loading = true;
    });
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        cPasswordController.text.isEmpty ||
        ageController.text.isEmpty ||
        heightController.text.isEmpty ||
        weightController.text.isEmpty) {
      setState(() {
        errMsg = 'Please fill in all fields';
        loading = false;
      });
      return;
    }


    const hostname = 'https://api3.imnewwdomain.uk';
    final username = usernameController.text;
    final password = passwordController.text;
    final ageStr = ageController.text;
    final email = emailController.text;
    final weightStr = weightController.text;
    if (passwordController.text.length < 8) {
      setState(() {
        errPassMsg = 'Password must be at least 8 characters';
        loading = false;
      });

      return;
    }
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if(!emailRegex.hasMatch(email)){
    setState(() {
        errMsg = 'Enter a valid email';
        loading = false;
      });
      return;
  }

    
    int age = 0;
   
    try {
      age = int.parse(ageStr);
      if (age < 1 || age > 100) {
        setState(() {
          errMsg = 'Enter a valid age between 1 and 100';
          loading = false;
        });
        return;
        //print("Age is not within the range of 1 to 100");
      }
    } catch (e) {
      // If conversion to integer fails, it means the string is not a valid number
      setState(() {
        errMsg = 'Enter a valid age between 1 and 100';
        loading = false;
      });
      return;
    }

    final heightStr = heightController.text;
    int height = 0;
    try {
      height = int.parse(heightStr);
      if (height < 1 || height > 300) {
      
        setState(() {
          errMsg = 'Enter a valid height between 1 and 300 cm';
          loading = false;
        });
        return;
        //print("Age is not within the range of 1 to 100");
      }
    } catch (e) {
      // If conversion to integer fails, it means the string is not a valid number
      setState(() {
        errMsg = 'Enter a valid height between 1 and 300 cm';
        loading = false;
      });
      return;
    }
    
    int weight = 0;
    try {
       weight = int.parse(weightStr);
      if (weight >= 1 || weight <= 300) {
        // Age is between 1 and 100
      } else {
        // Age is not within the desired range
        setState(() {
          errMsg = 'Enter a valid weight between 1 and 400 kg';
          loading = false;
        });
        return;
        //print("Age is not within the range of 1 to 100");
      }
    } catch (e) {
      // If conversion to integer fails, it means the string is not a valid number
      setState(() {
        errMsg = 'Enter a valid weight between 1 and 400 kg';
        loading = false;
      });
      return;
    }


    try{
      lookupMimeType('', headerBytes: objImage);
    }catch(e){
      setState(() {
        errMsg = 'Please select a profile picture';
        loading = false;
      });
      return;
    }
    final mimeType = lookupMimeType('', headerBytes: objImage);
    final extension = extensionFromMime(mimeType!);

    print(age.toString());
    var formData = FormData.fromMap({
      'username': username,
      'password': password,
      'gender': _selectedGender.name,
      'profilePicture': MultipartFile.fromBytes(objImage as List<int>,
          filename: 'profilePicture.$extension',
          contentType: MediaType.parse(mimeType)),
      'age': age.toString(),
      'email' : email.toString(),
      'height': height.toString(),
      'weight': weight.toString(),
    });

    
    var statuscode = await registerLogic(hostname, formData);

    if (statuscode == 200) {
      setState(() {
        loading = false;
      });
      showToast('Registration successful');
      Navigator.pop(context);
    } else {
      setState(() {
        errBtnMsg = 'Registration failed';
        loading = false;
      });
    }
    // registerLogic(
    //    hostname, username, password, _selectedGender.name, age, weight, objImage);
    // print('Username: ${usernameController.text}');
    // print('Email: ${emailController.text}');
    // print('Password: ${passwordController.text}');
    // print('Confirm Password: ${cPasswordController.text}');
    // print('Gender: ${_selectedGender.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register | Fitfinity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Profile picture',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  if (_imageFile.path != '')
                    Image.network(
                      _imageFile.path,
                      width: 150, // set the desired width
                      height: 150, // set the desired height
                    )
                  else
                    Image.asset(
                      'lib/images/add_profile.png',
                      width: 150, // set the desired width
                      height: 150, // set the desired height
                    ),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Pick Image'),
                  ),
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
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      //errorText: 'Please fill in all fields',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password (min 8 characters)',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          errPassMsg,
                          style: TextStyle(color: Colors.red[600]),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    controller: cPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: ageController,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                    ),
                    obscureText: false,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: weightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                    ),
                    obscureText: false,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: heightController,
                    decoration: const InputDecoration(
                      labelText: 'Height (cm)',
                    ),
                    obscureText: false,
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    children: [
                      const Text(
                        'Gender',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      ListTile(
                        title: const Text('Male'),
                        leading: Radio(
                          value: Gender.male,
                          groupValue: _selectedGender,
                          onChanged: (Gender? value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Female'),
                        leading: Radio(
                          value: Gender.female,
                          groupValue: _selectedGender,
                          onChanged: (Gender? value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Text(
                    errBtnMsg,
                    style: TextStyle(color: Colors.red[600]),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      registerSubmit();
                    },
                    child: Builder(
                      builder: (context) {
                        if (loading) {
                          return const CircularProgressIndicator();
                        } else {
                          return const Text('Register');
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




//im tired boss