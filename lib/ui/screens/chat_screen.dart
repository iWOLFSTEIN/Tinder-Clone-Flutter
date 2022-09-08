import 'package:flutter/material.dart';
import 'package:tinder_app_flutter/data/db/entity/app_user.dart';
import 'package:tinder_app_flutter/data/db/entity/chat.dart';
import 'package:tinder_app_flutter/data/db/entity/message.dart';
import 'package:tinder_app_flutter/data/db/remote/firebase_database_source.dart';
import 'package:tinder_app_flutter/ui/screens/start_screen.dart';
import 'package:tinder_app_flutter/ui/widgets/chat_top_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tinder_app_flutter/ui/widgets/message_bubble.dart';
import 'package:tinder_app_flutter/util/constants.dart';

class ChatScreen extends StatelessWidget {
  final ScrollController _scrollController = new ScrollController();
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();
  final messageTextController = TextEditingController();

  static const String id = 'chat_screen';

  final String? chatId;
  final String? myUserId;
  final String? otherUserId;

  ChatScreen(
      {required this.chatId,
      required this.myUserId,
      required this.otherUserId});

  void checkAndUpdateLastMessageSeen(
      Message lastMessage, String messageId, String? myUserId) {
    if (lastMessage.seen == false && lastMessage.senderId != myUserId) {
      lastMessage.seen = true;
      Chat updatedChat = Chat(chatId, lastMessage);

      _databaseSource.updateChat(updatedChat);
      _databaseSource.updateMessage(chatId, messageId, lastMessage);
    }
  }

  bool shouldShowTime(Message currMessage, Message messageBefore) {
    int halfHourInMilli = 1800000;

    if ((messageBefore.epochTimeMs! - currMessage.epochTimeMs!).abs() >
        halfHourInMilli) {
      return true;
    }
    return messageBefore == null;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            shadowColor: kSecondaryColor,
            backgroundColor: kSecondaryColor,
            title: StreamBuilder<DocumentSnapshot>(
                stream: _databaseSource.observeUser(otherUserId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return ChatTopBar(user: AppUser.fromSnapshot(snapshot.data!));
                })),
        body: Column(children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _databaseSource.observeMessages(chatId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    List<Message> messages = [];
                    snapshot.data!.docs.forEach((element) {
                      messages.add(Message.fromSnapshot(element));
                    });
                    if (snapshot.data!.docs.length > 0) {
                      checkAndUpdateLastMessageSeen(
                          messages.first, snapshot.data!.docs[0].id, myUserId);
                    }
                    if (_scrollController.hasClients)
                      _scrollController.jumpTo(0.0);

                    List<bool?> showTimeList = new List<bool?>.filled(
                        messages.length, null,
                        growable: false);

                    for (int i = messages.length - 1; i >= 0; i--) {
                      bool shouldShow = i == (messages.length - 1)
                          ? true
                          : shouldShowTime(messages[i], messages[i + 1]);
                      showTimeList[i] = shouldShow;
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final item = messages[index];
                        return ListTile(
                          title: MessageBubble(
                              epochTimeMs: item.epochTimeMs,
                              text: item.text,
                              isSenderMyUser:
                                  messages[index].senderId == myUserId,
                              includeTime: showTimeList[index]),
                        );
                      },
                    );
                  })),
          getBottomContainer(context, myUserId, size)
        ]));
  }

  void sendMessage(String? myUserId) {
    if (messageTextController.text.isEmpty) return;

    Message message = Message(DateTime.now().millisecondsSinceEpoch, false,
        myUserId, messageTextController.text);
    Chat updatedChat = Chat(chatId, message);
    _databaseSource.addMessage(chatId, message);
    _databaseSource.updateChat(updatedChat);
    messageTextController.clear();
  }

  Widget getBottomContainer(BuildContext context, String? myUserId, size) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1.0,
            color: kSecondaryColor.withOpacity(0.5),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: TextField(
                controller: messageTextController,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(color: kSecondaryColor),
                decoration: InputDecoration(
                    labelText: 'Message',
                    labelStyle:
                        TextStyle(color: kSecondaryColor.withOpacity(0.5)),
                    contentPadding: EdgeInsets.all(0)),
              ),
            ),
            CustomButton(
                color: kSecondaryColor,
                textColor: kPrimaryColor,
                buttonName: 'SEND',
                width: size.width * 0.27,
                height: size.height * 0.05,
                function: () {
                  sendMessage(myUserId);
                })
          ],
        ),
      ),
    );
  }
}
