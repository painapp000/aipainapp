// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_null_comparison

import 'package:aipainapp/views/register_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/post.dart';
import 'package:flutter/material.dart';
import '../customClasses/password_field.dart';
import '../customClasses/theme.dart';
import '../customClasses/simple_modal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';

import 'home_view.dart';

_showSimpleModalDialog(BuildContext context, String jsonResponse) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleModalDialog(jsonResponse: jsonResponse);
    },
  );
}


final fb = FacebookLogin();
GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'email',
  ],
);

Future<void> handleSignIn() async {
  try {
    await googleSignIn.signIn();
  } catch (error) {
    debugPrint("Error during Google Sign-In: $error");
  }
}

Future<PostSocial> loginSocialDio(BuildContext context, String fullname, String email, String reg_type) async {
  final dio = Dio();
    
  try {
    final response = await dio.post(
      'http://localhost:3000/api/v1/users/login/${reg_type}',
      data: {
        'fullname': fullname,
        'email': email,
        'reg_type': reg_type,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
    );

    if (response.statusCode == 200) {
      final post = PostSocial.fromJson(response.data);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      final String xAuthHeader = response.headers.map['x-authorization'].toString();
      final String token = xAuthHeader.substring(1, xAuthHeader.length - 1);
      await prefs.setString('token', token);
      // await prefs.setString('token', response.headers.map['x-authorization'].toString());
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
        final responseMessage = response.data['message'];
      // ignore: use_build_context_synchronously
      _showSimpleModalDialog(context, responseMessage.toString());
      return post;
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
      final responseMessage = response.data['message'];
      // ignore: use_build_context_synchronously
      _showSimpleModalDialog(context, responseMessage.toString());
      return PostSocial(fullname: fullname, reg_type: reg_type, email: email); // Return empty Post object
    }
  // ignore: deprecated_member_use
  } on DioError catch (e) {
    debugPrint('Dio error: $e');
    // print the error message
   if (e.response != null && e.response!.statusCode == 401) {
    final errorData = e.response!.data;
    final errorMessage = errorData['message'];
    // ignore: use_build_context_synchronously
    _showSimpleModalDialog(context, errorMessage.toString());
    return PostSocial(fullname: fullname, reg_type: reg_type, email: email);
   } else {
      debugPrint('Non-401 error occurred');
      // debugPrint('Dio error: $e');
      final otherError = e.response!.data;
      final errorMessage = otherError['message'];
      debugPrint(errorMessage.toString());
      // ignore: use_build_context_synchronously
    _showSimpleModalDialog(context, errorMessage.toString());
    return PostSocial(fullname: fullname, reg_type: reg_type, email: email); // Return empty Post object
    }
  }
}


//basic login function
Future<Post> loginFnDio(BuildContext context, String email, String passwd) async {
  final dio = Dio();
    
  try {
    final response = await dio.post(
      'http://localhost:3000/api/v1/users/login',
      data: {
        'email': email,
        'passwd': passwd,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
    );

    // debugPrint('Response status code: ${response.statusCode}');
    // debugPrint('Response body: ${response.data}');
    // debugPrint('Response headers: ${response.headers.map['x-authorization']}');

    if (response.statusCode == 200) {
      final post = Post.fromJson(response.data);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      final String xAuthHeader = response.headers.map['x-authorization'].toString();
      final String token = xAuthHeader.substring(1, xAuthHeader.length - 1);
      await prefs.setString('token', token);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
         final responseMessage = response.data['message'];
      // ignore: use_build_context_synchronously
      _showSimpleModalDialog(context, responseMessage.toString());
      return post;
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
      final responseMessage = response.data['message'];
      // ignore: use_build_context_synchronously
      _showSimpleModalDialog(context, responseMessage.toString());
      return Post(email: email, passwd: passwd); // Return empty Post object
    }
  // ignore: deprecated_member_use
  } on DioError catch (e) {
    debugPrint('Dio error: $e');
   if (e.response != null && e.response!.statusCode == 401) {
    final errorData = e.response!.data;
    final errorMessage = errorData['message'];
    // ignore: use_build_context_synchronously
    _showSimpleModalDialog(context, errorMessage.toString());
    return Post(email: email, passwd: passwd);
   } else {
      debugPrint('Non-401 error occurred');
      // ignore: use_build_context_synchronously
    _showSimpleModalDialog(context, e.toString());
    return Post(email: email, passwd: passwd); // Return empty Post object
    }
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});
    @override
    State<LoginView> createState() => _LoginViewState();
  }

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwdController;
  late final TextEditingController _viewPasswdController;


  @override
  void initState() {
    _emailController = TextEditingController();
    _passwdController = TextEditingController();
    _viewPasswdController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwdController.dispose();
    _viewPasswdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteCustom,
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Changed to center
              children: <Widget>[
              const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    color: CustomColors.blackCustom,
                  ),
                ),
                Image.asset(
                  'assets/images/login.png',
                  width: 200,
                  height: 201,
                ),
               
                Padding(
                  padding: const EdgeInsets.only(top: 80.0, left: 40.0, right: 40.0),
                  child: Column(
                  children: <Widget>[
                    TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                              border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                        ),
                      )
                  ]
                  ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0),
                  child: Column(
                    children: <Widget>[
                      PasswordField(controller: _passwdController),
                    ],
                  ),
                  ),
                   Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0),
                    child: Column (         
                    children: <Widget>[
                      
                      Row(
                        
                        children: [
                          const Text('Forgot password?',
                          style: TextStyle(
                          fontSize: 12,
                          color: CustomColors.blackCustom,
                        ),

                      ),
                      TextButton(
                          onPressed: () => debugPrint('Forgot password'),
                          child: const Text(
                            'Click here',
                            style: TextStyle(
                              fontSize: 12,
                              color: CustomColors.blackCustom,
                            ),
                          ),
                   
                        ),
                      
                      ],),
                      ElevatedButton(
                        onPressed: () {
                          final localContext = context; // Store the context locally
                          loginFnDio(localContext, _emailController.text, _passwdController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.salmon,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                          elevation: 4,
                          shadowColor: CustomColors.salmon,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                                 Row(
                        
                        children: [
                          const Text('Don\'t have an account?',
                          style: TextStyle(
                          fontSize: 12,
                          color: CustomColors.blackCustom,
                        ),

                      ),
                      TextButton(
                        onPressed: () => 
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterView()),
                        ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 12,
                              color: CustomColors.blackCustom,
                            ),
                          ),
                   
                        ),
                      
                      ],),
                      const Divider(
                      thickness: 1, // Set line thickness
                      color: Colors.grey, // Set line color
                    ),
                    const Padding(
                      padding:  EdgeInsets.only(top: 20.0),
                    child: 
                    Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 12,
                        color: CustomColors.blackCustom,
                      ),
                    ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                          final res = await fb.logIn(permissions: [
                            FacebookPermission.publicProfile,
                            FacebookPermission.email,
                          ]);     
                          switch (res.status) {
                            case FacebookLoginStatus.success:
                              final localContext = context;
                              final FacebookAccessToken? accessToken = res.accessToken;
                              final profile = await fb.getUserProfile();
                              final email = await fb.getUserEmail();
                              if (email != null && accessToken != null && profile!.name != null) {
                                // ignore: use_build_context_synchronously
                                loginSocialDio(localContext, profile.name!, email, 'facebook');
                              }
                              break;
                            case FacebookLoginStatus.cancel:
                              // ignore: use_build_context_synchronously
                              _showSimpleModalDialog(context, "User cancelled login");
                              break;
                            case FacebookLoginStatus.error:
                              // return error
                              final error = res.error;
                              // ignore: use_build_context_synchronously
                              _showSimpleModalDialog(context, error.toString());
                              break;
                          }               
                          },
                          child: Image.asset(
                            'assets/images/facebook.png',
                            width: 52,
                            height: 52,
                          ),
                        ),
                        GestureDetector(
                          
                          onTap: () async {
                                try {
                                    if (Platform.isAndroid ) {
                                      googleSignIn = GoogleSignIn(
                                        scopes: [
                                          'email',
                                          
                                        ],
                                      );
                                    }
                                    if (Platform.isIOS || Platform.isMacOS) {
                                    googleSignIn = GoogleSignIn(
                                      clientId:
                                          "696034599107-en0egrdm10fq49cscrphmjcrgakb6e07.apps.googleusercontent.com",
                                      scopes: [
                                        'email',
                                        
                                      ],
                                    );
                                  }
                                    final GoogleSignInAccount? googleAccount = await googleSignIn.signIn();
                                    final GoogleSignInAuthentication googleAuth = await googleAccount!.authentication;
                                    final localContext = context; // Store the context locally
                                    if (googleAccount != null && googleAuth.accessToken != null && googleAccount.email != null && googleAccount.displayName != null) {
                                      final email = googleAccount.email;
                                      final displayName = googleAccount.displayName;
                                      // ignore: use_build_context_synchronously
                                      loginSocialDio(localContext, displayName!, email, 'google');
                            }            
                          } catch (error) {
                            // ignore: use_build_context_synchronously
                            _showSimpleModalDialog(context, error.toString());
                          }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Image.asset(
                              'assets/images/google.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        ],
                      ),
                      )
                    ],
                    )
                  
                  ),
                  
                  
              ],
            ),
          ),
      ),
      ),
    );
  }
}

