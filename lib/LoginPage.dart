import 'package:instagram/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool showSpinner = false;
  final _authentication = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formkey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  onChanged: (value) {
                    email = value;
                    print(email);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  onChanged: (value) {
                    password = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          showSpinner = true;
                        });
                        final currentUser =
                        await _authentication.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (currentUser != null) {
                          _formkey.currentState!.reset();
                          if (!mounted) return;
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      } catch (e) {
                        print("*********************************\n");
                        print(e);
                        print("*********************************\n");
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    },
                    child: const Text("Enter")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('If you did not register, '),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()));
                      },
                      child: const Text("Register your email."),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
