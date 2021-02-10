import 'dart:io';

import 'package:chat_chat/Pages/chatDetail.dart';
import 'package:chat_chat/Provider/chatListProvider.dart';
import 'package:chat_chat/Provider/signalRProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SignalRProvider(),
          lazy: false,
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Chat',
      theme: ThemeData(primaryColor: Colors.blueGrey),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Chat'),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.add_circle_outline), onPressed: () {})
        ],
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ChatListProvider(),
          ),
        ],
        child: ChatList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {},
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_outline,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.chat_bubble,
              color: Theme.of(context).primaryColor,
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
            ),
            label: 'Me',
          ),
        ],
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ChatListProvider provider = Provider.of<ChatListProvider>(context);
    if (provider == null) {
      return Center(child: CircularProgressIndicator());
    }
    ScrollController controller = ScrollController();

    return SingleChildScrollView(
      controller: controller,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: provider.chats.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DetailPage()));
                    },
                    child: ListTile(
                      leading: Image.network(
                          provider.chats[index].userIds[0].avatarUrl),
                      title: Text(provider.chats[index].userIds[0].userName),
                      subtitle: Text(provider.chats[index].lastContent),
                      trailing: Text(provider.chats[index].lastUpdateTime),
                    ),
                  ),
                  Divider()
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
