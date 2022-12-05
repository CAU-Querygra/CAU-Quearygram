import 'package:instagram/SuccessRegister.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
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
  String className = "";
  
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final usernameTextController = TextEditingController();

  bool _isProfessor = false;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formekey,
        child: ListView(
          children: [
            Image.asset('assets/images/logo.png', height: 100, width: 100),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '중앙대학교 이메일을 작성해주세요',
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
                labelText: '비밀번호',
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
                labelText: '사용자 이름',
              ),
              onChanged: (value) {
                userName = value;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text("학생"),
                Switch(value: _isProfessor, onChanged: (value) {
                  setState(() {
                    _isProfessor = value;
                  });
                }),
                const Text("교수"),
              ],
            ),
            if(_isProfessor)
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '과목 이름',
                ),
                onChanged: (value) {
                  className = value;
                },
              ),
            ElevatedButton(
                onPressed: () async {
                  String classId = generateRandomString(20);
                  try {
                    final newUser =
                    await _authentication.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (_isProfessor == true) {
                      await FirebaseFirestore.instance
                          .collection('Class').doc(classId)
                          .set ({
                        'name': className,
                        'professor_id': newUser.user!.uid
                      });
                      await FirebaseFirestore.instance
                          .collection('Professor')
                          .doc(newUser.user!.uid)
                          .set({
                        'name': userName,
                        'email': email,
                        'class': classId
                      });
                    } else {
                      await FirebaseFirestore.instance
                          .collection('user')
                          .doc(newUser.user!.uid)
                          .set({
                        'name': userName,
                        'email': email,
                      });
                    }

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
                child: const Text("가입하기")),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('이미 가입을 하셨다면, '),
                TextButton(
                  child: const Text("이메일로 로그인 해주세요."),
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

String generateRandomString(int length) {
  final random = Random();
  const availableChars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final randomString = List.generate(length,
          (index) => availableChars[random.nextInt(availableChars.length)])
      .join();
  return randomString;
}
