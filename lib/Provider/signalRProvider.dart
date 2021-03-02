import 'dart:convert';

import 'package:chat_chat/Models/sendMsgTemplate.dart';
import 'package:chat_chat/Pages/chatDetail.dart';
import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';

class SignalRProvider with ChangeNotifier {
  HubConnection conn;
  String connId;
  String avt1 = 'https://pic4.zhimg.com/da8e974dc_is.jpg';
  String avt2 =
      'https://pic4.zhimg.com/v2-0edac6fcc7bf69f6da105fe63268b84c_is.jpg';

  List<ChatRecord> chats = [];

  SignalRProvider() {
    chats.add(ChatRecord(
        sender: 0,
        content: 'Hi, how' 're you doing?',
        avatarUrl: avt1,
        chatType: ChatType.text));
    chats.add(ChatRecord(
        sender: 1,
        content: 'Good, how' 're you?',
        avatarUrl: avt2,
        chatType: ChatType.text));
    chats.add(ChatRecord(
        sender: 0,
        content: 'Could you borrow me some money？😭',
        avatarUrl: avt1,
        chatType: ChatType.text));
    chats.add(ChatRecord(
        sender: 1,
        content: 'I, uh, I have'
            'I have better things to do',
        avatarUrl: avt2,
        chatType: ChatType.text));

    conn = HubConnectionBuilder()
        .withUrl(
            'https://192.168.50.50:5001/chatHub', // update the domain to your local address (check with 'ifconfig' in terminal)
            HttpConnectionOptions(
              withCredentials: false,
              logging: (level, message) => print(message),
            ))
        .build();

    conn.start();

    conn.on('receiveConnId', (message) {
      print(message.toString());
      connId = message.first.toString();
      notifyListeners();
    });

    conn.on('receiveMsg', (message) {
      print(message.toString());
      chats.add(ChatRecord(
          content: message.first.toString(), avatarUrl: avt2, sender: 1));
      notifyListeners();
    });
  }

  sendMessage(msg) {
    conn.invoke(
      'receiveMsg',
      args: [
        jsonEncode(SendMsgTemplate(fromWhom: connId, toWhom: '', message: msg)
            .toJson())
      ],
    );
    chats.add(ChatRecord(content: msg, avatarUrl: avt1, sender: 0));
    notifyListeners();
  }
}
