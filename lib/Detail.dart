import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:instagram/provider_data.dart';

//불러오실 때 return Detail('rrfAI0l62W2AqAcBUPn6') 이런식으로 불러오시면 됩니다!
//Detail 내에 들어갈 변수는 firestore 'Question'의 'Document_ID'입니다!

class Detail extends StatelessWidget {

  @override
  //AppBar 구현
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '게시물 보기',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: DetailedPage(),
    );
  }
}

class DetailedPage extends StatefulWidget {
  @override
  State<DetailedPage> createState() => _DetailedPage();
}

class _DetailedPage extends State<DetailedPage> {
  @override
  Widget build(BuildContext context) {
    final question_id = context.read<LectureData>().question_id;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Question')
                    .doc(question_id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  //변수 선언부
                  final collections = snapshot.data!.data();
                  final title = collections!["title"].toString();
                  final commenting = collections["commenting"].toString();
                  final img = collections["image_url"].toString();
                  final time = collections["timestamp"].toDate();
                  final comments = collections["comments"];
                  final author = collections["author"];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Image.network(
                          img,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border:
                              Border.all(color: Colors.black, width: 1.5)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  commenting,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          LeekangeunAuthor(author, false),
                          Row(
                            children: [
                              Text(
                                  "작성일자: ${time.year}년 ${time.month}월 ${time.day}일 "
                                      "${time.hour}시 ${time.minute}분 ${time.second}초"),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Text(
                            "  Comments",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LeekangeunComments(comments),
                      ),
                    ],
                  );
                }),
          ),
        ),
        NewMessage(question_id),
      ],
    );
  }
}

class LeekangeunAuthor extends StatefulWidget {
  final bool option;
  final String author;
  const LeekangeunAuthor(this.author, this.option, {super.key});

  @override
  State<LeekangeunAuthor> createState() => _LeekangeunAuthorState();
}

class _LeekangeunAuthorState extends State<LeekangeunAuthor> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(widget.author)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data?.data() == null) {
            return const Text("");
          }
          if (!widget.option) {
            return Row(
              children: [
                Expanded(
                  child: Text(
                    "작성자: ${snapshot.data!.data()!["name"].toString()} 학생",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Text(
                    "(${snapshot.data!.data()!["email"].toString()})",
                    style: const TextStyle(fontSize: 15),
                  ),
                )
              ],
            );
          } else {
            return Text(
              "${snapshot.data!.data()!["name"].toString()} 학생",
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            );
          }
        });
  }
}

class LeekangeunComments extends StatefulWidget {
  final List comments;
  const LeekangeunComments(this.comments, {super.key});
  @override
  State<LeekangeunComments> createState() => _LeekangeunCommentsState();
}

class _LeekangeunCommentsState extends State<LeekangeunComments> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.comments.length,
      itemBuilder: (context, index) {
        return Comments(widget.comments[index]);
      },
    );
  }
}

class Comments extends StatefulWidget {
  final String comments;
  const Comments(this.comments, {super.key});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Comment')
            .doc(widget.comments)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final collections = snapshot.data!.data();
          final author = collections!["author"].toString();
          final content = collections["content"].toString();
          final time = collections["timestamp"].toDate();
          return Container(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    LeekangeunAuthor(author, true),
                    ProfName(author, true),
                    const SizedBox(
                      width: 50,
                    ),
                    Text("${time.year - 2000}년 ${time.month}월 ${time.day}일 "
                        "${time.hour}시 ${time.minute}분")
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      content,
                      style: const TextStyle(fontSize: 16),
                    )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }
}

class ProfName extends StatefulWidget {
  final bool option;
  final String author;
  const ProfName(this.author, this.option, {super.key});

  @override
  State<ProfName> createState() => _ProfNameState();
}

class _ProfNameState extends State<ProfName> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Professor')
            .doc(widget.author)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data?.data() == null) {
            return const Text("");
          }
          if (!widget.option) {
            return Row(
              children: [
                Expanded(
                  child: Text(
                    "작성자: ${snapshot.data!.data()!["name"].toString()} 교수",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Text(
                    "(${snapshot.data!.data()!["email"].toString()})",
                    style: const TextStyle(fontSize: 15),
                  ),
                )
              ],
            );
          } else {
            return Text(
              "${snapshot.data!.data()!["name"].toString()} 교수",
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            );
          }
        });
  }
}

class NewMessage extends StatefulWidget {
  final String question;
  const NewMessage(this.question, {super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String newMessage = '';

  String generateRandomString(int length) {
    final random = Random();
    const availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(length,
            (index) => availableChars[random.nextInt(availableChars.length)])
        .join();

    return randomString;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
      child: Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(
              left: 9,
              right: 9,
              bottom: 9,
            ),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "New Comment",
              ),
              onChanged: (value) {
                setState(() {
                  newMessage = value;
                });
              },
            ),
          )),
          IconButton(
              color: Colors.blue,
              onPressed: newMessage.trim().isEmpty
                  ? null
                  : () async {
                      final comments = FirebaseFirestore.instance
                          .collection('Question')
                          .doc(widget.question);
                      final documentKey = generateRandomString(20);
                      FirebaseFirestore.instance
                          .collection('Comment')
                          .doc(documentKey)
                          .set({
                        'author': context.read<UserData>().id,
                        'content': newMessage,
                        'question_id': widget.question,
                        'timestamp': Timestamp.now(),
                      });
                      comments.update({
                        "comments": FieldValue.arrayUnion([documentKey]),
                      });
                      _controller.clear();
                    },
              icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
