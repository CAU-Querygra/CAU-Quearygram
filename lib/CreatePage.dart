import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'provider_data.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final titleEditingController = TextEditingController();
  final contentEditingController = TextEditingController();

  File? _image;

  @override
  void dispose() {
    titleEditingController.dispose();
    contentEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Question'),
        actions: [
          IconButton(
              icon: Icon(Icons.upload),
              onPressed: () async {
                if (titleEditingController.text == '' &&
                    contentEditingController.text == '') return;

                final user_id = context.read<UserData>().id;
                final class_id = context.read<LectureData>().lecture_id;

                if (_image != null) {
                  TaskSnapshot task = await FirebaseStorage.instance
                      .ref()
                      .child('question_images')
                      .child(user_id + titleEditingController.text)
                      .putFile(_image!);

                  if (task != null) {
                    var downloadUrl = await task.ref.getDownloadURL();

                    FirebaseFirestore.instance.collection('Question').add({
                      'author': user_id,
                      'title': titleEditingController.text,
                      'commenting': contentEditingController.text,
                      'image_url': downloadUrl.toString(),
                      'timestamp': Timestamp.now(),
                      'comments': <String>[],
                      "class_id": class_id
                    }).then((onValue) {
                      Navigator.pop(context);
                    });
                  }
                } else {
                  FirebaseFirestore.instance.collection('Question').add({
                    'author': user_id,
                    'title': titleEditingController.text,
                    'commenting': contentEditingController.text,
                    'image_url': '',
                    'timestamp': Timestamp.now(),
                    'comments': <String>[],
                    "class_id": class_id
                  }).then((onValue) {
                    Navigator.pop(context);
                  });
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: _image == null
                    ? Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Image(
                            image: AssetImage('assets/images/no_image.png'),
                            height: 200,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text('No image'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.add_a_photo),
                                onPressed: () async {
                                  var image = await ImagePicker()
                                      .pickImage(source: ImageSource.camera);
                                  setState(() {
                                    _image = File(image!.path);
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.add_photo_alternate),
                                onPressed: () async {
                                  var image = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  setState(() {
                                    _image = File(image!.path);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    : Image.file(_image!)),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: titleEditingController,
              decoration: InputDecoration(
                  hintText: 'Enter the title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.5),
                  )),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              maxLines: 10,
              controller: contentEditingController,
              decoration: InputDecoration(
                  hintText: 'Enter the content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.5),
                  )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        tooltip: 'Refresh image',
        onPressed: () {
          setState(() {
            _image = null;
          });
        },
      ),
    );
  }
}
