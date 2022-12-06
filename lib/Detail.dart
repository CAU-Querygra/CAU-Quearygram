import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:instagram/provider_data.dart';
import 'dart:math';

//불러오실 때 return Detail() 이런식으로 불러오시면 됩니다!
//호출하기 전에 provider에서 set_question_id로 question id 지정해주셔야 됩니다!
//호출하기 전에 provider에서 set_lecture_id로 lecture id도 지정해주셔야 됩니다!

class Detail extends StatelessWidget {
  const Detail({super.key});
  @override
  //AppBar 구현
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LectureName(),
      ),
      body: const DetailedPage(),
    );
  }
}

//DetailedPage: 페이지 구조/레이아웃 생성
class DetailedPage extends StatefulWidget {
  const DetailedPage({super.key});
  @override
  State<DetailedPage> createState() => _DetailedPage();
}

class _DetailedPage extends State<DetailedPage> {
  String printTime(DateTime time) {
    DateTime t = time.add(const Duration(hours: 9));
    return "${t.year - 2000}년 ${t.month}월 ${t.day}일 ${t.hour}시 ${t.minute}분";
  }

  @override
  Widget build(BuildContext context) {
    final questionId = context.read<LectureData>().question_id; //provider 사용
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            //많은 내용을 스크롤로 관리하기 위해 사용한 위젯
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Question')
                    .doc(questionId)
                    .snapshots(), //question document snapshot 얻어옴
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } //실행 전까지는 spinning 화면 출력

                  //변수 선언부
                  final collections = snapshot.data!.data();
                  final title = collections!["title"].toString();
                  final commenting = collections["commenting"].toString();
                  final img = collections["image_url"].toString();
                  final standardTime = collections["timestamp"].toDate();
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
                      ), // @@@이미지파일 표시
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
                      ), // @@@제목
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
                      ), // @@@질문 내용
                      Column(
                        children: [
                          StudentName(author, false),
                          ProfName(author, false),
                          Row(children: [
                            Text(
                              printTime(standardTime),
                              style: const TextStyle(fontSize: 17),
                            )
                          ]),
                        ],
                      ), // @@@작성 정보
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
                      ), // @@@Comments 제목
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CommentsView(comments),
                      ), // @@@Comments 리스트뷰 출력
                    ],
                  );
                }),
          ),
        ),
        NewMessage(questionId),
      ],
    );
  }
}

class StudentName extends StatefulWidget {
  final bool option;
  final String author;
  const StudentName(this.author, this.option, {super.key});

  @override
  State<StudentName> createState() => _StudentNameState();
}

class _StudentNameState extends State<StudentName> {
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
            return const SizedBox(height: 0);
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
            return const SizedBox(height: 0);
          }
          if (!widget.option) {
            return Row(
              children: [
                Expanded(
                  child: Text(
                    "작성자: ${snapshot.data!.data()!["name"].toString()} 교수",
                    style: const TextStyle(fontSize: 20, color: Colors.indigo),
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
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.indigo),
            );
          }
        });
  }
}

class CommentsView extends StatefulWidget {
  final List comments;
  const CommentsView(this.comments, {super.key});
  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
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
  String printTime(DateTime time) {
    DateTime t = time;
    return "${t.year - 2000}년 ${t.month}월 ${t.day}일 ${t.hour}시 ${t.minute}분";
  }

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
                    StudentName(author, true),
                    ProfName(author, true),
                    const SizedBox(
                      width: 50,
                    ),
                    Text(printTime(time))
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

class LectureName extends StatelessWidget {
  const LectureName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Class')
            .doc(context.read<LectureData>().lecture_id)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return const CircularProgressIndicator();
          }
          return Text(
            snapshot.data.data()["name"].toString(),
            style: const TextStyle(fontSize: 20),
          );
        });
  }
}
