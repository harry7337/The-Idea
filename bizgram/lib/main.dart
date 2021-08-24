import 'package:bizgram/screen/authenticate/signin.dart';
import 'package:flutter/material.dart' ;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants/UIconstants.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override 
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'bizgram',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color primary= Color.fromRGBO(245, 245, 220, 20);
  Color secondary = Color.fromRGBO(255, 218, 185, 20);
  Color logo = Color.fromRGBO(128,117,90,60);
  @override
  

  Widget build(BuildContext context) {
    return new Scaffold(
         body: Container(
           height: UIConstants.fitToHeight(640, context),
          width: UIConstants.fitToWidth(360, context),
           padding: EdgeInsets.symmetric(horizontal: 20),
           child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //We take the image from the assets
                    Image.asset(
                      'images/img1.png',
                      height: UIConstants.fitToHeight(240, context),
                      width: UIConstants.fitToWidth(300, context),
                    ),
                    SizedBox(
                      height: UIConstants.fitToHeight(20, context),
                    ),
                    //Texts and Styling of them
                    Text(
                      'Welcome!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 28),
                    ),
                    SizedBox(height: UIConstants.fitToHeight(20, context)),
                    Text(
                      'There is always a start!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(
                      height: UIConstants.fitToHeight(20, context),
                    ),
                    //Our MaterialButton which when pressed will take us to a new screen named as 
                    //LoginScreen
                    MaterialButton(
                      elevation: 0,
                      height: UIConstants.fitToHeight(50, context),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => LoginScreen()));
                      },
                      color: logo,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Get Started',
                              style: TextStyle(color: Colors.white, fontSize: 20)),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                      textColor: Colors.white,
                    )
                  ],
                ),
         ),
      
    );
      
  }
}
