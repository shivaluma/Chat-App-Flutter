import 'package:chat_app/models/Conversation.dart';
import 'package:chat_app/repository/api_request.dart';
import 'package:chat_app/widgets/favorite_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ConversationList extends StatefulWidget {
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  Future<List<Conversation>> _conversations;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String myUsername;
  @override
  void initState() {
    super.initState();
    _conversations = ApiRequest.getConversation();
    getUsername();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    _refreshController.loadComplete();
  }

  void getUsername() async {
    myUsername = await ApiRequest.getMyUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            header: WaterDropHeader(),
            child: FutureBuilder(
              future: _conversations,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState != ConnectionState.none) {
                  return ListView.builder(
                    itemCount: snapshot.data.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) return FavoriteContact();
                      final Conversation conversation =
                          snapshot.data[index - 1];
                      return Container(
                        margin: EdgeInsets.only(
                          top: 5.0,
                          bottom: 0.0,
                          right: 20,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 35.0,
                                  backgroundImage:
                                      AssetImage('assets/images.jpeg'),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      myUsername == conversation.firstUserName
                                          ? conversation.secondUserName
                                          : conversation.firstUserName,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 9.0,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 2.0),
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        conversation.lastMessage,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                    ),
                                    child: Text(
                                      conversation.lastUpdate,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("Error");
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}
