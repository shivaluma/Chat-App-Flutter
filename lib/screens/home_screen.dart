import 'package:chat_app/repository/api_request.dart';
import 'package:chat_app/resources/dialog/ConfirmationDialog.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/widgets/category_selector.dart';
import 'package:chat_app/widgets/conversation_list.dart';
import 'package:chat_app/widgets/favorite_contact.dart';
import 'package:commons/commons.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  // HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {},
        ),
        title: Text(
          'Chats',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {
              ConfirmationDialog.showConfirmation(
                  context, "Do you really want to log out ?", () {}, () {
                ApiRequest.doLogout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              });
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          CategorySelector(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: <Widget>[
                  ConversationList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
