import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'provider_data.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CAU-QueryGram'),
      ),
      body:const LoginForm()
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
  final emailText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {  },
      builder: (context, child) => ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formkey,
              child: ListView(
                children: [
                  Image.asset('assets/images/logo.png', height: 150, width: 150),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: emailText,
                    decoration: const InputDecoration(
                      labelText: '중앙대학교 이메일을 입력해주세요',
                    ),
                    onChanged: (value) {
                      email = value;
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
                          if (email.isValidEmailFormat() == true) {
                            try {
                              setState(() {
                                showSpinner = true;
                              });
                            final currentUser =
                            await _authentication.signInWithEmailAndPassword(
                                email: email, password: password);
                            if (currentUser != null) {
                              _formkey.currentState!.reset();
                              var snapshot = await FirebaseFirestore.instance
                              .collection('user')
                              .doc(currentUser.user!.uid)
                              .get();
                              if (!snapshot.exists) {
                                throw Exception('Does not exists');
                              }
                              final username = snapshot.data()!['name'];
                              if (!mounted) return;
                              setState(() {
                                context.read<UserData>().set_user_data(currentUser,currentUser.user!.uid, username.toString(), email);
                                showSpinner = false;
                              });
                            }
                          } catch (e) {
                          setState(() {
                            showSpinner = false;
                          });
                        }
                          } else {
                            setState(() {
                              emailText.clear();
                            });
                          }
                      },
                      child: const Text("로그인")),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('회원가입하지 않았다면, '),
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
          )),
    );
  }
}

extension InputValidate on String {
  //이메일 포맷 검증
  bool isValidEmailFormat() {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@cau.ac.kr+")
        .hasMatch(this);
  }
  //대쉬를 포함하는 010 휴대폰 번호 포맷 검증 (010-1234-5678)
  bool isValidPhoneNumberFormat() {
    return RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$').hasMatch(this);
  }
}
