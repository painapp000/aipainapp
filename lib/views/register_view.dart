import 'package:shared_preferences/shared_preferences.dart';
import '../api/post.dart';
import 'package:flutter/material.dart';
import '../customClasses/password_field.dart';
import '../customClasses/theme.dart';
import '../customClasses/simple_modal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

import 'home_view.dart';
import 'login_view.dart';

final fb = FacebookLogin();

_showSimpleModalDialog(BuildContext context, String jsonResponse) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleModalDialog(jsonResponse: jsonResponse);
    },
  );
}


// ignore: non_constant_identifier_names
Future<PostReg> registerFnDio(BuildContext context, String fullname, String mob_phone, String email, String passwd) async {
  final dio = Dio();
    
  try {
    final response = await dio.post(
      'http://localhost:3000/api/v1/users/register',
      data: {
        'fullname': fullname,
        'mob_phone': mob_phone,
        'email': email,
        'passwd': passwd,

      },
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
    );

    debugPrint('Response status code: ${response.statusCode}');
    debugPrint('Response body: ${response.data}');
    debugPrint('Response headers: ${response.headers.map['x-authorization']}');

    if (response.statusCode == 200) {
      final post = PostReg.fromJson(response.data);
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
      return PostReg(fullname: fullname, mob_phone: mob_phone, email: email, passwd: passwd); 
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
      return PostReg(fullname: fullname, mob_phone: mob_phone, email: email, passwd: passwd); 
   } else {
      debugPrint('Non-401 error occurred');
      // debugPrint('Dio error: $e');
      final otherError = e.response!.data;
      final errorMessage = otherError['message'];
      debugPrint(errorMessage.toString());
      // ignore: use_build_context_synchronously
    _showSimpleModalDialog(context, errorMessage.toString());
      return PostReg(fullname: fullname, mob_phone: mob_phone, email: email, passwd: passwd); 
    }
  }
}


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
    @override
    State<RegisterView> createState() => _RegisterViewState();
  }

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _fullnameController;
  late final TextEditingController _mobilephoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwdController;

  @override
  void initState() {
    _fullnameController = TextEditingController();
    _mobilephoneController = TextEditingController();
    _emailController = TextEditingController();
    _passwdController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _mobilephoneController.dispose();
    _emailController.dispose();
    _passwdController.dispose();
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
              const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 30,
                    color: CustomColors.blackCustom,
                  ),
                ),
                Image.asset(
                  'assets/images/register.png',
                  width: 200,
                  height: 201,
                ),
               
                Padding(
                  padding: const EdgeInsets.only(top: 80.0, left: 40.0, right: 40.0),
                  child: Column(
                  children: <Widget>[
                    TextField(
                        controller: _fullnameController,
                        decoration: const InputDecoration(
                          hintText: 'Full Name',
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
                      TextField(
                        controller: _mobilephoneController,
                        decoration: const InputDecoration(
                          hintText: 'Mobile Phone',
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
                          const Text('Already have an account?',
                          style: TextStyle(
                          fontSize: 12,
                          color: CustomColors.blackCustom,
                        ),

                      ),
                      TextButton(
                          onPressed: () => 
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginView()),
                          ),
                          child: const Text(
                            'Log In',
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
                          registerFnDio(localContext, _fullnameController.text, _mobilephoneController.text, _emailController.text, _passwdController.text);
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
                            'Register',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
              
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

