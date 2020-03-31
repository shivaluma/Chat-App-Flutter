import 'package:chat_app/models/Message.dart';
import 'package:chat_app/models/MessageResponse.dart';
import 'package:chat_app/models/User.dart';
import 'package:chat_app/repository/api_request.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatScreen extends StatefulWidget {
  final String cvsId;
  final String other;
  final String myUsername;
  ChatScreen({this.cvsId, this.other, this.myUsername});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Future<MessageResponse> _msgResponse;
  ScrollController _scrollController = new ScrollController();
  TextEditingController _editingController = new TextEditingController();
  List<Message> snapshotRef;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String myId;
  @override
  void initState() {
    super.initState();

    _msgResponse = ApiRequest.getMessages(widget.cvsId);
    getId();
  }

  void getId() async {
    myId = await ApiRequest.getMyId();
  }

  _buildMessageComposer(List<Message> listMsg) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.black12),
        ),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                controller: _editingController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textCapitalization: TextCapitalization.none,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Aa',
                    contentPadding: const EdgeInsets.all(8.0)),
              ),
            ),
          ),
          MaterialButton(
            minWidth: 40,
            height: 60,
            focusColor: Colors.black87,
            child: Icon(
              Icons.send,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () async {
              Message newMessage = await ApiRequest.sendMessage(
                  widget.cvsId, _editingController.text);
              if (newMessage != null) {
                _editingController.text = "";
                this.setState(() {
                  _msgResponse.then((res) {
                    res.listMsg.insert(0, newMessage);
                  });
                });
              }
            },
          )
        ],
      ),
    );
  }

  _buildMessage(Message msg, bool prevMsg, bool nextMsg) {
    bool isMe = (myId == msg.ofUser);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        // isMe
        //     ? Padding(
        //         padding: const EdgeInsets.only(right: 10.0, bottom: 8.0),
        //         child: Text(
        //           msg.time,
        //           style: TextStyle(
        //             fontSize: 10.0,
        //           ),
        //         ),
        //       )
        //     : SizedBox.shrink(),
        Container(
          constraints: BoxConstraints(minWidth: 50, maxWidth: 300),
          margin: isMe
              ? EdgeInsets.only(
                  top: nextMsg ? 2 : 8, bottom: prevMsg ? 2 : 8, right: 10)
              : EdgeInsets.only(
                  top: nextMsg ? 2 : 8, bottom: prevMsg ? 2 : 8, left: 10),
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                msg.content,
                style: isMe
                    ? TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 17)
                    : TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 17),
              ),
              Text(
                msg.time,
                style: TextStyle(
                  color: isMe ? Colors.white70 : Colors.black87,
                  fontSize: 10.0,
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: isMe ? null : Colors.grey[200],
            gradient: isMe
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue[500], Theme.of(context).primaryColor])
                : null,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0),
                    topRight:
                        nextMsg ? Radius.circular(3.0) : Radius.circular(15.0),
                    bottomRight:
                        prevMsg ? Radius.circular(3.0) : Radius.circular(15.0),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                    topLeft:
                        nextMsg ? Radius.circular(3.0) : Radius.circular(15.0),
                    bottomLeft:
                        prevMsg ? Radius.circular(3.0) : Radius.circular(15.0),
                  ),
          ),
        ),
        // !isMe
        //     ? Padding(
        //         padding: const EdgeInsets.only(left: 10.0, bottom: 8.0),
        //         child: Text(
        //           msg.time,
        //           style: TextStyle(
        //             fontSize: 10.0,
        //           ),
        //         ),
        //       )
        //     : SizedBox.shrink()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
        title: Text(
          widget.other,
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: FutureBuilder<MessageResponse>(
                  future: _msgResponse,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState != ConnectionState.none) {
                      snapshotRef = snapshot.data.listMsg;
                      return SmartRefresher(
                        controller: _refreshController,
                        enablePullDown: false,
                        enablePullUp: true,
                        onRefresh: () {},
                        onLoading: () async {
                          if (snapshot.data.newLast == 0)
                            _refreshController.loadNoData();
                          MessageResponse _newMsgResponse;
                          _newMsgResponse = await ApiRequest.getMessages(
                              widget.cvsId, snapshot.data.newLast);
                          print(_newMsgResponse.newLast);
                          this.setState(() {
                            snapshot.data.listMsg
                                .addAll(_newMsgResponse.listMsg);
                            snapshot.data.newLast = _newMsgResponse.newLast;
                          });
                          _refreshController.loadComplete();
                        },
                        header: WaterDropHeader(),
                        footer: CustomFooter(
                          builder: (BuildContext context, LoadStatus mode) {
                            Widget body;
                            if (mode == LoadStatus.idle) {
                              body = SizedBox.shrink();
                            } else if (mode == LoadStatus.loading) {
                              body = CircularProgressIndicator();
                            } else if (mode == LoadStatus.failed) {
                              body = Text("Load Failed!Click retry!");
                            } else if (mode == LoadStatus.canLoading) {
                              body = Text("release to load more");
                            } else {
                              body = Text("No more Data");
                            }
                            return Container(
                              height: 55.0,
                              child: Center(child: body),
                            );
                          },
                        ),
                        child: ListView.builder(
                          reverse: true,
                          controller: _scrollController,
                          padding: EdgeInsets.only(top: 15.0),
                          itemCount: snapshot.data.listMsg.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Message msg = snapshot.data.listMsg[index];
                            bool prevMsg = false;
                            bool nextMsg = false;
                            if (index > 0 &&
                                msg.ofUser ==
                                    snapshot.data.listMsg[index - 1].ofUser)
                              prevMsg = true;

                            if (index < snapshot.data.listMsg.length - 1 &&
                                msg.ofUser ==
                                    snapshot.data.listMsg[index + 1].ofUser)
                              nextMsg = true;

                            return _buildMessage(msg, prevMsg, nextMsg);
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("Error");
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
            _buildMessageComposer(snapshotRef)
          ],
        ),
      ),
    );
  }
}
