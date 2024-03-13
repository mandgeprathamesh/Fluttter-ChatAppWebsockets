import 'package:chat_app_nodejs/controller/chat_controller.dart';
import 'package:chat_app_nodejs/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Color purple = Color(0xFF6c5ce7);
  Color black = Color(0xFF191919);
  TextEditingController msgcontroller = TextEditingController();
  late IO.Socket socket;
  chatcontroller chatConntroller = chatcontroller();

  @override
  void initState() {
    socket = IO.io(
        "http://10.0.2.2:8000",
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());
    socket.connect();
    setupSocketlistner();
    super.initState();
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  void sendmessage(String text) {
    var messagejson = {"message": text, "sentbyme": socket.id};
    socket.emit('message', messagejson);
    chatConntroller.chatmessages.add(Message.fromJson(messagejson));
  }

  void setupSocketlistner() {
    socket.on('message-recieve', (data) {
      chatConntroller.chatmessages.add(Message.fromJson(data));
    });
    socket.on('connnected-user', (data) {
      chatConntroller.connecteduser.value = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Connected user are:${chatConntroller.connecteduser}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 9,
                  child: Obx(
                    () => ListView.builder(
                      itemCount: chatConntroller.chatmessages.length,
                      itemBuilder: (context, index) {
                        var currentItem = chatConntroller.chatmessages[index];
                        return MessageItem(
                          sentbyme: currentItem.sentbyme == socket.id,
                          message: currentItem.message,
                        );
                      },
                    ),
                  )),
              Container(
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: black,
                  child: TextField(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    cursorColor: purple,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: purple),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        suffixIcon: Container(
                          child: IconButton(
                              color: Colors.white,
                              onPressed: () {
                                sendmessage(msgcontroller.text);
                                msgcontroller.text = "";
                              },
                              icon: Icon(Icons.send)),
                        )),
                    controller: msgcontroller,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageItem extends StatelessWidget {
  const MessageItem({Key? key, required this.sentbyme, required this.message})
      : super(key: key);
  final bool sentbyme;
  final String message;

  @override
  Widget build(BuildContext context) {
    Color purple = Color(0xFF6c5ce7);

    return Align(
      alignment: sentbyme ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: sentbyme ? purple : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              message.toString(),
              style: TextStyle(
                  fontSize: 18, color: sentbyme ? Colors.white : purple),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              "1:10 AM",
              style: TextStyle(
                  fontSize: 10,
                  color: (sentbyme ? Colors.white : purple).withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}
