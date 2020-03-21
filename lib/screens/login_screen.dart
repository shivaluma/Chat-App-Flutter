import 'package:chat_app/blocs/login_bloc.dart';
import 'package:chat_app/repository/api_request.dart';
import 'package:chat_app/resources/dialog/LoadingDialog.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  LoginBloc bloc = new LoginBloc();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  bool _loginError = false;
  void _toggleObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleLoginError() {
    setState(() {
      _loginError = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    width: double.infinity,
                    height: 160.0,
                    child: FittedBox(
                      child: Image.asset("assets/logo.jpg"),
                      fit: BoxFit.cover,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Text(
                  'Hello\nWelcome back ^^',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 27.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
                  child: StreamBuilder<Object>(
                      stream: bloc.usernameStream,
                      builder: (context, snapshot) {
                        return TextField(
                          controller: _usernameController,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            errorText:
                                snapshot.hasError ? snapshot.error : null,
                            prefixIcon: Icon(
                              Icons.person,
                              size: 16,
                            ),
                            labelText: 'USERNAME',
                            labelStyle: TextStyle(
                              color: Color(0xff888888),
                              fontSize: 15.0,
                            ),
                          ),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: <Widget>[
                      StreamBuilder<Object>(
                          stream: bloc.passwordStream,
                          builder: (context, snapshot) {
                            return TextField(
                              controller: _passwordController,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                errorText:
                                    snapshot.hasError ? snapshot.error : null,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  size: 16,
                                ),
                                labelText: 'PASSWORD',
                                labelStyle: TextStyle(
                                  color: Color(0xff888888),
                                  fontSize: 15.0,
                                ),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                            );
                          }),
                      GestureDetector(
                        onTap: () {
                          print('asd');
                          _toggleObscure();
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          margin: EdgeInsets.only(top: 13.0),
                          child: Text(
                            _obscureText ? 'SHOW' : 'HIDE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _loginError ? 'Wrong username or password' : "",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: RaisedButton(
                      onPressed: _onSignInButtonClicked,
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6.0),
                        ),
                      ),
                      child: Text(
                        "SIGN IN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()),
                        );
                      },
                      child: Text(
                        "New user? SIGN UP HERE!",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSignInButtonClicked() async {
    if (bloc.isValidInfo(_usernameController.text, _passwordController.text)) {
      LoadingDialog.showLoadingDialog(context, "Please wait...");
      bloc.doLogin(_usernameController.text, _passwordController.text, () {
        LoadingDialog.hideLoadingDialog(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }, () {
        _toggleLoginError();
        LoadingDialog.hideLoadingDialog(context);
        //onfailure
      });
    }
  }
}
