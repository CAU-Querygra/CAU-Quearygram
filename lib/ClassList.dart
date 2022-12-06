import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/QuestionList.dart';
import 'package:provider/provider.dart';
import 'package:instagram/provider_data.dart';
import 'dart:math';

class ClassList extends StatefulWidget {
  const ClassList({Key? key}) : super(key: key);

  @override
  State<ClassList> createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CAU Querygram',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
            ),
            onPressed: () {
              signOutWithGoogle();
            },
          )
        ],
      ),
      body: _buildBody(),
    );
  }
}

Widget _buildBody() {
  final firestore = FirebaseFirestore.instance;

  return StreamBuilder(
    stream: firestore.collection('Class').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      final docs = snapshot.data!.docs;
      return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return _buildListItem(context, docs[index]);
          });
    },
  );
}

Widget _buildListItem(BuildContext context, document) {
  final firestore = FirebaseFirestore.instance;

  getProfessorName(uid) async {
    var res = await firestore.collection('Professor').doc(uid).get();
    return res.data()!['name'].toString();
  }

  var colors = [
    0xFDB74093,
    0xBAB24093,
    0xEACA4093,
    0xABB74093,
    0xDFAC1542,
    0xAFCFEA43,
    0xCDA14021,
    0xFFB74093,
    0xCEBA4013,
    0xAAB7A09A,
    0xDBB74A93,
    0x13ABCD65,
    0x73D2AB24
  ];
  Random random = Random();
  return InkWell(
      onTap: () {
        context.read<LectureData>().set_lecture_id(document.id.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionList(document),
            ));
      },
      child: FutureBuilder<dynamic>(
          future: getProfessorName(document['professor_id']),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(children: [
                Opacity(
                    opacity: 0.5,
                    child: SizedBox(
                      height: 70,
                      child: Container(
                        color: Color(colors[random.nextInt(13)]),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '${document['name']}',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            snapshot.data,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ]);
            }
            return const CircularProgressIndicator();
          }));
}

Future<void> signOutWithGoogle() async {
  await FirebaseAuth.instance.signOut();
}
