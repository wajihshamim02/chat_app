import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_firebase/model/chat_user_data.dart';
import 'package:chat_app_firebase/screen/profile_screen.dart';
import 'package:chat_app_firebase/widgets/chat_user_card.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/apis.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // for Storing Search Status
  bool _issearch = false;

  //for Storing Search items
  List<chat_user_data> _searchList = [];

  //for Storing all Users
  List<chat_user_data> _list = [];

  @override
  void initState() {
    Apis.getSelfinfo(); //call in a initstate function
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        //if search is on & back button is pressed then check search
        //or else simple close current screen on back button click
        onWillPop: () { 
          if(_issearch){
            setState(() {
              _issearch = !_issearch;
            });
            // false mean nothing
          return Future.value(false);
          }
          else {
            //and true go to back button
             return Future.value(true);
          }
         },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme,
            title: _issearch
                ? TextField(
                    //Apply logic
                    onChanged: (value) {
                      _searchList.clear();
                      for (var i in _list) {
          
                        i.name.toLowerCase().contains(value.toLowerCase()) ||
                            i.email.toLowerCase().contains(value.toLowerCase());
          
                        _searchList.add(i);
          
                        setState(() {
                          //update the search List
                          _searchList;
                        });
                      }
                    },
                    autofocus: true,
                    style: const TextStyle(fontSize: 18, letterSpacing: 1),
                    decoration: const InputDecoration(
                        hintText: 'Name,Email...', border: InputBorder.none),
                  )
                : RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        children: [
                        TextSpan(
                            text: 'Buzz ', style: TextStyle(color: Colors.blue)),
                        TextSpan(
                            text: 'Chat', style: TextStyle(color: Colors.black)),
                      ])),
            leading: Icon(CupertinoIcons.home),
            actions: [
              IconButton(
                onPressed: () {
                  _issearch = !_issearch;
                  setState(() {});
                },
                icon: _issearch
                    ? const Icon(
                        Icons.clear,
                        color: Colors.red,
                      )
                    : const Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                                user: Apis.me,
                              )));
                },
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () async {
                await Apis.auth.signOut();
                await GoogleSignIn().signOut();
              },
              child: Icon(Icons.add_comment_outlined),
            ),
          ),
          body: StreamBuilder(
            stream: Apis.getAllusers(),
            builder: (BuildContext context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  // if data is not load show circle progress indicator
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
          
                case ConnectionState.active:
                case ConnectionState.done:
          
                  //check data is working or not
                  final data = snapshot.data?.docs;
                  _list = data
                          ?.map((e) => chat_user_data.fromJson(e.data()))
                          .toList() ??
                      [];
          
                  if (_list.isNotEmpty) {
                    return ListView.builder(
                         
                        itemCount: _issearch ? _searchList.length : _list.length, 
          
                        physics: BouncingScrollPhysics(),
                        itemBuilder: ((context, index) {
          
                          return ChatUserCard(

                            user: _issearch ? _searchList[index] : _list[index],
                          );
                          // return Text('Name ${list[index]}');
                        }));
                  } 
                  else {
                    return const Center(
                        child: Text(
                      'No conntection found',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ));
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
