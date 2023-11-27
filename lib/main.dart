import 'package:aipainapp/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'customClasses/theme.dart';
import 'views/login_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  debugPrint(token.toString());
 

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  
  const HomePage({super.key});
    @override
    State<HomePage> createState() => _HomePageState();
    
  }

class _HomePageState extends State<HomePage> {
  int _counter = 0;

void _isLoggedIn() {
  setState(() {
  _counter++;
});
}



@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.salmon,
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 30,
                    color: CustomColors.blackCustom,
                  ),
                ),
                Image.asset(
                  'assets/images/imgwelcome.png',
                  width: 200,
                  height: 201,
                ),
                const Padding(padding: EdgeInsets.only(top: 40.0)),
                const Text(
                  'AI pain detector',
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors.blackCustom,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0),
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => 
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginView()),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.gray,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, left: 40.0, right: 40.0),
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => 
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterView()),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.gray,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
