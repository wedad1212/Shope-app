
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/colors.dart';
import 'package:shop/widgets/textFormFieldStyle.dart';

import '../model/exception.dart';
import '../providers/auth.dart';



class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final sizeDevice = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            width: sizeDevice.width,
            height: sizeDevice.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                blueColor,
                darkWhiteColor,
                lightBlueColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
          ),
          SingleChildScrollView(
            child: SizedBox(
              width: sizeDevice.width,
              height: sizeDevice.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: Container(
                    transform: Matrix4.rotationZ(-8 * pi / 180)
                      ..translate(-10.0),
                    decoration: BoxDecoration(
                        color: blueColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(1, 3),
                          )
                        ]),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 20),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: const Text(
                   " Shop",
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'Anton',
                          color: Colors.white),
                    ),
                  )),
                  Flexible(
                      flex: sizeDevice.width > 600 ? 2 : 1,

                          child: AuthCard())
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {




  @override
  State<AuthCard> createState() => _AuthCardState();
}
enum AuthMode { login, singUp }
class _AuthCardState extends State<AuthCard>

    with SingleTickerProviderStateMixin {
  AuthMode authMode = AuthMode.login;
  final GlobalKey<FormState> _globalKey = GlobalKey();
  Map<String, String> mapData = {
    'email': '',
    'password': '',

  };

  var isLoading = false;
  final _passwordController = TextEditingController();


  AnimationController? _controller;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(
            begin: const Offset(0, -0.15),  end: const Offset(0, 0),)
        .animate(
            CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller!, curve: Curves.easeIn));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _controller!.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return
       Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        child: AnimatedContainer(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(20),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
          height: authMode == AuthMode.singUp ? 400 : 320,
          child: Form(
            key: _globalKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormFieldStyle(
                      hintText: 'Enter your email',
                      textInputType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val!.isEmpty && !val.contains('@')) {
                          return 'Invalid Email';
                        }
                        return null;
                      },
                      onsaved: (val) {
                        mapData['email'] = val!;
                      },
                      icon: Icons.email),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormFieldStyle(
                      obscureText: true,
                      controller: _passwordController,
                      hintText: 'Enter your password',
                      textInputType: TextInputType.visiblePassword,
                      validator: (val) {
                        if (val!.isEmpty && val.length > 6) {
                          return 'Enter password longest';
                        }
                        return null;
                      },
                      onsaved: (val) {
                        mapData['password'] = val!;
                      },
                      icon: Icons.visibility),
                authMode==AuthMode.singUp?
                  const SizedBox(
                    height: 20,
                  ):Container(),
                  AnimatedContainer(


                    constraints: BoxConstraints(
                      minHeight: authMode == AuthMode.singUp ? 60 : 0,
                      maxHeight: authMode == AuthMode.singUp ? 120 : 0,
                    ),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    child: FadeTransition(
                      opacity: _opacityAnimation!,
                      child: SlideTransition(
                        position: _slideAnimation!,
                        child: Visibility(
                          visible: authMode==AuthMode.singUp,

                          child: TextFormFieldStyle(
                            obscureText: true,

                            enabled: authMode == AuthMode.singUp,
                            hintText: 'Enter your confirm password',
                            textInputType: TextInputType.visiblePassword,
                            icon: Icons.visibility,
                            validator: (val) {
                              if (val != _passwordController.text) {
                                return 'The password is incorrect';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  isLoading
                      ? CircularProgressIndicator(
                          color: blueColor,
                        )
                      : Column(
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(blueColor),
                                elevation: MaterialStateProperty.all(8),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.all(15)),
                                fixedSize:
                                    MaterialStateProperty.all(const Size(300, 50)),
                              ),
                              onPressed: _submit,
                              child: Text(
                                authMode == AuthMode.login
                                    ?
                                     'Login':'SingUp',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextButton(
                              onPressed: _switchAuthMode,
                              child: Text(
                                "${authMode == AuthMode.login ? 'Login' : 'SingUp'} Instead",
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    fontFamily: 'Anton'),
                              ),
                            )
                          ],
                        )
                ],
              ),
            ),
          ),
        ),

    );
  }

  _switchAuthMode() {
    if (authMode == AuthMode.login) {
      setState(() {
        authMode = AuthMode.singUp;
      });
      _controller!.forward();
    } else {
      setState(() {
        authMode = AuthMode.login;
      });
      _controller!.reverse();
    }
  }
  _submit() async {

    if(!_globalKey.currentState!.validate()){
      return;
    }
    FocusScope.of(context).unfocus();
    _globalKey.currentState!.save();

    setState(() {
      isLoading=true;
    });
    try {
      if (authMode == AuthMode.login) {
        await Provider.of<Auth>(context,listen: false).login(
            mapData['email']!, mapData['password']!);
      }
      else {
        await Provider.of<Auth>(context,listen: false).signUp(
            mapData['email']!, mapData['password']!);
      }
    } on HttpException catch(e) {

var errorMessage='Authentication failed';
if(e.toString().contains('EMAIL_EXISTS')){
  errorMessage='This email address is already';
}
else if(e.toString().contains('INVALID_EMAIL')){
  errorMessage='This not a valid email address';
}
else if(e.toString().contains('WEAK_PASSWORD')){
  errorMessage='This password is too weak';
}
else if(e.toString().contains('EMAIL_NOT_FOUND')){
  errorMessage='could not find a user with that email';
}
else if(e.toString().contains('INVALID_PASSWORD')){
  errorMessage='Invalid password';
}
_showErrorDialog(errorMessage);
    }catch(error){
      const message='could not authentication you,please aging later';
      _showErrorDialog(message);
    }
    setState(() {
      isLoading=false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(context: context, builder: (ctx)=>AlertDialog(
      title: Text('An Error Occurred!'),
      content: Text(message),
      actions: [
      TextButton(onPressed: Navigator.of(ctx).pop,child: Text("OK"),
    ),
    ]
    ));
  }
}
