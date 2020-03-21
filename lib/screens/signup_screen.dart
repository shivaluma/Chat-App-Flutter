import 'package:chat_app/blocs/register_bloc.dart';
import 'package:chat_app/resources/dialog/LoadingDialog.dart';
import 'package:chat_app/resources/dialog/SuccessDialog.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  RegisterBloc bloc = new RegisterBloc();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _passwordAgainController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
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
                'Hello\nWelcome joining ^^',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 27.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
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
                          errorText: snapshot.hasError ? snapshot.error : null,
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
                padding: const EdgeInsets.only(bottom: 10.0),
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
                            obscureText: true,
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
                    Container(
                      margin: EdgeInsets.only(top: 13.0),
                      child: Text(
                        'SHOW',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    StreamBuilder<Object>(
                        stream: bloc.passwordAgainStream,
                        builder: (context, snapshot) {
                          return TextField(
                            controller: _passwordAgainController,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                            obscureText: true,
                            decoration: InputDecoration(
                              errorText:
                                  snapshot.hasError ? snapshot.error : null,
                              prefixIcon: Icon(
                                Icons.lock,
                                size: 16,
                              ),
                              labelText: 'CONFIRM PASSWORD',
                              labelStyle: TextStyle(
                                color: Color(0xff888888),
                                fontSize: 15.0,
                              ),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                          );
                        }),
                    Container(
                      margin: EdgeInsets.only(top: 13.0),
                      child: Text(
                        'SHOW',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: RaisedButton(
                    onPressed: _onSignUpButtonClicked,
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                    ),
                    child: Text(
                      "SIGN UP",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSignUpButtonClicked() async {
    if (bloc.isValidInfo(_usernameController.text, _passwordController.text,
        _passwordAgainController.text)) {
      LoadingDialog.showLoadingDialog(context, "Please wait...");
      bloc.doRegister(_usernameController.text, _passwordController.text,
          _passwordAgainController.text, () {
        LoadingDialog.hideLoadingDialog(context);
        SuccessDialog.showSuccessDialog(context, "Register Successfully.", () {
          Navigator.of(context).pop();
        });
      }, () {
        LoadingDialog.hideLoadingDialog(context);
      });
    }
  }
}
