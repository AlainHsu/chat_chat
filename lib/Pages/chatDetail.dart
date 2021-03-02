import 'dart:math';

import 'package:chat_chat/Provider/signalRProvider.dart';
import 'package:chat_chat/Provider/voiceRecordProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SignalRProvider provider = Provider.of<SignalRProvider>(context);
    if (provider == null || provider.conn == null || provider.connId == null) {
      return Container(
        color: Colors.white,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    TextEditingController textController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('ABC'),
          actions: [
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {},
            ),
          ],
        ),
        body: ChatDetailList(
          provider: provider,
        ),
        bottomNavigationBar: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => VoiceRecordProvider(),
            )
          ],
          child: RecordVoiceRow(),
        )
        // Container(
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Flexible(
        //           child: TextField(
        //         controller: textController,
        //       )),
        //       ElevatedButton(
        //         onPressed: () {
        //           provider.sendMessage(textController.text);
        //         },
        //         child: Text('Send'),
        //       )
        //     ],
        //   ),
        // ),
        );
  }
}

class RecordVoiceRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VoiceRecordProvider provider = Provider.of<VoiceRecordProvider>(context);
    bool ifTap = provider.ifTap;
    return GestureDetector(
      onTapDown: (result) {
        provider.beginRecord();
      },
      onTapCancel: () {
        provider.cancelRecord();
      },
      onTapUp: (result) {
        provider.stopRecord();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        color: ifTap ? Colors.grey[600] : Colors.grey[200],
        child: Center(
          child: Text('Record'),
        ),
      ),
    );
  }
}

enum ChatType {
  text,
  voice,
  image,
  video,
}

class ChatRecord {
  int sender;
  String content;
  String avatarUrl;
  ChatType chatType;
  ChatRecord({this.sender, this.content, this.avatarUrl, this.chatType});
}

class ChatDetailList extends StatelessWidget {
  final SignalRProvider provider;
  ChatDetailList({@required this.provider});

  @override
  Widget build(BuildContext context) {
    String avt1 = 'https://pic4.zhimg.com/da8e974dc_is.jpg';
    String avt2 =
        'https://pic4.zhimg.com/v2-0edac6fcc7bf69f6da105fe63268b84c_is.jpg';
    List<ChatRecord> records = provider.chats;
    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (context, index) {
        switch (records[index].chatType) {
          case ChatType.text:
            return ChatRow(
                sender: records[index].sender,
                content: records[index].content,
                avatarUrl: records[index].avatarUrl);
          case ChatType.voice:
            return null; // TODO: TBD
        }

        return Container();
      },
    );
  }
}

class ChatRow extends StatelessWidget {
  ChatRow(
      {@required this.sender,
      @required this.content,
      @required this.avatarUrl});
  final int sender; // 0 self, 1 other
  final String content;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10 * rpx, vertical: 10 * rpx),
        child: Row(
          mainAxisAlignment:
              sender == 0 ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            sender == 0
                ? CircleAvatar(
                    backgroundImage: NetworkImage(avatarUrl),
                  )
                : Container(),
            sender == 0
                ? Container(
                    child: CustomPaint(
                      painter: ChatBoxPainter(
                          color: Colors.greenAccent,
                          width: 20 * rpx,
                          height: 15 * rpx),
                    ),
                  )
                : Container(),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 590 * rpx),
              child: Container(
                child: Text(
                  content,
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 30 * rpx,
                      letterSpacing: 1.5 * rpx,
                      height: 2 * rpx),
                ),
                margin: EdgeInsets.only(left: 20 * rpx, right: 20 * rpx),
                padding: EdgeInsets.all(15 * rpx),
                decoration: BoxDecoration(
                  color: sender == 0 ? Colors.greenAccent : Colors.white,
                  borderRadius: BorderRadius.circular(10 * rpx),
                ),
              ),
            ),
            sender == 1
                ? Transform.rotate(
                    angle: pi,
                    child: Container(
                      child: CustomPaint(
                        painter: ChatBoxPainter(
                          color: Colors.white,
                          width: 20 * rpx,
                          height: 15 * rpx,
                        ),
                      ),
                    ),
                  )
                : Container(),
            sender == 1
                ? CircleAvatar(
                    backgroundImage: NetworkImage(avatarUrl),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class ChatBoxPainter extends CustomPainter {
  ChatBoxPainter({@required this.width, this.height, this.color});
  final double width;
  final double height;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path()
      ..moveTo(0, height / 2)
      ..lineTo(width, height)
      ..lineTo(width, 0)
      ..lineTo(0, height / 2);

    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ChatBoxPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(ChatBoxPainter oldDelegate) => false;
}
