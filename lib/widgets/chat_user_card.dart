import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_firebase/api/apis.dart';
import 'package:chat_app_firebase/model/chat_user_data.dart';
import 'package:chat_app_firebase/model/messagess.dart';
import 'package:chat_app_firebase/screen/chat_Screen.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final chat_user_data user;
  ChatUserCard({Key? key, required this.user}) : super(key: key);

  @override
  _ChatUserCardState createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Messages? _message;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Card(
        margin: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.height * 0.01),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Color.fromARGB(255, 244, 249, 253),
        elevation: 1,
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => ChatScreen(user: widget.user))));
            },
            child: StreamBuilder(
                stream: Apis.getLastMessage(widget.user),
                builder: (context, snapshot) {
                  final data = snapshot.data?.docs;

                  final list =
                      data?.map((e) => Messages.fromJson(e.data())).toList() ??
                          [];

                  if (list.isNotEmpty) _message = list[0];

                  return ListTile(
                    // leading: CircleAvatar(child: Icon(Icons.abc),),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        width: size.width * 0.14,
                        height: size.height * 0.1,
                        fit: BoxFit.cover,
                        imageUrl: widget.user.image,
                        // placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          child: Icon(Icons.error),
                        ),
                      ),
                    ),
                    title: Text(widget.user.name),
                    subtitle: Text(
                      _message != null
                          ? _message!.msg ?? 'wajih'
                          : widget.user.about,
                      maxLines: 1,
                    ),
                    // trailing: Text('12:00 PM',style: TextStyle(color: Colors.black54),),
                    trailing: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                })));
  }
}
