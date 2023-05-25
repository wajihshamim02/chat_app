import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_firebase/helper/dialogs.dart';
import 'package:chat_app_firebase/model/chat_user_data.dart';
import 'package:chat_app_firebase/screen/Auth/login_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '../api/apis.dart';

class ProfileScreen extends StatefulWidget {
  final chat_user_data user;
  ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  //Image is null
  String? _image;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          title: RichText(
              text: const TextSpan(
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  children: [
                TextSpan(
                    text: 'Profile ', style: TextStyle(color: Colors.blue)),
                TextSpan(text: 'Screen', style: TextStyle(color: Colors.black)),
              ])),
          leading: Icon(CupertinoIcons.home),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.all(8.0),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.red,
            onPressed: () async {
              //showing progress bar
              dialogs.showprogressbar(context);
              await Apis.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  //hiding progress bar
                  Navigator.pop(context);

                  //for moving home screen
                  Navigator.pop(context);

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: ((context) => LoginScreen())));
                });
              });
            },
            icon: Icon(Icons.logout_outlined),
            label: Text('Log out'),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.08,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        //Local Image
                        _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  size.height * 0.1,
                                ),
                                child: Image.file(
                                  File(_image!),
                                  width: size.width * 0.42,
                                  height: size.height * 0.2,
                                  fit: BoxFit.cover,
                                ),
                              )
                            //Image from server
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  size.height * 0.1,
                                ),
                                child: CachedNetworkImage(
                                  width: size.width * 0.42,
                                  height: size.height * 0.2,
                                  imageUrl: widget.user.image,
                                  fit: BoxFit.cover,
                                  // placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                    child: Icon(Icons.error),
                                  ),
                                ),
                              ),
                        Positioned(
                          bottom: 1,
                          right: 1,
                          child: InkWell(
                            onTap: () {
                              _showbottomsheet();
                            },
                            child: Container(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(Icons.edit, color: Colors.blue),
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  // width: 1,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    50,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(widget.user.email),
                  SizedBox(
                    height: size.height * 0.03,
                  ),

                  //text input field
                  TextFormField(
                    onSaved: (newValue) => Apis.me.name = newValue!,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        null;
                      } else {
                        'Required field';
                      }
                    },
                    initialValue: widget.user.name,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.blue,
                        ),
                        label: Text('Name'),
                        hintText: 'Ali khan'),
                  ),

                  SizedBox(
                    height: size.height * 0.03,
                  ),

                  // text input field
                  TextFormField(
                    onSaved: (newValue) => Apis.me.about = newValue!,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        null;
                      } else {
                        'Required field';
                      }
                    },
                    initialValue: widget.user.about,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                        ),
                        label: Text('about'),
                        hintText: 'Hey , im using Buzz Chat'),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        minimumSize: Size(size.width * 0.4, size.height * 0.07),
                      ),
                      onPressed: () {
                        //update
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          //Call update Method
                          Apis.UpdateUserInfo().then((value) =>
                              dialogs.showsnackbar(context,
                                  'Information is Updated Successfully'));
                        }
                      },
                      icon: Icon(Icons.update),
                      label: Text(
                        'Update',
                        style: TextStyle(fontSize: 20),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showbottomsheet() {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return ListView(
            shrinkWrap: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Pick Profiile Picture',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(shape: CircleBorder()),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          // Pick an image.
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery);

                          // Capture a photo.
                          if (image != null) {
                            print(image.path);

                            //Hide Bottom Sheet
                            Navigator.pop(context);
                            setState(() {
                              _image = image.path;
                            });

                            //updating image
                            Apis.storeimage(
                              File(_image!),
                            );
                          }
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          child: Image(
                            image: AssetImage('images/image-pick.png'),
                            height: 60,
                            width: 60,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(shape: CircleBorder()),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          // Pick an image.
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          // Capture a photo.
                          if (image != null) {
                            print(image.path);

                            //Hide Bottom Sheet
                            Navigator.pop(context);
                            setState(() {
                              _image = image.path;
                            });

                            //updating image
                            Apis.storeimage(
                              File(_image!),
                            );
                          }
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          child: Image(
                            image: AssetImage('images/camera.png'),
                            height: 60,
                            width: 60,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 50,
                  )
                ],
              )
            ],
          );
        });
  }
}
