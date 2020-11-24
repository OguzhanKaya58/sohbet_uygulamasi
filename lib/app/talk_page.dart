import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'file:///D:/Source/Flatter%20Uygulamalar/sohbet_uygulamasi/lib/advertisement/advertisement.dart';
import 'package:sohbet_uygulamasi/common_widget/platform_sensitive_alert_dialog.dart';
import 'package:sohbet_uygulamasi/model/message.dart';
import 'package:sohbet_uygulamasi/viewmodel/chat_view_model.dart';

class TalkPage extends StatefulWidget {
  @override
  _TalkPageState createState() => _TalkPageState();
}

class _TalkPageState extends State<TalkPage> {
  var _messageController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  bool _isLoading = false;
  InterstitialAd myInterstitialAd;

  @override
  void initState() {
    super.initState();
    //Geçişli reklam kullanımı...
    _scrollController.addListener(_scrollListener);
    if (Advertisement.amount % 5 == 2) {
      myInterstitialAd = Advertisement.buildInterstitial();
      myInterstitialAd
        ..load()
        ..show();
    }
    Advertisement.amount++;
  }

  @override
  void dispose() {
    if (myInterstitialAd != null) myInterstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _chatModel = Provider.of<ChatViewModel>(context);

    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text(_chatModel.talkUser.userName),
          actions: [
            Center(
              widthFactor: 2,
              child: GestureDetector(
                onTap: () => PlatformSensitiveAlertDialog(
                        head: _chatModel.talkUser.userName,
                        content: _chatModel.talkUser.email,
                        mainButtonName: "tamam")
                    .show(context),
                child: CircleAvatar(
                  backgroundColor: Colors.grey.withAlpha(40),
                  backgroundImage: NetworkImage(_chatModel.talkUser.profileUrl),
                ),
              ),
            ),
          ],
        ),
        body: _chatModel.state == ChatViewState.Busy
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Column(
                  children: [
                    _buildMessageList(),
                    _buildNewMessage(),
                  ],
                ),
              ));
  }

  Widget _buildMessageList() {
    return Consumer<ChatViewModel>(
      builder: (context, chatModel, child) {
        return Expanded(
          child: ListView.builder(
            reverse: true,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (chatModel.hasMoreLoading == true &&
                  chatModel.allMessageList.length == index) {
                return _loadingNewUsersForIndicator();
              } else
                return _createTalkBalloon(chatModel.allMessageList[index]);
            },
            itemCount: chatModel.hasMoreLoading
                ? chatModel.allMessageList.length + 1
                : chatModel.allMessageList.length,
          ),
        );
      },
    );
  }

  Widget _buildNewMessage() {
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Container(
      padding: EdgeInsets.only(bottom: 8, left: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              cursorColor: Colors.blue,
              style: new TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                fillColor: Colors.black26,
                filled: true,
                hintText: "Mesaj",
                border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(30),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: FloatingActionButton(
              onPressed: () async {
                if (_messageController.text.trim().length > 0) {
                  MessageModel _saveMessage = MessageModel(
                    fromWho: _chatModel.currentUser.userID,
                    toFrom: _chatModel.talkUser.userID,
                    fromMe: true,
                    message: _messageController.text,
                    //speakerPerson: _chatModel.currentUser.userID,
                  );
                  var result = await _chatModel.saveMessage(
                      _saveMessage, _chatModel.currentUser);
                  if (result) {
                    _messageController.clear();
                    _scrollController.animateTo(0,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeOut);
                  }
                }
              },
              elevation: 0,
              backgroundColor: Colors.black26,
              child: Icon(
                Icons.navigation,
                size: 35,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createTalkBalloon(MessageModel currentMessage) {
    Color _comingMessageColor = Colors.teal;
    Color _sentMessageColor = Colors.orange;
    //final _chatModel = Provider.of<ChatViewModel>(context);
    var hourMinuteValue = "";
    try {
      hourMinuteValue = _hourMinuteShow(currentMessage.date ?? Timestamp(1, 1));
    } catch (error) {
      print("hata : $error");
    }
    var _myMessage = currentMessage.fromMe;
    if (_myMessage) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _sentMessageColor,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      currentMessage.message,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(hourMinuteValue),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                /*  CircleAvatar(
                  backgroundImage: NetworkImage(widget.talkUser.profileUrl),
                ),
                SizedBox(width: 5,),*/
                Flexible(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: _comingMessageColor,
                        ),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(4),
                        child: Text(
                          currentMessage.message,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(hourMinuteValue),
              ],
            ),
          ],
        ),
      );
    }
  }

  String _hourMinuteShow(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formatterDate = _formatter.format(date.toDate());
    return _formatterDate;
  }

  Future<void> bringGetMoreMessages() async {
    final _chatModel = Provider.of<ChatViewModel>(context, listen: false);
    if (_isLoading == false) {
      _isLoading = true;

      await _chatModel.bringGetMoreMessages();
      _isLoading = false;
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      bringGetMoreMessages();
    }
  }

  _loadingNewUsersForIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
