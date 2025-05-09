import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test1/pages/home.dart';
import 'package:test1/custom.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Size mediaSize;
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  late TextEditingController userNameController = TextEditingController();
  late TextEditingController confirmPasswordController = TextEditingController();
  bool rememberUser = false;
  bool isSignin = false;
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.orange,
                Colors.orangeAccent,
                Colors.purpleAccent,
                Colors.purple,
              ],
            )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(top: 32, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock,
            size: 100,
            color: Colors.black,
          ),
          Text(
            "LOCKS&GO",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 40,
              letterSpacing: 2,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      height: mediaSize.height * 0.732,
      child: Card(
        color: Colors.white.withAlpha(90),
        margin: EdgeInsets.all(0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: isSignin ? _buildSigninForm() : _buildLoginForm(),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        buildGreyText("Please log in with your credentials"),
        const SizedBox(height: 50),
        buildGreyText("Email or username"),
        _buildInputField(emailController, isPassword: false),
        const SizedBox(height: 30),
        buildGreyText("Password"),
        _buildInputField(passwordController, isPassword: true),
        const SizedBox(height: 10),
        _buildRememberForgot(),
        const SizedBox(height: 10),
        _buildLoginButton(),
        _buildSigninButton(),
      ],
    );
  }

  Widget _buildInputField(TextEditingController controller,
      {isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isPassword ? _buildHideButton() : Icon(Icons.done),
      ),
      obscureText: isPassword ? isHidden : false,
    );
  }

  Widget _buildHideButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isHidden = !isHidden;  // Toggle the password visibility
        });
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        minimumSize: const Size(40, 40), // Adjust size as needed
      ),
      child: Icon(
        isHidden ? Icons.visibility_off : Icons.visibility, // Change icon based on visibility
        color: Colors.black,
      ),
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: rememberUser,
              onChanged: (value) {
                setState(() {
                  rememberUser = value!;
                });
              },
            ),
            buildGreyText("Remember me"),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: buildGreyText("Forgot password"),
        )
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        loginUser(); // Call the login function when the login button is pressed
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: Colors.black,
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text("LOG IN", style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,),
    ));
  }

  Widget _buildSigninButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Center(
        child: TextButton(
          onPressed: () {
            setState(() {
              isSignin = true;
            });
          },
          child: buildGreyText("Sign In"),
        ),
      ),
    );
  }

  Widget _buildSigninForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSigninTop(),
        Expanded(
          child: SingleChildScrollView(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildGreyText("Please enter your credentials"),
                  const SizedBox(height: 20),
                  buildGreyText("Username"),
                  _buildInputField(userNameController, isPassword: false),
                  const SizedBox(height: 20),
                  buildGreyText("Email address"),
                  _buildInputField(emailController, isPassword: false),
                  const SizedBox(height: 20),
                  buildGreyText("Password"),
                  _buildInputField(passwordController, isPassword: true),
                  const SizedBox(height: 20),
                  buildGreyText("Confirm password"),
                  _buildInputField(confirmPasswordController, isPassword: true),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        _buildSigninButtonExecute(),
      ],
    );
  }

  Widget _buildSigninTop() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                isSignin = false;
              });
            },
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: Colors.white,
              elevation: 3,
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 50),
          const Text(
            "SIGN IN",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSigninButtonExecute() {
    return ElevatedButton(
      onPressed: () {
        registerUser(); // Call the register function when the sign-up button is pressed
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: Colors.black,
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text("SIGN IN", style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),),
    );
  }


// Login Function
  Future<void> loginUser() async {
    String url = 'https://capolavoro5ait.altervista.org/api.php?action=login';

    // Prepare the request body
    Map<String, String> body = {
      'username': emailController.text, // Can be username or email
      'password': passwordController.text,
    };
    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        body: body,
      );

      // Check the response
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          debugPrint('Login successful: ${data['message']}');
          
          // Recupera il nome utente dalla risposta
          String username = data['data']['username'];
          String password = data['data']['password'];

          if (!mounted) return; // Check if the widget is still mounted
          // Passa il nome utente alla HomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(username: username, password: password)),
          );

        } else {
          debugPrint('Error: ${data['message']}');
          if (!mounted) return;
          _showMyDialog(data['message']);
        }
      } else {
        debugPrint('Request error: ${response.statusCode}');
        if (!mounted) return;
        _showMyDialog('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (!mounted) return;
      _showMyDialog('An error occurred: $e');
    }
  }


  // Register Function
  Future<void> registerUser() async {
    String url = 'https://capolavoro5ait.altervista.org/api.php?action=register';

    // Prepare the request body
    Map<String, String> body = {
      'username': userNameController.text,
      'email': emailController.text,
      'password': passwordController.text,
    };

    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        body: body,
      );

      // Check the response
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          debugPrint('Registration successful: ${data['message']}');

          // Recupera il nome utente dalla risposta
          String username = data['data']['username'];
          String password = data['data']['password'];
          
          if (!mounted) return; // Check if the widget is still mounted
          // Navigate to the LoginPage or HomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(username: username, password: password)),
          );
        } else {
          debugPrint('Error: ${data['message']}');
          if (!mounted) return; // Check if the widget is still mounted
          _showMyDialog(data['message']);
        }
      } else {
        debugPrint('Request error: ${response.statusCode}');
        if (!mounted) return; // Check if the widget is still mounted
        _showMyDialog('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (!mounted) return; // Check if the widget is still mounted
      _showMyDialog('An error occurred: $e');
    }
  }



  Future<void> _showMyDialog(String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Registration Status',
          style: TextStyle(color: Colors.black), // White text for title
        ),
        backgroundColor: const Color.fromARGB(178, 244, 67, 54), // Red background for the dialog
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                message, // Display the dynamic message here
                style: const TextStyle(color: Color.fromARGB(255, 29, 29, 29)), // White text for message
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.black), // White text for the button
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

}
