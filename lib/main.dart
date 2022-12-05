import 'package:instagram/ClassList.dart';
import 'package:instagram/LoginPage.dart';
import 'package:instagram/TabPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/provider_data.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'dart:io';

void main() async {
  HttpOverrides.global =
      NoCheckCertificateHttpOverrides(); // 생성된 HttpOverrides 객체 등록 (url로 image 로드 가능하게 하는 코드)
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
      providers: [
        ListenableProvider(create: (context) => UserData()),
        ListenableProvider(create: (context) => LectureData()),
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Colors.white,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(secondary: Colors.black)),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final user = FirebaseAuth.instance.currentUser;
          if (snapshot.hasData) {
            context.read<UserData>().set_user_data(user,user!.uid, user.displayName.toString(), user.email);
            return ClassList();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

class NoCheckCertificateHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
