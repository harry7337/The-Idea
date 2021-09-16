import 'package:bizgram/screen/authenticate/authenticate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bizgram/screen/authenticate/signin.dart';
import 'package:bizgram/screen/wrapper.dart';
import 'package:bizgram/services/auth.dart';
import 'package:bizgram/screen/shared/loading.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class PhoneSignIn extends StatefulWidget {
  final phoneNumber;
  final displayName;
  final email;
  final password;
  PhoneSignIn(
      {Key? key,
      required this.phoneNumber,
      required this.displayName,
      required this.email,
      required this.password})
      : super(key: key);

  @override
  _PhoneSignInState createState() => _PhoneSignInState();
}

class _PhoneSignInState extends State<PhoneSignIn> {
  //final _otpController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _auth = AuthService();

  bool showOTP = false, loading = false;
  String _verificationId = " ";
  late PhoneAuthCredential _phoneAuthCredential;

  String _otp = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _submitPhoneNumber();
  }

  void _handleError(e) {
    print(e.message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${e.message}"),
      ),
    );
    setState(() {
      loading = false;
      _reset();
    });
  }

  Future<void> _phoneLogin() async {
    /// This method is used to login the user
    /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
    try {
      //FirebaseAuth.instance.signInWithPhoneNumber(_phoneController.text);
      //var user = await _auth.signInWithCredential(this._phoneAuthCredential);
      var user = await _auth.registerWithEmailAndPassword(
          widget.email, widget.password);

      if (user == null) {
        setState(() {
          loading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Something went wrong"),
            ),
          );
          print('Something went wrong');
        });
      } else {
        setState(() {
          loading = false;
          print("Signed In");
        });

        await FirebaseAuth.instance.currentUser!
            .updateDisplayName(widget.displayName);
        //await FirebaseAuth.instance.currentUser!.updateEmail(widget.email);
        await FirebaseAuth.instance.currentUser!
            .linkWithPhoneNumber(widget.phoneNumber);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => Wrapper(
        //       showSignUp: false,
        //     ),
        //   ),
        // );
      }
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> _submitPhoneNumber() async {
    /// NOTE: Either append your phone number country code or add in the code itself
    /// Since we are in India we use "+91 " as prefix `phoneNumber`
    // setState(() {
    //   loading = true;
    // });
    //String phoneNumber; = "+91 " + _phoneController.text.toString().trim();
    String phoneNumber = widget.phoneNumber;
    print(phoneNumber);

    /// The below functions are the callbacks, separated so as to make code more readable
    void verificationCompleted(PhoneAuthCredential phoneAuthCredential) {
      print('verificationCompleted');
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Verification Complete"),
          ),
        );
        loading = false;
        this._phoneAuthCredential = phoneAuthCredential;
        print(phoneAuthCredential);
      });
    }

    void verificationFailed(FirebaseAuthException error) {
      print('verificationFailed');
      _handleError(error);
    }

    void codeSent(String verificationId, [int? code]) {
      this._verificationId = verificationId;

      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Code Sent"),
          ),
        );
        showOTP = !showOTP;
        loading = false;
        print("code sent");
      });
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      setState(() {
        loading = false;
      });
      print('codeAutoRetrievalTimeout');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Timed Out, please try again"),
        ),
      );
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      /// Make sure to prefix with your country code
      phoneNumber: phoneNumber,

      /// `seconds` didn't work. The underlying implementation code only reads in `milliseconds`
      timeout: Duration(milliseconds: 120000),

      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
      verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: verificationFailed,

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void _submitOTP() {
    setState(() {
      loading = true;
    });

    /// get the `smsCode` from the user
    String smsCode = _otp;

    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
    this._phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: this._verificationId, smsCode: smsCode);

    Navigator.pop(context);
    //_phoneLogin();
  }

  void _reset() {
    setState(() {
      _phoneNumberController.clear();
      _otp = "";
      showOTP = !showOTP;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Enter the Verification Code",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        loading
            ? Loading()
            : OTPTextField(
                length: 6,
                width: MediaQuery.of(context).size.width,
                fieldWidth: 30,
                style: TextStyle(fontSize: 20),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.underline,
                onCompleted: (pin) {
                  _otp = pin;
                },
              ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: _submitOTP,
          child: Text("Verify"),
        ),
      ],
    );
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: Text('Sign In to Bizgram'),
    //       centerTitle: true,
    //       backgroundColor: Theme.of(context).primaryColor,
    //     ),
    //     body: ListView(
    //       controller: _scrollController,
    //       padding: EdgeInsets.all(16),
    //       children: [
    //         loading
    //             ? Loading()
    //             : showOTP
    //                 ? //Enter OTP
    //                 Column(
    //                     children: [
    //                       TextField(
    //                         controller: _otpController,
    //                         keyboardType: TextInputType.phone,
    //                         decoration: InputDecoration(
    //                           hintText: 'OTP',
    //                           border: OutlineInputBorder(),
    //                         ),
    //                       ),
    //                       MaterialButton(
    //                         onPressed: _submitOTP,
    //                         child: Text('Submit'),
    //                         color: Theme.of(context).accentColor,
    //                       ),
    //                       TextButton(
    //                         onPressed: _reset,
    //                         child: Text('Change Number'),
    //                       ),
    //                     ],
    //                   )
    //                 :
    //                 //Enter Number
    //                 Column(
    //                     children: [
    //                       TextField(
    //                         controller: _phoneController,
    //                         keyboardType: TextInputType.phone,
    //                         decoration: InputDecoration(
    //                           hintText: 'Phone Number',
    //                           prefixText: '+91',
    //                           fillColor: Colors.white,
    //                           filled: true,
    //                           enabledBorder: OutlineInputBorder(
    //                             borderSide: BorderSide(
    //                               color: Colors.white,
    //                               width: 2,
    //                             ),
    //                           ),
    //                           focusedBorder: OutlineInputBorder(
    //                             borderRadius:
    //                                 BorderRadius.vertical(bottom: Radius.zero),
    //                             borderSide: BorderSide(
    //                               color: Colors.teal,
    //                               width: 2,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       MaterialButton(
    //                         onPressed: () =>
    //                             _submitPhoneNumber(_phoneController.text),
    //                         child: Text(
    //                           'Get OTP',
    //                           style: TextStyle(fontFamily: 'Opensans'),
    //                         ),
    //                         textColor: Colors.white,
    //                         color: Colors.teal[300],
    //                       ),
    //                     ],
    //                   ),
    //         Padding(
    //           padding: const EdgeInsets.only(top: 100.0),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //             children: [
    //               ElevatedButton(
    //                   child: Text("Sign up with Email"),
    //                   onPressed: () {
    //                     if (mounted)
    //                       Navigator.pushReplacement(
    //                         context,
    //                         MaterialPageRoute(
    //                           builder: (_) => Authenticate(true),
    //                         ),
    //                       );
    //                   }),
    //               ElevatedButton(
    //                 child: Text("Sign up with Google"),
    //                 onPressed: () => AuthService().signInWithGoogle(),
    //               ),
    //             ],
    //           ),
    //         )
    //       ],
    //     ),
    //   );
    // }
  }
}
