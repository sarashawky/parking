import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking/components/chat_bubble.dart';
import 'package:parking/components/input_text_field.dart';
import 'package:parking/services/auth/auth_service.dart';
import 'package:parking/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messsageController = TextEditingController();

  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  FocusNode myFocusNode = FocusNode();
  User? user;
void sendMessage() async {
    if (_messsageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverID, _messsageController.text,user);
      _messsageController.clear();
    }
    scrollDown();
  }

  @override
  void initState() {
    _authService.signInAnonymously().then((value) {
      setState(() {
        user=value;
      });
    },);
    myFocusNode.addListener(() {
      if(myFocusNode.hasFocus){
        Future.delayed(Duration(microseconds: 500),
          () => scrollDown(),);
      }
    },);
    Future.delayed(Duration(microseconds: 500),
          () => scrollDown(),);
  }


  @override
  void dispose() {
    myFocusNode.dispose();
    _messsageController.dispose();
    super.dispose();
  }

  // final ScrollController _scrollController =ScrollController();
  scrollDown() {
    // _scrollController.animateTo(
    //     _scrollController.position.maxScrollExtent,
    //     duration: const Duration(seconds: 1),
    //     curve: Curves.fastOutSlowIn);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text(widget.receiverEmail),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: _buildMessageList(),
              ),
              _buildUserInput()
            ],
          ),
        ));
  }

  Widget _buildMessageList() {
    String senderId = user!=null?user!.uid:"";
    return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverID, senderId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading ....");
          }
          return ListView(
            // controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == user!.uid;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
          )
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Row(
        children: [
          Expanded(
              child: InputTextField(
                focusNode: myFocusNode,
            controller: _messsageController,
            hintText: "Type a message",
            obscureText: false,
          )),
          Container(
              decoration: BoxDecoration(
                  color: Colors.green, shape: BoxShape.circle),
              margin: EdgeInsets.only(left: 5),
              child: IconButton(
                  onPressed: sendMessage,
                  icon: Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  )))
        ],
      ),
    );
  }

}
