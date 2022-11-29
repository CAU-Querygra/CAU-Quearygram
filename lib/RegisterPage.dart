import 'package:instagram/SuccessRegister.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: const RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _authentication = FirebaseAuth.instance;
  final _formekey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String userName = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formekey,
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
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'User Name',
              ),
              onChanged: (value) {
                userName = value;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    final newUser =
                    await _authentication.createUserWithEmailAndPassword(
                        email: email, password: password);
                    await FirebaseFirestore.instance
                        .collection('user')
                        .doc(newUser.user!.uid)
                        .set({
                      'userName': userName,
                      'email': email,
                    });

                    if (newUser.user != null) {
                      _formekey.currentState!.reset();
                      if (!mounted) return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const SuccessRegisterPage()));
                    }
                  } catch (e) {
                    print("****************************************\n");
                    print(e);
                    print("****************************************\n");
                  }
                },
                child: const Text("Enter")),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('If you already registered, '),
                TextButton(
                  child: const Text("login with your email."),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
