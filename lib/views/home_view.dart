// Import the necessary packages.
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/post.dart';
import '../customClasses/simple_modal_dialog.dart';
import '../main.dart';
import '../customClasses/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

import 'login_view.dart';





// Create a class to represent the HomeView state.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _RegisterViewState();
}
class _RegisterViewState extends State<HomeView> {
  String token = '';
  String emailText = 'Test';
  final String assetName = 'assets/images/bar.svg';
  final Widget svgImage = SvgPicture.asset(
    'assets/images/bar.svg',
    semanticsLabel: 'Bar',
    width: 18,
    height: 18,
  );
@override
void initState() {
  super.initState();
  getToken().then((token) {
    setState(() {
      this.token = token;
      final jwt_secret = dotenv.env['JWT_SECRET'];
      try {
        final decClaimSet = verifyJwtHS256Signature(token.toString(), jwt_secret.toString());
        final userId = decClaimSet['userId'];

        final dio = Dio();
        final response = dio.post(
          'http://localhost:3000/api/v1/users/login/${token.toString()}',
          data: {
            'userId': userId,
          },
          options: Options(
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'x-authorization': token,
            },
          ),
        );

        response.then((value) {
          // Check if the response is successful
          if (value.statusCode == 200) {
            Map<String, dynamic> data = value.data;

            // Use the retrieved values to create a PostToken object
            PostToken postToken = PostToken.fromJson(data);
            setState(() {
              emailText = postToken.email.toString();
            });

            // Now, you can access the email and userId from the PostToken object
            debugPrint('Email: ${postToken.email}, userId: ${postToken.userId}');
          } else {
            _showSimpleModalDialog(context, 'API request failed with status code: ${value.statusCode}');
          }
        });
      } catch (e) {
        debugPrint('Invalid token: $e');
        _showSimpleModalDialog(context, 'Invalid token: $e');
      }
    });
  });
}
  @override
  
Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: (
              Container(
                color: CustomColors.salmon, // Set the background color to custom salmon
                child: 
                 Padding(
                // padding: const EdgeInsets.symmetric(horizontal:36),
                padding: const EdgeInsets.symmetric(horizontal:20),
                child: (
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => {
                        removeToken(),
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          )
                      },
                          
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 12,
                          color: CustomColors.blackCustom, // Text color
                        ),
                      ),
                    ),
                    Text(
                      emailText.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: CustomColors.blackCustom, // Text color
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Add your functionality here
                      },
                      child: svgImage,
                    ),
                  ],
                  )
                )
                ),
              )
                    )
                    )

              ],
            ),
          ),
        ),
      ),
    );
  }
}



_showSimpleModalDialog(BuildContext context, String jsonResponse) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleModalDialog(jsonResponse: jsonResponse);
    },
  );
}

Future<String> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  return token ?? '';
}


void removeToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
}
