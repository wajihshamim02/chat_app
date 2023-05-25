import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_firebase/model/chat_user_data.dart';
import 'package:chat_app_firebase/model/messagess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final chat_user_data user;

  ChatScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

//for storing all messages
  List<Messages> _list = [];

  //for handling messages text changes
  final _textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    )),
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    size.height * 0.1,
                  ),
                  child: CachedNetworkImage(
                    width: size.width * 0.12,
                    height: size.height * 0.06,
                    imageUrl: widget.user.image,
                    fit: BoxFit.cover,
                    // placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => CircleAvatar(
                      child: Icon(Icons.error),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name,
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                    ),
                    Text(
                      'Last seen Yesterday',
                      style: TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                  ],
                )
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: Apis.getAllMessages(widget.user),
                  builder: (BuildContext context, snapshot) {
                    switch (snapshot.connectionState) {
                      //if data is Loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        // if data is not load show circle progress indicator
                        return Center(
                          child: SizedBox(),
                        );

                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        // log('Data: ${jsonEncode(data![0].data())}');

                        _list = data
                                ?.map((e) => Messages.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              itemCount: _list.length,
                              itemBuilder: ((context, index) {
                                return MessageCard(
                                  message: _list[index],
                                );
                              }));
                        } else {
                          return const Center(
                              child: Text(
                            'Say hi! 👋',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ));
                        }
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.emoji_emotions_outlined,
                                  color: Colors.green[500],
                                )),
                            Expanded(
                              child: TextField(
                                controller: _textcontroller,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Write Something ...'),
                              ),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  CupertinoIcons.camera,
                                  color: Colors.green[500],
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.image_outlined,
                                  color: Colors.green[500],
                                )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    MaterialButton(
                      padding: const EdgeInsets.only(
                          left: 12, right: 12, top: 16, bottom: 16),
                      onPressed: () 
                      {
                        if (_textcontroller.text.isNotEmpty) {
                          Apis.sendMessage(widget.user, _textcontroller.text);
                        }
                      },
                      minWidth: 0,
                      shape: CircleBorder(),
                      color: Colors.blue,
                      child: Icon(
                        Icons.play_arrow_sharp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
