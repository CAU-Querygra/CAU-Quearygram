import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/CreatePage.dart';
import 'package:instagram/Detail.dart';
import 'package:instagram/provider_data.dart';
import 'package:provider/provider.dart';

class QuestionList extends StatefulWidget {
  final dynamic document;

  const QuestionList(this.document, {super.key});

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document['name'],
            style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreatePage()));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.create),
      ),
    );
  }
}

Widget _buildBody() {
  final firestore = FirebaseFirestore.instance;

  return StreamBuilder(
    stream: firestore.collection('Question').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      final docs = snapshot.data!.docs.where((el) {
        return el.data()['class_id'] == context.read<LectureData>().lecture_id;
      }).toList();
      return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return _buildListItem(context, docs[index]);
          });
    },
  );
}

Widget _buildListItem(BuildContext context, document) {
  var question = document.data();

  return Padding(
    padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
    child: InkWell(
      onTap: () {
        context.read<LectureData>().set_question_id(document.id.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Detail(),
            ));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    question['image_url'] == ''
                        ? 'https://s3.orbi.kr/data/file/united/2f0143587553c051ebf38dd831c5edc3.png'
                        : document['image_url'],
                    width: 100,
                    height: 100,
                  )),
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(question['title'],
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(question['commenting'],
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Icon(Icons.comment_outlined),
                Text(
                  question['comments'].length.toString(),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                )
              ]),
              const SizedBox(height: 10),
              Text(question['timestamp'].toDate().toString().substring(0, 10),
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold))
            ],
          )
        ],
      ),
    ),
  );
}
