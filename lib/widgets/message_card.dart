import 'package:chat_app_firebase/helper/mydateutils.dart';
import 'package:chat_app_firebase/model/messagess.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';

class MessageCard extends StatefulWidget {

  final Messages message;

  const MessageCard({Key? key, required this.message}) : super(key: key);

  @override
  _MessageCardState createState() => _MessageCardState();
}
class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Apis.user.uid == widget.message.fromid
        ? _greenmessage()
        : _bluemessage();
  }
//sender or other person
  Widget _bluemessage() {

    //update last read message if sender and receiver are different
    if(widget.message.read!.isEmpty){
      Apis.updateMessageReadStatus(widget.message);
      print('log update status');
    }
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04, vertical: size.height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Container(
              // margin: EdgeInsets.symmetric(horizontal: size.width*0.04,vertical: size.height*0.01),
              padding: EdgeInsets.all(
                size.width * 0.04,
              ),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  color: Color.fromARGB(255, 187, 233, 255)),
              child: Text(
                widget.message.msg!,
                style: TextStyle(color: Colors.black87, fontSize: 15),
              ),
            ),
          ),
          //message time
          SizedBox(
            width: size.width * 0.05,
          ),
          Row(
            children: [
              Icon(Icons.done_all,color: Colors.blue,size: 20,),
               SizedBox(width:size.width*0.01,),
              Text(
               date_utis.getformattedtime(context: context, time: widget.message.sent!),
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          )
        ],
      ),
    );
  }

//user or you
  Widget _greenmessage() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04, vertical: size.height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [

              //message time
              
              if(widget.message.read!.isNotEmpty)
               //double tick of msg read
               Icon(Icons.done_all,color: Colors.blue,size: 20,),

               SizedBox(width:size.width*0.01,),

              Text(
                date_utis.getformattedtime(context: context, time: widget.message.sent!),
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
          Flexible(
            child: Container(
              // margin: EdgeInsets.symmetric(horizontal: size.width*0.04,vertical: size.height*0.01),
              padding: EdgeInsets.all(
                size.width * 0.04,
              ),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                  color: Color.fromARGB(255, 176, 255, 142)),
                 
              child: Text(
                widget.message.msg! ,
                style: TextStyle(color: Colors.black87, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
