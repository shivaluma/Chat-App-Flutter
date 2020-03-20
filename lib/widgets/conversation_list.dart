import 'package:chat_app/models/Conversation.dart';
import 'package:chat_app/widgets/favorite_contact.dart';
import 'package:flutter/material.dart';

class ConversationList extends StatefulWidget {
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
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
          child: ListView.builder(
            itemCount: cvs.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) return FavoriteContact();
              final Conversation conversation = cvs[index - 1];
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
                          backgroundImage: AssetImage('assets/images.jpeg'),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              conversation.other.username,
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
                              width: MediaQuery.of(context).size.width * 0.5,
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
                        Text(conversation.lastTime),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
